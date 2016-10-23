
module FIFO_2clk ( rclk, wclk, reset, we, re, data_in, empty_bar, full_bar, 
        data_out );
  input [3:0] data_in;
  output [3:0] data_out;
  input rclk, wclk, reset, we, re;
  output empty_bar, full_bar;
  wire   n6, n7, n292, n293, n294, n295, rd_ptr_bin_2_, n8, n9, n10, n11, n27,
         n28, n29, n30, n49, n50, n52, n53, n54, n55, n56, n58, n60, n62, n64,
         n68, n69, n70, n71, n72, n73, n74, n75, n76, n77, n78, n79, n80, n81,
         n82, n83, n84, n85, n86, n87, n88, n89, n90, n91, n92, n141, n144,
         n145, n146, n147, n148, n149, n150, n151, n152, n153, n154, n155,
         n156, n157, n158, n159, n160, n161, n162, n163, n164, n290, n291,
         n167, n168, n169, n170, n171, n172, n173, n174, n175, n176, n177,
         n178, n179, n180, n181, n182, n184, n185, n214, n215, n216, n217,
         n218, n219, n220, n221, n222, n223, n225, n230, n231, n232, n233,
         n234, n235, n236, n237, n238, n239, n240, n241, n242, n243, n244,
         n245, n246, n247, n248, n249, n250, n251, n252, n253, n254, n255,
         n256, n257, n258, n259, n260, n261, n262, n263, n264, n265, n266,
         n267, n268, n269, n270, n271, n272, n273, n274, n275, n276, n277,
         n278, n279, n280, n281, n282, n283, n284, n285, n286, n287, n288,
         n289;
  wire   [2:0] wr_ptr_gray;
  wire   [2:0] wr_ptr_gray_ss;
  wire   [2:0] wr_ptr_gray_s;
  wire   [2:0] rd_ptr_gray;
  wire   [2:0] rd_ptr_gray_ss;
  wire   [2:0] rd_ptr_gray_s;
  wire   [2:0] wr_ptr_bin;
  wire   [15:0] fifo;

  DFFSR rd_ptr_bin_reg_0_ ( .D(n144), .CLK(rclk), .R(n279), .S(1'b1), .Q(n6)
         );
  DFFSR rd_ptr_bin_reg_1_ ( .D(n141), .CLK(rclk), .R(n279), .S(1'b1), .Q(n7)
         );
  DFFSR rd_ptr_gray_reg_0_ ( .D(n9), .CLK(rclk), .R(n279), .S(1'b1), .Q(
        rd_ptr_gray[0]) );
  DFFSR data_out_reg_3_ ( .D(n283), .CLK(rclk), .R(n279), .S(1'b1), .Q(n292)
         );
  DFFSR data_out_reg_2_ ( .D(n282), .CLK(rclk), .R(n279), .S(1'b1), .Q(n293)
         );
  DFFSR data_out_reg_1_ ( .D(n281), .CLK(rclk), .R(n279), .S(1'b1), .Q(n294)
         );
  DFFSR data_out_reg_0_ ( .D(n280), .CLK(rclk), .R(n279), .S(1'b1), .Q(n295)
         );
  DFFSR rd_ptr_bin_reg_2_ ( .D(n164), .CLK(rclk), .R(n279), .S(1'b1), .Q(
        rd_ptr_bin_2_) );
  DFFSR rd_ptr_gray_reg_2_ ( .D(n247), .CLK(rclk), .R(n279), .S(1'b1), .Q(
        rd_ptr_gray[2]) );
  DFFSR rd_ptr_gray_reg_1_ ( .D(n8), .CLK(rclk), .R(n279), .S(1'b1), .Q(
        rd_ptr_gray[1]) );
  DFFSR wr_ptr_gray_s_reg_0_ ( .D(n174), .CLK(rclk), .R(n279), .S(1'b1), .Q(
        wr_ptr_gray_s[0]) );
  DFFSR wr_ptr_gray_ss_reg_0_ ( .D(n179), .CLK(rclk), .R(n279), .S(1'b1), .Q(
        wr_ptr_gray_ss[0]) );
  DFFSR wr_ptr_gray_s_reg_2_ ( .D(n176), .CLK(rclk), .R(n279), .S(1'b1), .Q(
        wr_ptr_gray_s[2]) );
  DFFSR wr_ptr_gray_ss_reg_2_ ( .D(n178), .CLK(rclk), .R(n279), .S(1'b1), .Q(
        wr_ptr_gray_ss[2]) );
  DFFSR wr_ptr_gray_s_reg_1_ ( .D(n175), .CLK(rclk), .R(n279), .S(1'b1), .Q(
        wr_ptr_gray_s[1]) );
  DFFSR wr_ptr_gray_ss_reg_1_ ( .D(n177), .CLK(rclk), .R(n279), .S(1'b1), .Q(
        wr_ptr_gray_ss[1]) );
  AOI22X1 U4 ( .A(data_out[0]), .B(n258), .C(n30), .D(n50), .Y(n49) );
  AOI22X1 U6 ( .A(data_out[1]), .B(n258), .C(n29), .D(n50), .Y(n52) );
  AOI22X1 U8 ( .A(data_out[2]), .B(n258), .C(n28), .D(n50), .Y(n53) );
  AOI22X1 U10 ( .A(data_out[3]), .B(n258), .C(n27), .D(n50), .Y(n54) );
  XOR2X1 U11 ( .A(n267), .B(n55), .Y(n141) );
  OAI21X1 U14 ( .A(n265), .B(n284), .C(n218), .Y(n145) );
  OAI21X1 U16 ( .A(n265), .B(n285), .C(n222), .Y(n146) );
  OAI21X1 U18 ( .A(n265), .B(n286), .C(n232), .Y(n147) );
  OAI21X1 U20 ( .A(n265), .B(n287), .C(n241), .Y(n148) );
  NAND3X1 U22 ( .A(n288), .B(n289), .C(n84), .Y(n56) );
  OAI21X1 U23 ( .A(n284), .B(n68), .C(n220), .Y(n149) );
  OAI21X1 U25 ( .A(n285), .B(n68), .C(n230), .Y(n150) );
  OAI21X1 U27 ( .A(n286), .B(n68), .C(n240), .Y(n151) );
  OAI21X1 U29 ( .A(n287), .B(n68), .C(n249), .Y(n152) );
  OAI21X1 U31 ( .A(n284), .B(n248), .C(n214), .Y(n153) );
  OAI21X1 U33 ( .A(n285), .B(n248), .C(n216), .Y(n154) );
  OAI21X1 U35 ( .A(n286), .B(n248), .C(n219), .Y(n155) );
  OAI21X1 U37 ( .A(n287), .B(n248), .C(n223), .Y(n156) );
  NAND3X1 U39 ( .A(n257), .B(n288), .C(n84), .Y(n73) );
  OAI21X1 U40 ( .A(n284), .B(n266), .C(n215), .Y(n157) );
  OAI21X1 U43 ( .A(n285), .B(n266), .C(n217), .Y(n158) );
  OAI21X1 U46 ( .A(n286), .B(n266), .C(n221), .Y(n159) );
  OAI21X1 U49 ( .A(n287), .B(n266), .C(n231), .Y(n160) );
  XNOR2X1 U52 ( .A(n255), .B(n266), .Y(n161) );
  OAI21X1 U54 ( .A(n83), .B(n289), .C(n68), .Y(n162) );
  XNOR2X1 U58 ( .A(n256), .B(n239), .Y(n163) );
  XNOR2X1 U60 ( .A(n247), .B(n234), .Y(n164) );
  NAND3X1 U65 ( .A(n86), .B(n87), .C(n88), .Y(n290) );
  XNOR2X1 U66 ( .A(n9), .B(n225), .Y(n88) );
  XNOR2X1 U67 ( .A(n247), .B(n233), .Y(n87) );
  XNOR2X1 U68 ( .A(n8), .B(n259), .Y(n86) );
  NAND3X1 U69 ( .A(n89), .B(n90), .C(n91), .Y(n291) );
  XNOR2X1 U70 ( .A(n257), .B(n92), .Y(n91) );
  XNOR2X1 U71 ( .A(n184), .B(n264), .Y(n90) );
  FAX1 U72 ( .A(n246), .B(n92), .C(n288), .YC(), .YS(n89) );
  XOR2X1 U74 ( .A(n264), .B(n250), .Y(n92) );
  XOR2X1 U75 ( .A(n270), .B(n267), .Y(n9) );
  XOR2X1 U76 ( .A(n247), .B(n267), .Y(n8) );
  XNOR2X1 U77 ( .A(n289), .B(n256), .Y(n11) );
  XNOR2X1 U79 ( .A(n184), .B(n257), .Y(n10) );
  DFFSR rd_ptr_gray_ss_reg_2_ ( .D(n173), .CLK(wclk), .R(n279), .S(1'b1), .Q(
        rd_ptr_gray_ss[2]) );
  DFFSR rd_ptr_gray_ss_reg_1_ ( .D(n172), .CLK(wclk), .R(n279), .S(1'b1), .Q(
        rd_ptr_gray_ss[1]) );
  DFFSR rd_ptr_gray_ss_reg_0_ ( .D(n171), .CLK(wclk), .R(n279), .S(1'b1), .Q(
        rd_ptr_gray_ss[0]) );
  DFFSR wr_ptr_gray_reg_2_ ( .D(n185), .CLK(wclk), .R(n279), .S(1'b1), .Q(
        wr_ptr_gray[2]) );
  DFFSR wr_ptr_gray_reg_1_ ( .D(n10), .CLK(wclk), .R(n279), .S(1'b1), .Q(
        wr_ptr_gray[1]) );
  DFFSR wr_ptr_gray_reg_0_ ( .D(n11), .CLK(wclk), .R(n279), .S(1'b1), .Q(
        wr_ptr_gray[0]) );
  DFFSR wr_ptr_bin_reg_0_ ( .D(n163), .CLK(wclk), .R(n279), .S(1'b1), .Q(
        wr_ptr_bin[0]) );
  DFFSR fifo_reg_0__3_ ( .D(n145), .CLK(wclk), .R(n279), .S(1'b1), .Q(fifo[15]) );
  DFFSR fifo_reg_0__2_ ( .D(n146), .CLK(wclk), .R(n279), .S(1'b1), .Q(fifo[14]) );
  DFFSR fifo_reg_0__1_ ( .D(n147), .CLK(wclk), .R(n279), .S(1'b1), .Q(fifo[13]) );
  DFFSR fifo_reg_0__0_ ( .D(n148), .CLK(wclk), .R(n279), .S(1'b1), .Q(fifo[12]) );
  DFFSR fifo_reg_2__3_ ( .D(n153), .CLK(wclk), .R(n279), .S(1'b1), .Q(fifo[7])
         );
  DFFSR fifo_reg_2__2_ ( .D(n154), .CLK(wclk), .R(n279), .S(1'b1), .Q(fifo[6])
         );
  DFFSR fifo_reg_2__1_ ( .D(n155), .CLK(wclk), .R(n279), .S(1'b1), .Q(fifo[5])
         );
  DFFSR fifo_reg_2__0_ ( .D(n156), .CLK(wclk), .R(n279), .S(1'b1), .Q(fifo[4])
         );
  DFFSR wr_ptr_bin_reg_1_ ( .D(n162), .CLK(wclk), .R(n279), .S(1'b1), .Q(
        wr_ptr_bin[1]) );
  DFFSR wr_ptr_bin_reg_2_ ( .D(n161), .CLK(wclk), .R(n279), .S(1'b1), .Q(
        wr_ptr_bin[2]) );
  DFFSR fifo_reg_1__3_ ( .D(n149), .CLK(wclk), .R(n279), .S(1'b1), .Q(fifo[11]) );
  DFFSR fifo_reg_1__2_ ( .D(n150), .CLK(wclk), .R(n279), .S(1'b1), .Q(fifo[10]) );
  DFFSR fifo_reg_1__1_ ( .D(n151), .CLK(wclk), .R(n279), .S(1'b1), .Q(fifo[9])
         );
  DFFSR fifo_reg_1__0_ ( .D(n152), .CLK(wclk), .R(n279), .S(1'b1), .Q(fifo[8])
         );
  DFFSR fifo_reg_3__3_ ( .D(n157), .CLK(wclk), .R(n279), .S(1'b1), .Q(fifo[3])
         );
  DFFSR fifo_reg_3__2_ ( .D(n158), .CLK(wclk), .R(n279), .S(1'b1), .Q(fifo[2])
         );
  DFFSR fifo_reg_3__1_ ( .D(n159), .CLK(wclk), .R(n279), .S(1'b1), .Q(fifo[1])
         );
  DFFSR fifo_reg_3__0_ ( .D(n160), .CLK(wclk), .R(n279), .S(1'b1), .Q(fifo[0])
         );
  DFFSR rd_ptr_gray_s_reg_2_ ( .D(n181), .CLK(wclk), .R(n279), .S(1'b1), .Q(
        rd_ptr_gray_s[2]) );
  DFFSR rd_ptr_gray_s_reg_1_ ( .D(n180), .CLK(wclk), .R(n279), .S(1'b1), .Q(
        rd_ptr_gray_s[1]) );
  DFFSR rd_ptr_gray_s_reg_0_ ( .D(n182), .CLK(wclk), .R(n279), .S(1'b1), .Q(
        rd_ptr_gray_s[0]) );
  AND2X1 U125 ( .A(n83), .B(n257), .Y(n78) );
  AND2X1 U126 ( .A(n84), .B(n256), .Y(n83) );
  AND2X1 U127 ( .A(re), .B(empty_bar), .Y(n50) );
  AND2X1 U128 ( .A(we), .B(full_bar), .Y(n84) );
  BUFX2 U129 ( .A(n54), .Y(n167) );
  BUFX2 U130 ( .A(n53), .Y(n168) );
  BUFX2 U131 ( .A(n52), .Y(n169) );
  BUFX2 U132 ( .A(n49), .Y(n170) );
  BUFX2 U133 ( .A(rd_ptr_gray_s[0]), .Y(n171) );
  BUFX2 U134 ( .A(rd_ptr_gray_s[1]), .Y(n172) );
  BUFX2 U135 ( .A(rd_ptr_gray_s[2]), .Y(n173) );
  BUFX2 U136 ( .A(wr_ptr_gray[0]), .Y(n174) );
  BUFX2 U137 ( .A(wr_ptr_gray[1]), .Y(n175) );
  BUFX2 U138 ( .A(wr_ptr_gray[2]), .Y(n176) );
  BUFX2 U139 ( .A(wr_ptr_gray_s[1]), .Y(n177) );
  BUFX2 U140 ( .A(wr_ptr_gray_s[2]), .Y(n178) );
  BUFX2 U141 ( .A(wr_ptr_gray_s[0]), .Y(n179) );
  BUFX2 U142 ( .A(rd_ptr_gray[1]), .Y(n180) );
  BUFX2 U143 ( .A(rd_ptr_gray[2]), .Y(n181) );
  BUFX2 U144 ( .A(rd_ptr_gray[0]), .Y(n182) );
  BUFX2 U145 ( .A(n290), .Y(empty_bar) );
  INVX1 U146 ( .A(n185), .Y(n184) );
  BUFX2 U147 ( .A(wr_ptr_bin[2]), .Y(n185) );
  AND2X1 U176 ( .A(n235), .B(n248), .Y(n74) );
  INVX1 U177 ( .A(n74), .Y(n214) );
  AND2X1 U178 ( .A(n242), .B(n266), .Y(n79) );
  INVX1 U179 ( .A(n79), .Y(n215) );
  AND2X1 U180 ( .A(n236), .B(n248), .Y(n75) );
  INVX1 U181 ( .A(n75), .Y(n216) );
  AND2X1 U182 ( .A(n243), .B(n266), .Y(n80) );
  INVX1 U183 ( .A(n80), .Y(n217) );
  AND2X1 U184 ( .A(n251), .B(n265), .Y(n58) );
  INVX1 U185 ( .A(n58), .Y(n218) );
  AND2X1 U186 ( .A(n237), .B(n248), .Y(n76) );
  INVX1 U187 ( .A(n76), .Y(n219) );
  AND2X1 U188 ( .A(n260), .B(n68), .Y(n69) );
  INVX1 U189 ( .A(n69), .Y(n220) );
  AND2X1 U190 ( .A(n244), .B(n266), .Y(n81) );
  INVX1 U191 ( .A(n81), .Y(n221) );
  AND2X1 U192 ( .A(n252), .B(n265), .Y(n60) );
  INVX1 U193 ( .A(n60), .Y(n222) );
  AND2X1 U194 ( .A(n238), .B(n248), .Y(n77) );
  INVX1 U195 ( .A(n77), .Y(n223) );
  BUFX2 U196 ( .A(n291), .Y(full_bar) );
  BUFX2 U197 ( .A(wr_ptr_gray_ss[0]), .Y(n225) );
  BUFX2 U198 ( .A(n292), .Y(data_out[3]) );
  BUFX2 U199 ( .A(n293), .Y(data_out[2]) );
  BUFX2 U200 ( .A(n294), .Y(data_out[1]) );
  BUFX2 U201 ( .A(n295), .Y(data_out[0]) );
  AND2X1 U202 ( .A(n261), .B(n68), .Y(n70) );
  INVX1 U203 ( .A(n70), .Y(n230) );
  AND2X1 U204 ( .A(n245), .B(n266), .Y(n82) );
  INVX1 U205 ( .A(n82), .Y(n231) );
  AND2X1 U206 ( .A(n253), .B(n265), .Y(n62) );
  INVX1 U207 ( .A(n62), .Y(n232) );
  BUFX2 U208 ( .A(wr_ptr_gray_ss[2]), .Y(n233) );
  AND2X1 U209 ( .A(n55), .B(n267), .Y(n85) );
  INVX1 U210 ( .A(n85), .Y(n234) );
  BUFX2 U211 ( .A(fifo[7]), .Y(n235) );
  BUFX2 U212 ( .A(fifo[6]), .Y(n236) );
  BUFX2 U213 ( .A(fifo[5]), .Y(n237) );
  BUFX2 U214 ( .A(fifo[4]), .Y(n238) );
  INVX1 U215 ( .A(n84), .Y(n239) );
  AND2X1 U216 ( .A(n262), .B(n68), .Y(n71) );
  INVX1 U217 ( .A(n71), .Y(n240) );
  AND2X1 U218 ( .A(n254), .B(n265), .Y(n64) );
  INVX1 U219 ( .A(n64), .Y(n241) );
  BUFX2 U220 ( .A(fifo[3]), .Y(n242) );
  BUFX2 U221 ( .A(fifo[2]), .Y(n243) );
  BUFX2 U222 ( .A(fifo[1]), .Y(n244) );
  BUFX2 U223 ( .A(fifo[0]), .Y(n245) );
  BUFX2 U224 ( .A(rd_ptr_gray_ss[0]), .Y(n246) );
  BUFX2 U225 ( .A(rd_ptr_bin_2_), .Y(n247) );
  BUFX2 U226 ( .A(n73), .Y(n248) );
  AND2X1 U227 ( .A(n263), .B(n68), .Y(n72) );
  INVX1 U228 ( .A(n72), .Y(n249) );
  BUFX2 U229 ( .A(rd_ptr_gray_ss[1]), .Y(n250) );
  BUFX2 U230 ( .A(fifo[15]), .Y(n251) );
  BUFX2 U231 ( .A(fifo[14]), .Y(n252) );
  BUFX2 U232 ( .A(fifo[13]), .Y(n253) );
  BUFX2 U233 ( .A(fifo[12]), .Y(n254) );
  BUFX2 U234 ( .A(n185), .Y(n255) );
  BUFX2 U235 ( .A(wr_ptr_bin[0]), .Y(n256) );
  BUFX2 U236 ( .A(wr_ptr_bin[1]), .Y(n257) );
  INVX1 U237 ( .A(n50), .Y(n258) );
  BUFX2 U238 ( .A(wr_ptr_gray_ss[1]), .Y(n259) );
  BUFX2 U239 ( .A(fifo[11]), .Y(n260) );
  BUFX2 U240 ( .A(fifo[10]), .Y(n261) );
  BUFX2 U241 ( .A(fifo[9]), .Y(n262) );
  BUFX2 U242 ( .A(fifo[8]), .Y(n263) );
  BUFX2 U243 ( .A(rd_ptr_gray_ss[2]), .Y(n264) );
  BUFX2 U244 ( .A(n56), .Y(n265) );
  INVX1 U245 ( .A(n78), .Y(n266) );
  BUFX2 U246 ( .A(n7), .Y(n267) );
  AND2X1 U247 ( .A(n50), .B(n270), .Y(n55) );
  AND2X1 U248 ( .A(n83), .B(n289), .Y(n268) );
  INVX1 U249 ( .A(n268), .Y(n68) );
  BUFX2 U250 ( .A(n6), .Y(n270) );
  XOR2X1 U251 ( .A(n269), .B(n258), .Y(n144) );
  INVX1 U252 ( .A(n270), .Y(n269) );
  INVX1 U253 ( .A(n170), .Y(n280) );
  INVX1 U254 ( .A(n169), .Y(n281) );
  INVX1 U255 ( .A(n168), .Y(n282) );
  INVX1 U256 ( .A(n167), .Y(n283) );
  INVX1 U257 ( .A(n256), .Y(n288) );
  INVX1 U258 ( .A(data_in[0]), .Y(n287) );
  INVX1 U259 ( .A(data_in[1]), .Y(n286) );
  INVX1 U260 ( .A(data_in[2]), .Y(n285) );
  INVX1 U261 ( .A(data_in[3]), .Y(n284) );
  INVX1 U262 ( .A(n257), .Y(n289) );
  INVX1 U263 ( .A(reset), .Y(n279) );
  MUX2X1 U264 ( .B(n271), .A(n272), .S(n267), .Y(n30) );
  MUX2X1 U265 ( .B(n273), .A(n274), .S(n267), .Y(n29) );
  MUX2X1 U266 ( .B(n275), .A(n276), .S(n267), .Y(n28) );
  MUX2X1 U267 ( .B(n277), .A(n278), .S(n267), .Y(n27) );
  MUX2X1 U268 ( .B(n238), .A(n245), .S(n270), .Y(n272) );
  MUX2X1 U269 ( .B(n254), .A(n263), .S(n270), .Y(n271) );
  MUX2X1 U270 ( .B(n237), .A(n244), .S(n270), .Y(n274) );
  MUX2X1 U271 ( .B(n253), .A(n262), .S(n270), .Y(n273) );
  MUX2X1 U272 ( .B(n236), .A(n243), .S(n270), .Y(n276) );
  MUX2X1 U273 ( .B(n252), .A(n261), .S(n270), .Y(n275) );
  MUX2X1 U274 ( .B(n235), .A(n242), .S(n270), .Y(n278) );
  MUX2X1 U275 ( .B(n251), .A(n260), .S(n270), .Y(n277) );
endmodule

