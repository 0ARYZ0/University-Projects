`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:14:47 12/03/2022 
// Design Name: 
// Module Name:    MIPS 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module MIPS(input clk);

	//fetch module
	wire [31:0] brachTarget_Input;
	wire pcSource_Input;
	wire hit_Output;
	wire [31:0] nextPc_Output;
	wire [31:0] instruction_Output;
	wire nextPcTOIFID;
	
	fetch  fetchInstance (
		.BranchTarget(brachTarget_Input), 
		.ClockPulse(clk), 
		.PcSource(pcSource_Input), 
		.NextPc(nextPc_Output), 
		.Instruction(instruction_Output),//, 
		.Hit(hit_Output)
	);
	
	//IF_ID module
	wire [31:0] instructionIFID_Input;
	wire [31:0] instructionIFID_Output;
	wire [31:0] nextPcIFID_Input;
	wire [31:0] nextPcIFID_Output;
	//
	wire [31:0]next_pc_wait_IDEX;
	reg [31:0]next_pc_wait ; //for delay
    always @(posedge clk) begin
        next_pc_wait = nextPcIFID_Output;
    end

    assign next_pc_wait_IDEX = next_pc_wait;
	//
	if_id if_id_instance (
		.clk(clk), 
		.instruction(instructionIFID_Input), 
		.next_pc(nextPcIFID_Input), 
		.hit(hit_Output), 
		.next_pc_out(nextPcIFID_Output), 
		.instruction_out(instructionIFID_Output)//, 
		//.hitOut(hit_Output)
	);
	
	//decode module
    wire regWrite_MEMWB_Decode;
    wire [4:0]write_reg_MEMWB_Decode;
    wire [31:0]write_data;
    wire [5:0]opcode_Decode_Control;
    wire [31:0]read_data1_Decode_IDEX;
    wire [31:0]read_data2_Decode_IDEX;
    wire [31:0]immediate_Decode_IDEX;
    wire [4:0]rt_Decode_IDEX;
    wire [4:0]rd_Decode_IDEX;
    wire [5:0]funct_Decode_IDEX;
	
	decode decodeInstance (
    .clk                       (clk),
    .instruction               (instructionIFID_Output),
    .regWrite                  (regWrite_MEMWB_Decode),
    .write_reg                 (write_reg_MEMWB_Decode),
    .write_data                (write_data),

    .opcode                    (opcode_Decode_Control),
    .read_data1                (read_data1_Decode_IDEX),
    .read_data2                (read_data2_Decode_IDEX),
    .sign_extended             (immediate_Decode_IDEX),
    .rt                        (rt_Decode_IDEX),
    .rd                        (rd_Decode_IDEX),
    .funct                     (funct_Decode_IDEX)
	);


	//controlUnit module
	wire regDst_Output;
	wire aluSrc_Output;
	wire memToReg_Output;
	wire regWrite_Output;
	wire memRead_Output;
	wire memWrite_Output;
	wire branch_Output;
	wire [2:0] aluOp_Output; 
	
	controlUnit controlUnitInstance (
		.opcode(opcode_Decode_Control), 
		.regDst(regDst_Output), 
		.aluSrc(AluSrc_Output), 
		.memToReg(memToReg_Output), 
		.regWrite(regWrite_Output), 
		.memRead(memRead_Output), 
		.memWrite(memWrite_Output), 
		.branch(branch_Output), 
		.aluOp(aluOp_Output)
	);

	//id/ex
    wire [31:0]read_data1_IDEX_Execute;
    wire [31:0]read_data2_IDEX_Execute;
    wire [31:0]immediate_IDEX_Execute;
    wire regDst_IDEX_Execute;
    wire aluSrc_IDEX_Execute;
    wire memToReg_IDEX_EXMEM;
    wire regWrite_IDEX_EXMEM;
    wire memRead_IDEX_EXMEM;
    wire memWrite_IDEX_EXMEM;
    wire branch_IDEX_EXMEM;
    wire [2:0]aluOp_IDEX_Execute;
    wire [4:0]rt_IDEX_Execute;
    wire [4:0]rd_IDEX_Execute;
    wire [5:0]funct_IDEX_Execute;
    wire [31:0]next_pc_IDEX_Execute;
	
	id_ex id_ex_instance (
		.clk(clk), 
		.Hit(hit_Output), 
		.Read_Data_One(read_data1_Decode_IDEX), 
		.Read_Data_Two(read_data2_Decode_IDEX), 
		.Immediate(immediate_Decode_IDEX), 
		.Reg_Destination(regDst_Output), 
		.ALU_Source(AluSrc_Output), 
		.MemToReg(memToReg_Output), 
		.RegWrite(regWrite_Output), 
		.MEM_Read(memRead_Output), 
		.MEM_Write(memWrite_Output), 
		.Branch(branch_Output), 
		.ALU_Operation(aluOp_Output), 
		.RT(rt_Decode_IDEX), 
		.RD(rd_Decode_IDEX), 
		.Function(funct_Decode_IDEX), 
		.Next_PC(next_pc_wait_IDEX), 
		.Hit_Out(hit_Output), 
		.Read_Data_One_Out(read_data1_IDEX_Execute), 
		.Read_Data_Two_Out(read_data2_IDEX_Execute), 
		.Immediate_Out(immediate_IDEX_Execute), 
		.Reg_Destination_Out(regDst_IDEX_Execute), 
		.ALU_Source_Out(aluSrc_IDEX_Execute), 
		.MemToReg_Out(memToReg_IDEX_EXMEM), 
		.RegWrite_Out(regWrite_IDEX_EXMEM), 
		.MEM_Read_Out(memRead_IDEX_EXMEM), 
		.MEM_Write_Out(memWrite_IDEX_EXMEM), 
		.Branch_Out(branch_IDEX_EXMEM), 
		.ALU_Operation_Out(aluOp_IDEX_Execute), 
		.RT_Out(rt_IDEX_Execute), 
		.RD_Out(rd_IDEX_Execute), 
		.Function_Out(funct_IDEX_Execute), 
		.Next_PC_Out(next_pc_IDEX_Execute)
);
	
	// Execute
    wire [4:0]writeReg_Execute_EXMEM;
    wire [31:0]readData2_Execute_EXMEM;
    wire [31:0]aluResult_Execute_EXMEM;
    wire zero_Execute_EXMEM;
    wire [31:0]branchTarget_Execute_EXMEM;

	execute executeInstance (
		.pc_in(next_pc_IDEX_Execute),
		.clk(clk), 
		.ALU_Read_Data1(read_data1_IDEX_Execute), 
		.ALU_Read_Data2(read_data2_IDEX_Execute), 
		.Immediate(immediate_IDEX_Execute), 
		.funct(funct_IDEX_Execute), 
		.alu_op(aluOp_IDEX_Execute), 
		.alu_src(aluSrc_IDEX_Execute), 
		//
		.rt (rt_IDEX_Execute),
      .rd (rd_IDEX_Execute),
		.regDst (regDst_IDEX_Execute),
		//
		.ALU_Result(aluResult_Execute_EXMEM), 
		.Zero(zero_Execute_EXMEM), 
		.ALU_ReadData(readData2_Execute_EXMEM), 
		.RdOrRt(writeReg_Execute_EXMEM),
		.addResult (branchTarget_Execute_EXMEM)
	);
	
	//ex/mem
	 wire zeroFlag_EXMEM_and;
    wire [31:0]aluResult_EXMEM_DataMemory;
    wire [31:0]writeData_EXMEM_DataMemory;
    wire [4:0]writeReg_EXMEM_MEMWB;
    wire memRead_EXMEM_DataMemory;
    wire memWrite_EXMEM_DataMemory;
    wire branchFlag_EXMEM_and;
    wire regWrite_EXMEM_MEMWB;
    wire memToReg_EXMEM_MEMWB;

    reg [31:0]readdata2_wait_Execute_EXMEM;
    reg memRead_wait_IDEX_EXMEM;
    reg memWrite_wait_IDEX_EXMEM;
    reg branch_wait_IDEX_EXMEM;
    reg regWrite_wait_IDEX_EXMEM;
    reg memToReg_wait_IDEX_EXMEM;
	 
    always @(posedge clk) begin
        readdata2_wait_Execute_EXMEM = readData2_Execute_EXMEM;
        memRead_wait_IDEX_EXMEM = memRead_IDEX_EXMEM;
        memWrite_wait_IDEX_EXMEM = memWrite_IDEX_EXMEM;
        branch_wait_IDEX_EXMEM = branch_IDEX_EXMEM;
        regWrite_wait_IDEX_EXMEM = regWrite_IDEX_EXMEM;
        memToReg_wait_IDEX_EXMEM = memToReg_IDEX_EXMEM;
    end
	 
	 ex_mem_register ex_mem_registerInstance (
		.clk(clk), 
		.hit(hit_Output), 
		.branchTarget(branchTarget_Execute_EXMEM), 
		.zeroFlag(zero_Execute_EXMEM), 
		.ALUResult(aluResult_Execute_EXMEM), 
		.readDataTwo(readdata2_wait_Execute_EXMEM), 
		.writeReg(writeReg_Execute_EXMEM), 
		.MemRead(memRead_wait_IDEX_EXMEM), 
		.MemWrite(memWrite_wait_IDEX_EXMEM), 
		.Branch(branch_wait_IDEX_EXMEM), 
		.RegWrite(regWrite_wait_IDEX_EXMEM), 
		.MemToReg(memToReg_wait_IDEX_EXMEM), 
		.branchTargetOut(brachTarget_Input), 
		.zeroFlagOut(zeroFlag_EXMEM_and), 
		.ALUResultOut(aluResult_EXMEM_DataMemory), 
		.readDataTwoOut(writeData_EXMEM_DataMemory), 
		.writeRegOut(writeReg_EXMEM_MEMWB), 
		.MemReadOut(memRead_EXMEM_DataMemory), 
		.MemWriteOut(memWrite_EXMEM_DataMemory), 
		.BranchOut(branchFlag_EXMEM_and), 
		.RegWriteOut(regWrite_EXMEM_MEMWB), 
		.MemToRegOut(memToReg_EXMEM_MEMWB), 
		.hitOut(hit_Output)
	);

	//data memory
   // and zeroFlag, branch
    assign pcSource_Input = zeroFlag_EXMEM_and && branchFlag_EXMEM_and;

    wire [31:0]readData_DataMemory_MEMWB;
	 
	 data_memory data_memoryInstance (
		.clk(clk), 
		.address(aluResult_EXMEM_DataMemory), 
		.writeData(writeData_EXMEM_DataMemory), 
		.MemWrite(memRead_EXMEM_DataMemory), 
		.MemRead(memWrite_EXMEM_DataMemory), 
		.readData(readData_DataMemory_MEMWB)
	);
	 
	//mem/wb
	 wire [31:0]readData_MEMWB_WriteBack;
    wire [31:0]aluResult_MEMWB_WriteBack;
    wire memToReg_MEMWB_WriteBack;

    reg [31:0]aluResult_wait_EXMEM_MEMWB;
    reg [4:0]writeReg_wait_EXMEM_MEMWB;
    reg regWrite_wait_EXMEM_MEMWB;
    reg memToReg_wait_EXMEM_MEMWB;
    
    always @(posedge clk) begin
        aluResult_wait_EXMEM_MEMWB = aluResult_EXMEM_DataMemory;
        writeReg_wait_EXMEM_MEMWB = writeReg_EXMEM_MEMWB;
        regWrite_wait_EXMEM_MEMWB = regWrite_EXMEM_MEMWB;
        memToReg_wait_EXMEM_MEMWB = memToReg_EXMEM_MEMWB;
    end
	 
	 mem_wb mem_wbInstance (
		.clk(clk), 
		.hit(hit_Output), 
		.readData(readData_DataMemory_MEMWB), 
		.ALUResult(aluResult_wait_EXMEM_MEMWB), 
		.writeReg(writeReg_wait_EXMEM_MEMWB), 
		.RegWrite(regWrite_wait_EXMEM_MEMWB), 
		.MemtoReg(memToReg_wait_EXMEM_MEMWB), 
		.hitOut(hit_Output), 
		.readDataOut(readData_MEMWB_WriteBack), 
		.ALUResultOut(aluResult_MEMWB_WriteBack), 
		.writeRegOut(write_reg_MEMWB_Decode), 
		.RegWriteOut(regWrite_MEMWB_Decode), 
		.MemtoRegOut(memToReg_MEMWB_WriteBack)
	);
	 
	//write back
	
	write_back write_backInstance (
		.MemToReg(memToReg_MEMWB_WriteBack), 
		.readData(readData_MEMWB_WriteBack), 
		.ALUResult(aluResult_MEMWB_WriteBack), 
		.writeData(write_data)
	);
	 

endmodule
