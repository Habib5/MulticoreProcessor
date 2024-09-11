`include "datapath_cache_if.vh"
`include "caches_if.vh"
import cpu_types_pkg::*;

module dcache (
	input logic CLK, nRST,
	datapath_cache_if.dcache dcif,
	caches_if.dcache cif
);

typedef enum logic[3:0] {
	IDLE, WB1, WB2, ALL1, ALL2, FLUSH1, FLUSH2, COUNT, DIRTY, HALT
} states;
states state, next_state;

dcache_frame dframe[1:0][7:0];

word_t Ldata1, Ldata2, Rdata1, Rdata2, hits, next_hits;
logic [25:0] tag, Ltag, Rtag;
logic [7:0] used, next_used;
logic [4:0] row, next_row;
logic [2:0] ind, row_idx;
logic Ldirty, Lvalid, Rdirty, Rvalid, offset, miss;
logic vijay; //the best

int i, j; //used for loops: i for ff, j for COMB

//initial assignments
always_comb
begin
	tag = dcif.dmemaddr[31:6];
	ind = dcif.dmemaddr[5:3];
	offset = dcif.dmemaddr[2];
	
	row_idx = row[2:0] - 1;

	if (state == HALT)
		dcif.flushed = 1;
	else
		dcif.flushed = 0;
end

always_ff @(posedge CLK, negedge nRST) begin
	if(~nRST) begin
		for (i = 0; i < 8; i++) begin
			used[i] <= 0;
			dframe[0][i] <= '0;
			dframe[1][i] <= '0;
		end

		row <= 0;
		hits <= 0;

		state <= IDLE;
	end else begin
		for (i = 0; i < 8; i++)
			used[i] <= next_used[i];

		row <= next_row;
		hits <= next_hits;

		dframe[0][ind].data[0] <= Rdata1;
		dframe[0][ind].data[1] <= Rdata2;
		dframe[0][ind].tag <= Rtag;
		dframe[0][ind].dirty <= Rdirty;
		dframe[0][ind].valid <= Rvalid;

		dframe[1][ind].data[0] <= Ldata1;
		dframe[1][ind].data[1] <= Ldata2;
		dframe[1][ind].tag <= Ltag;
		dframe[1][ind].dirty <= Ldirty;
		dframe[1][ind].valid <= Lvalid;

		state <= next_state;
	end
end

