// import cpu_types_pkg::*;

// module icache (
// 	input logic CLK, nRST,
// 	datapath_cache_if dcif,
// 	caches_if.icache cif
// );

// icache_frame iframe [15:0];

// logic [3:0] index;
// logic miss;

// always_ff @(posedge CLK, negedge nRST) begin
// 	if(~nRST) begin
// 		for (int i = 0; i < 16; i++) begin
// 			 iframe[i] <= 0;
// 		end
// 	end else begin
// 		if(~cif.iwait) begin
// 			 iframe[index].tag <= dcif.imemaddr[31:6];
// 			 iframe[index].data <= cif.iload;
// 			 iframe[index].valid <= 1;
// 		end
// 	end
// end

// always_comb begin
//     index = dcif.imemaddr[5:2];

// 	if(dcif.halt) 
// 	begin
// 		dcif.ihit = 0;
// 		dcif.imemload = 0;
// 		miss = 0;
// 	end 
// 	else if(dcif.imemREN && !dcif.dmemREN && !dcif.dmemWEN) //i and not any d
// 	begin
// 		if((dcif.imemaddr[31:6] == iframe[index].tag) && iframe[index].valid) begin
// 			dcif.ihit = 1;
// 			dcif.imemload = iframe[index].data;
// 			miss = 0;
// 		end 
// 		else begin
// 			dcif.ihit = ~cif.iwait;
// 			dcif.imemload = cif.iload;
// 			miss = 1;
// 		end
// 	end 
// 	else begin
// 		miss = 0;
// 		dcif.ihit = 0;
// 		dcif.imemload = 0;
// 	end

// 	if(miss) begin
// 		cif.iREN = dcif.imemREN;
// 		cif.iaddr = dcif.imemaddr;
// 	end
// 	else begin
// 		cif.iREN = 0;
// 		cif.iaddr = '0;
// 	end	
// end

// endmodule 