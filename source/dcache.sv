import cpu_types_pkg::*;

module dcache (
	input logic CLK, nRST,
	datapath_cache_if.dcache dcif,
	caches_if.dcache cif
);

typedef enum logic[3:0] {
	IDLE, WB1, WB2, ALL1, ALL2, FLUSH1, FLUSH2, DIRTY, HALT, CHK, SHARE1, SHARE2, INV
} states;
states state, next_state;

dcache_frame dframe[1:0][7:0]; //1 = left, 0 = right

logic [25:0] tag, snooptag;
logic [2:0] ind, snoopind;
logic offset, snoopoffset;

logic used[7:0], next_used[7:0];
logic [4:0] row, next_row;
logic [2:0] row_sel;

word_t linkreg, next_linkreg;
logic miss, linkreg_valid, next_linkreg_valid;

//s is for snoop
logic [25:0] Ltag, Rtag, sLtag, sRtag;
word_t Ldata1, Ldata2, Rdata1, Rdata2, sLdata1, sLdata2, sRdata1, sRdata2;
logic Ldirty, Lvalid, Rdirty, Rvalid, sLdirty, sLvalid, sRdirty, sRvalid;

logic snoophitL, snoophitR;
logic next_snoophitL, next_snoophitR;
logic snoopdirty;

//ff for frames
always_ff @(posedge CLK, negedge nRST) begin
	if(~nRST) begin
		 for (int i = 0; i < 8; i++) begin
			dframe[1][i] <= '0;
			dframe[0][i] <= '0;
		 end

		 for (int i = 0; i < 8; i++)
		 	used[i] <= 0;
		 row <= 0;
		 snoophitL <= 0;
		 snoophitR <= 0;
		 linkreg <= 0;
		 linkreg_valid <= 0;

		 state <= IDLE;
	end 
	else begin
		for (int i = 0; i < 8; i++)
		 	used[i] <= next_used[i];
		row <= next_row;
		snoophitL <= next_snoophitL;
		snoophitR <= next_snoophitR;
		linkreg <= next_linkreg;
		linkreg_valid <= next_linkreg_valid;

		dframe[1][ind].data[0] <= Ldata1;
		dframe[1][ind].data[1] <= Ldata2;
		dframe[1][ind].dirty <= Ldirty;
		dframe[1][ind].valid <= Lvalid;
		dframe[1][ind].tag <= Ltag;
		
		dframe[0][ind].data[0] <= Rdata1;
		dframe[0][ind].data[1] <= Rdata2;
		dframe[0][ind].dirty <= Rdirty;
		dframe[0][ind].tag <= Rtag;
		dframe[0][ind].valid <= Rvalid;

		//snoopy stuff
		if(state == SHARE1 || state == SHARE2 || state == CHK) begin
			dframe[1][snoopind].data[0] <= sLdata1;
			dframe[1][snoopind].data[1] <= sLdata2;
			dframe[1][snoopind].dirty <= sLdirty;
			dframe[1][snoopind].tag <= sLtag;
			dframe[1][snoopind].valid <= sLvalid;

			dframe[0][snoopind].data[0] <= sRdata1;
			dframe[0][snoopind].data[1] <= sRdata2;
			dframe[0][snoopind].tag <= sRtag;
			dframe[0][snoopind].dirty <= sRdirty;
			dframe[0][snoopind].valid <= sRvalid;
		end

		state <= next_state;
	end
end