always_comb begin 
	next_state = state;
	next_row = row;
	miss = 0;

	cif.daddr = 0;
	cif.dstore = 0;
	cif.dREN = 0;
	cif.dWEN = 0;
	dcif.dhit = 0;
	dcif.dmemload = 0;

	Rdata1 = dframe[0][ind].data[0];
	Rdata2 = dframe[0][ind].data[1];
	Rtag   = dframe[0][ind].tag;
	Rdirty = dframe[0][ind].dirty;
	Rvalid = dframe[0][ind].valid;

	Ldata1 = dframe[1][ind].data[0]; 
	Ldata2 = dframe[1][ind].data[1];
	Ltag   = dframe[1][ind].tag;
	Ldirty = dframe[1][ind].dirty;
	Lvalid = dframe[1][ind].valid; 

	for(j = 0; j < 8; j++) 
		next_used[j] = used[j];

	next_hits = hits;
	vijay = 0; //not always

	case(state)
		IDLE: begin
			if (dcif.halt) 
				next_hits = hits;
			else if (dcif.dmemREN) begin
				if (dframe[1][ind].valid && (tag == dframe[1][ind].tag)) begin
					if (offset)
						dcif.dmemload = dframe[1][ind].data[1];
					else
						dcif.dmemload = dframe[1][ind].data[0];
					next_hits = hits + 1;
					next_used[ind] = 1;
					dcif.dhit = 1;
				end else if (dframe[0][ind].valid && (tag == dframe[0][ind].tag)) begin
					if (offset)
						dcif.dmemload = dframe[0][ind].data[1];
					else
						dcif.dmemload = dframe[0][ind].data[0];
					next_hits = hits + 1;
					next_used[ind] = 0;
					dcif.dhit = 1;
				end else begin
					miss = 1;
					next_hits = hits - 1;
				end
			end else if (dcif.dmemWEN) begin
				if ((tag == dframe[1][ind].tag)) begin
					Ldirty = 1;
					next_hits = hits + 1;
					next_used[ind] = 1;
					dcif.dhit = 1;

					if (offset == 0) 
						Ldata1 = dcif.dmemstore;
					else 
						Ldata2 = dcif.dmemstore;
				end else if ((tag == dframe[0][ind].tag)) begin
					Rdirty = 1;
					next_used[ind] = 0;
					next_hits = hits + 1;
					dcif.dhit = 1;

					if(offset == 0) 
						Rdata1 = dcif.dmemstore;
					else 
						Rdata2 = dcif.dmemstore;
				end else begin
					miss = 1;
					next_hits = hits - 1;
				end
			end

			if (dcif.halt) 
				next_state = DIRTY;
			else if (miss) begin
				if (used[ind] == 0) begin 
					if (dframe[1][ind].dirty)
						next_state = WB1;
					else
						next_state = ALL1;
				end else begin 
					if (dframe[0][ind].dirty)
						next_state = WB1;
					else
						next_state = ALL1; 
				end
			end
		end
		WB1: begin
			if(used[ind] == 0) begin 
				cif.daddr = {dframe[1][ind].tag, ind, 3'b000};
				cif.dstore = dframe[1][ind].data[0];
			end else begin 
				cif.daddr = {dframe[0][ind].tag, ind, 3'b000};
				cif.dstore = dframe[0][ind].data[0];
			end

			cif.dWEN = 1;

			if (~cif.dwait) 
				next_state = WB2;
		end
		WB2: begin
			if(used[ind] == 0) begin 
				cif.daddr = {dframe[1][ind].tag, ind, 3'b100};
				cif.dstore = dframe[1][ind].data[1];
			end else begin 
				cif.daddr = {dframe[0][ind].tag, ind, 3'b100};
				cif.dstore = dframe[0][ind].data[1];
			end

			cif.dWEN = 1;

			if (~cif.dwait) 
				next_state = ALL1;
		end
		ALL1: begin
			cif.daddr = {tag, ind, 3'b000};
			if (used[ind] == 0) begin
				Ldata1 = cif.dload;
			end else begin
				Rdata1 = cif.dload;
			end
			
			cif.dREN = 1;

			if (~cif.dwait) 
				next_state = ALL2;
		end
		ALL2: begin
			cif.daddr = {tag, ind, 3'b100};
			if (used[ind] == 0) begin
				Ldirty = 0;
				Lvalid = 1;
				Ltag = tag;
				Ldata2 = cif.dload;

			end else begin
				Rdirty = 0;
				Rvalid = 1;
				Rtag = tag;
				Rdata2 = cif.dload;
			end

			cif.dREN = 1;

			if (~cif.dwait) 
				next_state = IDLE;
		end
		FLUSH1: begin
			if(row - 1 < 8) begin
				cif.daddr = {dframe[1][row_idx].tag, row_idx, 3'b000};
				cif.dstore = dframe[1][row_idx].data[0];
			end else begin
				cif.daddr = {dframe[0][row_idx].tag, row_idx, 3'b000};
				cif.dstore = dframe[0][row_idx].data[0];
			end 	

			cif.dWEN = 1;

			if (~cif.dwait) 
				next_state = FLUSH2;
		end
		FLUSH2: begin
			if(row - 1 < 8) begin
				cif.daddr = {dframe[1][row_idx].tag, row_idx, 3'b100};
				cif.dstore = dframe[1][row_idx].data[1];
			end else begin
				cif.daddr = {dframe[0][row_idx].tag, row_idx, 3'b100};
				cif.dstore = dframe[0][row_idx].data[1];
			end

			cif.dWEN = 1;

			if (~cif.dwait) 
				next_state = DIRTY;
		end
		COUNT: begin
			// cif.daddr = 32'h00003100;
			// cif.dstore = hits; 

			// cif.dWEN = 1;

			if (~cif.dwait) 
				next_state = HALT;
		end
		DIRTY: begin
			if (row < 8) begin
				if(dframe[1][row[2:0]].dirty) begin
					next_state = FLUSH1;
				end
			end else begin
				if(dframe[0][row[2:0]].dirty) begin
					next_state = FLUSH1;
				end
			end
			next_row = row + 1;
		 	if(row == 5'b10000) //when finished going through everything
		 		next_state = COUNT;
		end
		HALT: begin
			vijay = 1; //1 aka the best
		end
	endcase 
end
endmodule

