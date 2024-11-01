module hex8_2(
    Clk,
    Reset_n,
    Disp_Data,
    SEL,
    SEG,
    point_1,
    point_2
);
    
    input Clk;
    input Reset_n;
    input [31:0]Disp_Data;
    output reg[7:0]SEL;
    output reg[7:0]SEG;//seg[0]-a,seg[1]-b...seg[7]-h
    
    reg clk_1k;
    reg [15:0]div_cnt;
    input [2:0]point_1;
    input [2:0]point_2;
    always@(posedge Clk or negedge Reset_n)
    if(!Reset_n)
        div_cnt <= 0;
    else if(div_cnt >= 49999)
        div_cnt <= 0;
    else
        div_cnt <= div_cnt + 1'b1;
        
    always@(posedge Clk or negedge Reset_n)
    if(!Reset_n)
        clk_1k <= 0;
    else if(div_cnt == 49999)
        clk_1k <= 1'b1;
    else
        clk_1k <= 0;
      
    reg [2:0]num_cnt;
    always@(posedge Clk or negedge Reset_n)
    if(!Reset_n)
        num_cnt <= 0;
    else if(clk_1k)
        num_cnt <= num_cnt + 1'b1;
        
    always@(posedge Clk)
        case(num_cnt)
            0: SEL = 8'b00000001;
            1: SEL = 8'b00000010;
            2: SEL = 8'b00000100;
            3: SEL = 8'b00001000;
            4: SEL = 8'b00010000;
            5: SEL = 8'b00100000;
            6: SEL = 8'b01000000;
            7: SEL = 8'b10000000;
        endcase

    reg[3:0]disp_tmp;
    always@(posedge Clk)
        case(num_cnt)
            7: disp_tmp = Disp_Data[31:28];
            6: disp_tmp = Disp_Data[27:24];
            5: disp_tmp = Disp_Data[23:20];
            4: disp_tmp = Disp_Data[19:16];
            3: disp_tmp = Disp_Data[15:12];
            2: disp_tmp = Disp_Data[11:8];
            1: disp_tmp = Disp_Data[7:4];
            0: disp_tmp = Disp_Data[3:0];
        endcase   

     always@(posedge Clk)
        case(disp_tmp)
            0: SEG[6:0] = 7'h40;
            1: SEG[6:0] = 7'h79;
            2: SEG[6:0] = 7'h24;
            3: SEG[6:0] = 7'h30;
            4: SEG[6:0] = 7'h19;
            5: SEG[6:0] = 7'h12;
            6: SEG[6:0] = 7'h02;
            7: SEG[6:0] = 7'h78;
            8: SEG[6:0] = 7'h00;
            9: SEG[6:0] = 7'h10;
            4'ha: SEG[6:0] = 7'h08;
            4'hb: SEG[6:0] = 7'h03;
            4'hc: SEG[6:0] = 7'h46;
            4'hd: SEG[6:0] = 7'h21;
            4'he: SEG[6:0] = 7'h06;
            4'hf: SEG[6:0] = 7'h0e;
        endcase   
    wire ed = (num_cnt == point_1 || num_cnt == point_2 + 4) ? 1 : 0;
    always @(posedge Clk) begin
        if (ed) begin
            SEG[7] <= 1'b0;
        end else begin
            SEG[7] <= 1'b1;
        end
    end
endmodule