//next state
always_comb begin 
	offset = dcif.dmemaddr[2];
	snoopoffset = cif.ccsnoopaddr[2];
	ind = dcif.dmemaddr[5:3];
	snoopind = cif.ccsnoopaddr[5:3];
	tag = dcif.dmemaddr[31:6];
	snooptag = cif.ccsnoopaddr[31:6];

	next_state = state;
	next_row = row;
	row_sel = row[2:0] - 1; //which frame is getting selected
	cif.cctrans = 0;
	cif.ccwrite = dcif.dmemWEN;
	case(state)
		IDLE : begin
			if (dcif.halt) next_state = DIRTY;
			else if (cif.ccwait) next_state = CHK;
			else if (miss) begin 
				if (used[ind] == 0) begin
					next_state = dframe[1][ind].dirty? WB1:ALL1;
					cif.cctrans = ~dframe[1][ind].dirty;
				end 
				else begin
					next_state = dframe[0][ind].dirty? WB1:ALL1;
					cif.cctrans = ~dframe[0][ind].dirty;
				end
			end
		end
		WB1 : begin
			if (~cif.dwait) next_state = WB2;
		end
		WB2 : begin
			if (~cif.dwait) next_state = ALL1;
		end
		ALL1 : begin
			cif.cctrans = ~cif.ccwait;
			if (~cif.dwait) next_state = ALL2;
			if (cif.ccwait) next_state = CHK;
		end
		ALL2 : begin
			if (~cif.dwait) next_state = IDLE;
		end
		DIRTY : begin
			if (row < 8) begin
				if(dframe[1][row[2:0]].dirty && dframe[1][row[2:0]].valid) begin
					next_state = FLUSH1;
				end
			end else begin
				if(dframe[0][row[2:0]].dirty && dframe[0][row[2:0]].valid) begin
					next_state = FLUSH1;
				end
			end
			next_row = row + 1;
		 	if(row == 5'b10000)
		 		next_state = HALT; 
		end
		FLUSH1 : begin
			if (~cif.dwait) next_state = FLUSH2;
		end
		FLUSH2 : begin
			if (~cif.dwait) next_state = DIRTY;
		end
		CHK : begin
			if(cif.ccwait) begin
				next_state = snoopdirty? SHARE1 : CHK;
				cif.cctrans = snoopdirty;
				if ((next_snoophitL || next_snoophitR) == 0) next_state = CHK;
			end else next_state = IDLE;
		end
		SHARE1 : begin
			if (~cif.dwait) next_state = SHARE2;
		end
		SHARE2 : begin
			if (~cif.dwait) next_state = INV;
		end
		INV: begin
			next_state = IDLE;
		end
	endcase 
end

//output

integer j;
always_comb begin 
	miss = 0;
	dcif.dhit = 0;
	dcif.dmemload = 0;
	cif.dREN = 0;
	cif.dWEN = 0;
	cif.daddr = 0;
	cif.dstore = 0;

	dcif.flushed = 0;

	Ldata1 = dframe[1][ind].data[0]; 
	Ldata2 = dframe[1][ind].data[1];
	Ldirty = dframe[1][ind].dirty;
	Lvalid = dframe[1][ind].valid; 
	Ltag =   dframe[1][ind].tag;
	Rdata1 = dframe[0][ind].data[0];
	Rdata2 = dframe[0][ind].data[1];
	Rdirty = dframe[0][ind].dirty;
	Rvalid = dframe[0][ind].valid;
	Rtag =   dframe[0][ind].tag;

	sLdata1 =  dframe[1][snoopind].data[0]; 
	sLdata2 =  dframe[1][snoopind].data[1];
	sLdirty =  dframe[1][snoopind].dirty;
	sLvalid =  dframe[1][snoopind].valid; 
	sLtag =    dframe[1][snoopind].tag;
	sRdata1 = dframe[0][snoopind].data[0];
	sRdata2 = dframe[0][snoopind].data[1];
	sRdirty = dframe[0][snoopind].dirty;
	sRvalid = dframe[0][snoopind].valid;
	sRtag =   dframe[0][snoopind].tag;

	for(int i = 0; i < 8; i++) next_used[i] = used[i];

	next_snoophitL = snoophitL;
	next_snoophitR = snoophitR;
	snoopdirty = 0;
	//LL SC
	next_linkreg_valid = linkreg_valid;
	next_linkreg = linkreg;
	case(state)
		IDLE : begin
			if (dcif.dmemREN) begin
				if (dcif.datomic) begin
					next_linkreg = dcif.dmemaddr;
					next_linkreg_valid = 1;
				end
				if ((tag == dframe[1][ind].tag) && dframe[1][ind].valid) begin
					dcif.dhit = 1;
					dcif.dmemload = offset? dframe[1][ind].data[1]:dframe[1][ind].data[0];
					next_used[ind] = 1;
				end 
				else if ((tag == dframe[0][ind].tag) && dframe[0][ind].valid) begin
					dcif.dhit = 1;
					dcif.dmemload = offset? dframe[0][ind].data[1]:dframe[0][ind].data[0];
					next_used[ind] = 0;
				end 
				else begin
					miss = 1;
					if(next_used[ind] == 0) begin
						Ldirty = 0; Lvalid = 1;
					end 
					else begin
						Rdirty = 0; Rvalid = 1;
					end
				end
			end 
			else if (dcif.dmemWEN) begin
				
				if (dcif.datomic) begin
					
					dcif.dmemload = (dcif.dmemaddr == linkreg) && linkreg_valid;

					//SC's SW part, store only when addr is correct, and hasn't been inv-ed
					if((dcif.dmemaddr == linkreg) && linkreg_valid) begin
						if ((tag == dframe[1][ind].tag) && dframe[1][ind].valid) begin
							if (!dframe[1][ind].dirty ) begin 
								miss = 1; //treat it as a miss
								Ldirty = 1;
								next_used[ind] = 0;
							end else begin
								if(offset == 0) 
									Ldata1 = dcif.dmemstore;
								else 
									Ldata2 = dcif.dmemstore;
								next_linkreg_valid = 0;
								next_linkreg = 0;
								dcif.dhit = 1;
								Ldirty = 1;
								next_used[ind] = 1;
							end
						end else if ((tag == dframe[0][ind].tag) && dframe[0][ind].valid) begin
							if (!dframe[0][ind].dirty && dframe[0][ind].valid) begin
								miss = 1;
								Rdirty = 1;
								next_used[ind] = 1;
							end else begin
								if(offset == 0) 
									Rdata1 = dcif.dmemstore;
								else 
									Rdata2 = dcif.dmemstore;
								next_linkreg_valid = 0;
								next_linkreg = 0;
								dcif.dhit = 1;
								Rdirty = 1;
								next_used[ind] = 0;
								
							end
						end else begin
							miss = 1;
							if(next_used[ind] == 0) begin
								Ldirty = 0; 
								Lvalid = 1;
							end else begin
								Rdirty = 0; 
								Rvalid = 1;
							end
						end
					end 
					else begin
						dcif.dhit = 1;
					end
				end
				else begin
				if (dcif.dmemaddr == linkreg) begin
					next_linkreg_valid = 0;
					next_linkreg = 0;
				end
				if ((tag == dframe[1][ind].tag) && dframe[1][ind].valid) begin
					if (!dframe[1][ind].dirty) begin 
						miss = 1; 
						Ldirty = 1;
						next_used[ind] = 0;
					end else begin
						if(offset == 0) 
							Ldata1 = dcif.dmemstore;
						else 
							Ldata2 = dcif.dmemstore;
						dcif.dhit = 1;
						Ldirty = 1;
						next_used[ind] = 1;
					end
				end else if ((tag == dframe[0][ind].tag) && dframe[0][ind].valid) begin
					if (!dframe[0][ind].dirty) begin
						miss = 1;
						Rdirty = 1;
						next_used[ind] = 1;
					end else begin
						if(offset == 0) 
							Rdata1 = dcif.dmemstore;
						else 
							Rdata2 = dcif.dmemstore;
						dcif.dhit = 1;
						Rdirty = 1;
						next_used[ind] = 0;
					end
				end else begin
					miss = 1;
					if(next_used[ind] == 0) begin
						Ldirty = 0; 
						Lvalid = 1;
					end else begin
						Rdirty = 0; 
						Rvalid = 1;
					end
				end
				
			end
			end
		end
		WB1 : begin
			cif.dWEN = 1;
			if(used[ind] == 0) begin
				cif.daddr = {dframe[1][ind].tag, ind, 3'b000};
				cif.dstore = dframe[1][ind].data[0];
			end 
			else begin
				cif.daddr = {dframe[0][ind].tag, ind, 3'b000};
				cif.dstore = dframe[0][ind].data[0];
			end
		end
		WB2 : begin
			cif.dWEN = 1;
			if(used[ind] == 0) begin
				cif.daddr = {dframe[1][ind].tag, ind, 3'b100};
				cif.dstore = dframe[1][ind].data[1];
			end 
			else begin
				cif.daddr = {dframe[0][ind].tag, ind, 3'b100};
				cif.dstore = dframe[0][ind].data[1];
			end
		end
		ALL1 : begin
			cif.dREN = 1;
			cif.daddr = {tag, ind, 3'b000};
			if (used[ind] == 0) begin
				Ldata1 = cif.dload;
			end 
			else begin
				Rdata1 = cif.dload;
			end
		end
		ALL2 : begin
			cif.dREN = 1;
			cif.daddr = {tag, ind, 3'b100};
			if (used[ind] == 0) begin
				Ldata2 = cif.dload;
				Ltag = tag;
			end 
			else begin
				Rdata2 = cif.dload;
				Rtag = tag;
			end
		end
		FLUSH1 : begin
			cif.dWEN = 1;
			if(row - 1 < 8) begin
				cif.daddr = {dframe[1][row_sel].tag, row_sel, 3'b000};
				cif.dstore = dframe[1][row_sel].data[0];
			end 
			else begin
				cif.daddr = {dframe[0][row_sel].tag, row_sel, 3'b000};
				cif.dstore = dframe[0][row_sel].data[0];
			end
		end
		FLUSH2 : begin
			cif.dWEN = 1;
			if(row - 1 < 8) begin
				cif.daddr = {dframe[1][row_sel].tag, row_sel, 3'b100};
				cif.dstore = dframe[1][row_sel].data[1];
			end 
			else begin
				cif.daddr = {dframe[0][row_sel].tag, row_sel, 3'b100};
				cif.dstore = dframe[0][row_sel].data[1];
			end
		end
		CHK : begin
			if (snooptag == dframe[1][snoopind].tag)
				next_snoophitL = 1;
			else
				next_snoophitL = 0;

			if (snooptag == dframe[0][snoopind].tag)
				next_snoophitR = 1;
			else
				next_snoophitR = 0;	

			if(cif.ccinv && ~snoopdirty) begin
				if(next_snoophitL) begin
					sLvalid = 0;
					sLdirty = 0;
					sLtag = 0;
					sLdata1 = 0;
					sLdata2 = 0;
				end
				if(next_snoophitR) begin
					sRvalid = 0;
					sRdirty = 0;
					sRtag = 0;
					sRdata1 = 0;
					sRdata2 = 0;
				end
			end

			if(next_snoophitL) 
				snoopdirty = dframe[1][snoopind].dirty;
			if(next_snoophitR) 
				snoopdirty = dframe[0][snoopind].dirty;

		end
		SHARE1 : begin
			if(snoophitL) begin
				cif.daddr = {dframe[1][snoopind].tag, snoopind, 3'b000};
				cif.dstore = dframe[1][snoopind].data[0];
				sLdirty = 0;
			end else if(snoophitR) begin
				cif.daddr = {dframe[0][snoopind].tag, snoopind, 3'b000};
				cif.dstore = dframe[0][snoopind].data[0];
				sRdirty = 0;
			end
		end
		SHARE2 : begin
			if(snoophitL) begin
				cif.daddr = {dframe[1][snoopind].tag, snoopind, 3'b100};
				cif.dstore = dframe[1][snoopind].data[1];
				sLdirty = 0;
			end else if(snoophitR) begin
				cif.daddr = {dframe[0][snoopind].tag, snoopind, 3'b100};
				cif.dstore = dframe[0][snoopind].data[1];
				sRdirty = 0;
			end
		end
		INV: begin
			if(cif.ccinv) begin
				if(snoophitL) begin
					sLvalid = 0;
					sLdirty = 0;
					sLtag = 0;
					sLdata1 = 0;
					sLdata2 = 0;
				end
				if(snoophitR) begin
					sRvalid = 0;
					sRdirty = 0;
					sRtag = 0;
					sRdata1 = 0;
					sRdata2 = 0;
				end
			end
		end
	endcase
	if (state == HALT)
		dcif.flushed = 1;
end

endmodule