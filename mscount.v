module mscount(
    output reg [0:6] seven_seg,
    output reg [1:0] COM,
    input clk, clear
);

    wire clk_divs1;
    wire clk_divs10;
    reg [3:0] s1_count;
    reg [3:0] s10_count;

    divfreq F0(clk, clk_divs1, clk_divs10);

    always @(posedge clk_divs1, posedge clear) begin
        if (clear) begin
            s1_count <= 4'b0000;
            s10_count <= 4'b0000;
        end
        else begin
            if (s1_count == 4'b1001) begin
                s1_count <= 4'b0000;
                if (s10_count == 4'b1001) s10_count <= 4'b0000;
                else s10_count <= s10_count + 1'b1;
            end
            else s1_count <= s1_count + 1'b1;
        end
    end
    
    always @(posedge clk_divs10) begin
        if (COM == 2'b01) COM <= 2'b10;
        else COM <= 2'b01;
    end

    always @* begin
        if (COM == 2'b01) begin
            case(s1_count)
                4'b0000: seven_seg = 7'b0000001;
                4'b0001: seven_seg = 7'b1001111;
                4'b0010: seven_seg = 7'b0010010;
                4'b0011: seven_seg = 7'b0000110;
                4'b0100: seven_seg = 7'b1001100;
                4'b0101: seven_seg = 7'b0100100;
                4'b0110: seven_seg = 7'b0100000;
                4'b0111: seven_seg = 7'b0001111;
                4'b1000: seven_seg = 7'b0000000;
                4'b1001: seven_seg = 7'b0000100;
                default: seven_seg = 7'b1111111;
            endcase
        end
        else if (COM == 2'b10) begin
            case(s10_count)
                4'b0000: seven_seg = 7'b0000001;
                4'b0001: seven_seg = 7'b1001111;
                4'b0010: seven_seg = 7'b0010010;
                4'b0011: seven_seg = 7'b0000110;
                4'b0100: seven_seg = 7'b1001100;
                4'b0101: seven_seg = 7'b0100100;
                default: seven_seg = 7'b1111111;
            endcase
        end
    end

endmodule

module divfreq(input clk, output reg clk_divs1, output reg clk_divs10);
    reg [24:0] count_s1 = 25'b0;
    reg [24:0] count_s10 = 25'b0;

    always @(posedge clk) begin
        if (count_s1 >= 25000000) begin
            count_s1 <= 25'b0;
            clk_divs1 <= ~clk_divs1;
        end
        else count_s1 <= count_s1 + 1'b1;
        
        if (count_s10 >= 250000) begin
            count_s10 <= 25'b0;
            clk_divs10 <= ~clk_divs10;
        end
        else count_s10 <= count_s10 + 1'b1;
    end
endmodule
