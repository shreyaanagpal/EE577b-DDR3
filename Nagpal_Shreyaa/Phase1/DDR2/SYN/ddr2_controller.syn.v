
module ddr2_init_engine_DW01_inc_0 ( A, SUM );
  input [16:0] A;
  output [16:0] SUM;

  wire   [16:2] carry;

  HAX1 U1_1_15 ( .A(A[15]), .B(carry[15]), .YC(carry[16]), .YS(SUM[15]) );
  HAX1 U1_1_14 ( .A(A[14]), .B(carry[14]), .YC(carry[15]), .YS(SUM[14]) );
  HAX1 U1_1_13 ( .A(A[13]), .B(carry[13]), .YC(carry[14]), .YS(SUM[13]) );
  HAX1 U1_1_12 ( .A(A[12]), .B(carry[12]), .YC(carry[13]), .YS(SUM[12]) );
  HAX1 U1_1_11 ( .A(A[11]), .B(carry[11]), .YC(carry[12]), .YS(SUM[11]) );
  HAX1 U1_1_10 ( .A(A[10]), .B(carry[10]), .YC(carry[11]), .YS(SUM[10]) );
  HAX1 U1_1_9 ( .A(A[9]), .B(carry[9]), .YC(carry[10]), .YS(SUM[9]) );
  HAX1 U1_1_8 ( .A(A[8]), .B(carry[8]), .YC(carry[9]), .YS(SUM[8]) );
  HAX1 U1_1_7 ( .A(A[7]), .B(carry[7]), .YC(carry[8]), .YS(SUM[7]) );
  HAX1 U1_1_6 ( .A(A[6]), .B(carry[6]), .YC(carry[7]), .YS(SUM[6]) );
  HAX1 U1_1_5 ( .A(A[5]), .B(carry[5]), .YC(carry[6]), .YS(SUM[5]) );
  HAX1 U1_1_4 ( .A(A[4]), .B(carry[4]), .YC(carry[5]), .YS(SUM[4]) );
  HAX1 U1_1_3 ( .A(A[3]), .B(carry[3]), .YC(carry[4]), .YS(SUM[3]) );
  HAX1 U1_1_2 ( .A(A[2]), .B(carry[2]), .YC(carry[3]), .YS(SUM[2]) );
  HAX1 U1_1_1 ( .A(A[1]), .B(A[0]), .YC(carry[2]), .YS(SUM[1]) );
  INVX1 U1 ( .A(A[0]), .Y(SUM[0]) );
  XOR2X1 U2 ( .A(carry[16]), .B(A[16]), .Y(SUM[16]) );
endmodule


module ddr2_init_engine ( ready, csbar, rasbar, casbar, webar, ba, a, odt, 
        ts_con, cke, clk, reset, init, ck );
  output [1:0] ba;
  output [12:0] a;
  input clk, reset, init, ck;
  output ready, csbar, rasbar, casbar, webar, odt, ts_con, cke;
  wire   flag, RESET, INIT, n10, n11, n12, n13, n14, n15, n16, n17, n18, n19,
         n20, n21, n22, n23, n24, n25, n26, n61, n62, n63, n64, n66, n67, n68,
         n69, n70, n71, n72, n73, n74, n75, n76, n77, n78, n79, n80, n81, n82,
         n83, n84, n85, n86, n87, n88, n89, n90, n91, n92, n93, n95, n96, n97,
         n98, n99, n100, n101, n102, n103, n104, n105, n106, n107, n108, n109,
         n110, n112, n113, n114, n115, n116, n117, n118, n119, n120, n121,
         n122, n123, n124, n125, n126, n127, n128, n129, n130, n131, n132,
         n133, n134, n135, n136, n137, n138, n139, n140, n141, n142, n143,
         n144, n145, n146, n147, n148, n149, n150, n151, n152, n153, n154,
         n155, n156, n157, n158, n159, n160, n161, n162, n163, n164, n165,
         n166, n167, n168, n169, n170, n171, n172, n173, n174, n175, n176,
         n177, n178, n179, n180, n181, n182, n183, n184, n185, n186, n187,
         n188, n189, n190, n191, n192, n193, n194, n195, n196, n197, n198,
         n199, n200, n201, n202, n203, n204, n205, n206, n207, n208, n209,
         n210, n211, n212, n213, n214, n215, n216, n217, n218, n219, n220,
         n221, n222, n223, n224, n225, n226, n227, n228, n229, n1, n2, n3, n4,
         n5, n6, n7, n8, n9, n27, n28, n29, n30, n31, n32, n33, n34, n35, n36,
         n37, n38, n39, n40, n41, n42, n43, n44, n45, n46, n47, n48, n49, n50,
         n51, n52, n53, n54, n55, n56, n57, n58, n59, n60, n65, n94, n111,
         n230, n231, n232, n233, n234, n235, n236, n237, n238, n239, n240,
         n241, n242, n243, n244, n245, n246, n247, n248, n249, n250, n251,
         n252, n253, n254, n255, n256, n257, n258, n259, n260, n261, n262,
         n263, n264, n265, n266, n267, n268, n269, n270, n271, n272, n273,
         n274, n275, n276, n277, n278, n279, n280, n281, n282, n283, n284,
         n285, n286, n287, n288, n289, n290, n291, n292, n293, n294, n295,
         n296, n297, n298, n299, n300, n301, n302, n303, n304, n305, n306,
         n307, n308, n309, n310, n311, n312, n313, n314, n315, n316, n317,
         n318, n319, n320, n321, n322, n323, n324, n325, n326, n327, n328,
         n329, n330, n331, n332, n333, n334;
  wire   [16:0] counter;
  assign a[12] = 1'b0;
  assign a[11] = 1'b0;
  assign a[5] = 1'b0;
  assign odt = 1'b0;
  assign ts_con = 1'b0;

  DFFPOSX1 RESET_reg ( .D(reset), .CLK(clk), .Q(RESET) );
  DFFPOSX1 INIT_reg ( .D(init), .CLK(clk), .Q(INIT) );
  DFFPOSX1 flag_reg ( .D(n299), .CLK(clk), .Q(flag) );
  DFFPOSX1 counter_reg_0_ ( .D(n228), .CLK(clk), .Q(counter[0]) );
  DFFPOSX1 counter_reg_1_ ( .D(n227), .CLK(clk), .Q(counter[1]) );
  DFFPOSX1 counter_reg_2_ ( .D(n226), .CLK(clk), .Q(counter[2]) );
  DFFPOSX1 counter_reg_3_ ( .D(n225), .CLK(clk), .Q(counter[3]) );
  DFFPOSX1 counter_reg_4_ ( .D(n224), .CLK(clk), .Q(counter[4]) );
  DFFPOSX1 counter_reg_5_ ( .D(n223), .CLK(clk), .Q(counter[5]) );
  DFFPOSX1 counter_reg_6_ ( .D(n222), .CLK(clk), .Q(counter[6]) );
  DFFPOSX1 counter_reg_7_ ( .D(n221), .CLK(clk), .Q(counter[7]) );
  DFFPOSX1 counter_reg_8_ ( .D(n220), .CLK(clk), .Q(counter[8]) );
  DFFPOSX1 counter_reg_9_ ( .D(n219), .CLK(clk), .Q(counter[9]) );
  DFFPOSX1 counter_reg_10_ ( .D(n218), .CLK(clk), .Q(counter[10]) );
  DFFPOSX1 counter_reg_11_ ( .D(n217), .CLK(clk), .Q(counter[11]) );
  DFFPOSX1 counter_reg_12_ ( .D(n216), .CLK(clk), .Q(counter[12]) );
  DFFPOSX1 counter_reg_13_ ( .D(n215), .CLK(clk), .Q(counter[13]) );
  DFFPOSX1 counter_reg_14_ ( .D(n214), .CLK(clk), .Q(counter[14]) );
  DFFPOSX1 counter_reg_15_ ( .D(n213), .CLK(clk), .Q(counter[15]) );
  DFFPOSX1 counter_reg_16_ ( .D(n212), .CLK(clk), .Q(counter[16]) );
  DFFPOSX1 ready_reg ( .D(n211), .CLK(clk), .Q(ready) );
  DFFPOSX1 casbar_reg ( .D(n208), .CLK(clk), .Q(casbar) );
  DFFPOSX1 csbar_reg ( .D(n210), .CLK(clk), .Q(csbar) );
  DFFPOSX1 webar_reg ( .D(n302), .CLK(clk), .Q(webar) );
  DFFPOSX1 rasbar_reg ( .D(n209), .CLK(clk), .Q(rasbar) );
  DFFPOSX1 cke_reg ( .D(n207), .CLK(clk), .Q(cke) );
  DFFPOSX1 a_reg_10_ ( .D(n29), .CLK(clk), .Q(a[10]) );
  DFFPOSX1 a_reg_9_ ( .D(n27), .CLK(clk), .Q(a[9]) );
  DFFPOSX1 a_reg_8_ ( .D(n28), .CLK(clk), .Q(a[8]) );
  DFFPOSX1 a_reg_7_ ( .D(n30), .CLK(clk), .Q(a[7]) );
  DFFPOSX1 a_reg_6_ ( .D(n250), .CLK(clk), .Q(a[6]) );
  DFFPOSX1 a_reg_4_ ( .D(n254), .CLK(clk), .Q(a[4]) );
  DFFPOSX1 a_reg_3_ ( .D(n261), .CLK(clk), .Q(a[3]) );
  DFFPOSX1 a_reg_2_ ( .D(n199), .CLK(clk), .Q(a[2]) );
  DFFPOSX1 a_reg_1_ ( .D(n269), .CLK(clk), .Q(a[1]) );
  DFFPOSX1 a_reg_0_ ( .D(n274), .CLK(clk), .Q(a[0]) );
  DFFPOSX1 ba_reg_1_ ( .D(n196), .CLK(clk), .Q(ba[1]) );
  DFFPOSX1 ba_reg_0_ ( .D(n195), .CLK(clk), .Q(ba[0]) );
  OAI21X1 U70 ( .A(n61), .B(n287), .C(n247), .Y(n195) );
  AOI21X1 U73 ( .A(n264), .B(n231), .C(n287), .Y(n66) );
  OAI21X1 U79 ( .A(n287), .B(n263), .C(n244), .Y(n199) );
  NAND3X1 U91 ( .A(n44), .B(n241), .C(n57), .Y(n204) );
  NAND3X1 U93 ( .A(n99), .B(n84), .C(n58), .Y(n82) );
  NAND3X1 U94 ( .A(n45), .B(n241), .C(n56), .Y(n205) );
  NAND3X1 U96 ( .A(n99), .B(n84), .C(n310), .Y(n80) );
  OAI21X1 U98 ( .A(n295), .B(n234), .C(n297), .Y(n84) );
  NAND3X1 U100 ( .A(n43), .B(n93), .C(n99), .Y(n91) );
  NAND3X1 U101 ( .A(n9), .B(n277), .C(n96), .Y(n92) );
  OAI21X1 U103 ( .A(n95), .B(n295), .C(n307), .Y(n93) );
  NOR3X1 U104 ( .A(n235), .B(n236), .C(n232), .Y(n95) );
  OAI21X1 U105 ( .A(n98), .B(n278), .C(n267), .Y(n207) );
  NAND3X1 U107 ( .A(n88), .B(counter[1]), .C(n315), .Y(n101) );
  OAI21X1 U108 ( .A(n242), .B(n103), .C(n35), .Y(n208) );
  OAI21X1 U110 ( .A(n311), .B(n240), .C(n34), .Y(n209) );
  AOI22X1 U112 ( .A(n105), .B(n47), .C(webar), .D(n113), .Y(n107) );
  NAND3X1 U113 ( .A(n283), .B(n233), .C(n311), .Y(n108) );
  OAI21X1 U114 ( .A(n242), .B(n240), .C(n33), .Y(n210) );
  OAI21X1 U118 ( .A(n46), .B(n51), .C(n88), .Y(n103) );
  NAND3X1 U119 ( .A(n96), .B(n97), .C(n242), .Y(n115) );
  NAND3X1 U120 ( .A(n233), .B(n234), .C(n283), .Y(n114) );
  NAND3X1 U122 ( .A(n136), .B(n316), .C(n117), .Y(n89) );
  NAND3X1 U127 ( .A(counter[4]), .B(n316), .C(n123), .Y(n121) );
  NAND3X1 U128 ( .A(n125), .B(n325), .C(n126), .Y(n120) );
  NAND3X1 U131 ( .A(n42), .B(n50), .C(n53), .Y(n131) );
  NAND3X1 U132 ( .A(counter[1]), .B(counter[6]), .C(n116), .Y(n134) );
  NAND3X1 U133 ( .A(counter[3]), .B(n49), .C(n117), .Y(n133) );
  NAND3X1 U134 ( .A(n257), .B(n291), .C(n55), .Y(n135) );
  NAND3X1 U136 ( .A(counter[6]), .B(n325), .C(n294), .Y(n119) );
  NAND3X1 U137 ( .A(n136), .B(n318), .C(n140), .Y(n132) );
  NAND3X1 U139 ( .A(n271), .B(n48), .C(n52), .Y(n130) );
  NAND3X1 U140 ( .A(n294), .B(n316), .C(n144), .Y(n143) );
  AOI21X1 U141 ( .A(n146), .B(n147), .C(n148), .Y(n128) );
  OAI21X1 U142 ( .A(n256), .B(n276), .C(n151), .Y(n148) );
  OAI21X1 U143 ( .A(n152), .B(n314), .C(n126), .Y(n151) );
  AOI21X1 U144 ( .A(n140), .B(counter[4]), .C(n118), .Y(n149) );
  NOR3X1 U145 ( .A(n313), .B(counter[3]), .C(n312), .Y(n140) );
  AOI22X1 U146 ( .A(n124), .B(n317), .C(n315), .D(n312), .Y(n127) );
  NAND3X1 U147 ( .A(n146), .B(counter[5]), .C(n154), .Y(n153) );
  NOR3X1 U148 ( .A(n284), .B(counter[8]), .C(counter[6]), .Y(n154) );
  OAI21X1 U149 ( .A(n305), .B(n278), .C(n260), .Y(n211) );
  OAI21X1 U151 ( .A(n295), .B(n271), .C(n307), .Y(n157) );
  NAND3X1 U152 ( .A(n321), .B(n152), .C(n158), .Y(n141) );
  NOR3X1 U153 ( .A(n312), .B(counter[6]), .C(n327), .Y(n158) );
  OAI21X1 U154 ( .A(n298), .B(n334), .C(n289), .Y(n212) );
  OAI21X1 U156 ( .A(n298), .B(n333), .C(n273), .Y(n213) );
  OAI21X1 U158 ( .A(n298), .B(n332), .C(n266), .Y(n214) );
  OAI21X1 U160 ( .A(n298), .B(n331), .C(n259), .Y(n215) );
  OAI21X1 U162 ( .A(n298), .B(n330), .C(n253), .Y(n216) );
  OAI21X1 U164 ( .A(n298), .B(n329), .C(n249), .Y(n217) );
  OAI21X1 U166 ( .A(n298), .B(n328), .C(n246), .Y(n218) );
  OAI21X1 U168 ( .A(n298), .B(n327), .C(n243), .Y(n219) );
  OAI21X1 U170 ( .A(n298), .B(n326), .C(n32), .Y(n220) );
  OAI21X1 U172 ( .A(n299), .B(n325), .C(n279), .Y(n221) );
  OAI21X1 U174 ( .A(n299), .B(n324), .C(n288), .Y(n222) );
  OAI21X1 U176 ( .A(n299), .B(n320), .C(n272), .Y(n223) );
  OAI21X1 U178 ( .A(n299), .B(n318), .C(n265), .Y(n224) );
  OAI21X1 U180 ( .A(n299), .B(n316), .C(n258), .Y(n225) );
  OAI21X1 U182 ( .A(n299), .B(n313), .C(n252), .Y(n226) );
  OAI21X1 U184 ( .A(n299), .B(n312), .C(n248), .Y(n227) );
  OAI21X1 U186 ( .A(n299), .B(n309), .C(n245), .Y(n228) );
  OAI21X1 U188 ( .A(RESET), .B(n292), .C(n278), .Y(n229) );
  AOI21X1 U190 ( .A(n280), .B(n79), .C(n180), .Y(n64) );
  OAI21X1 U191 ( .A(n295), .B(n97), .C(n307), .Y(n180) );
  NAND3X1 U193 ( .A(n181), .B(n320), .C(n54), .Y(n68) );
  AOI21X1 U196 ( .A(n314), .B(n147), .C(n310), .Y(n77) );
  NAND3X1 U197 ( .A(counter[6]), .B(n312), .C(n116), .Y(n72) );
  NOR3X1 U198 ( .A(counter[2]), .B(counter[3]), .C(n325), .Y(n184) );
  NOR3X1 U199 ( .A(n324), .B(n284), .C(n326), .Y(n181) );
  NAND3X1 U200 ( .A(counter[10]), .B(n329), .C(counter[9]), .Y(n155) );
  NAND3X1 U201 ( .A(counter[7]), .B(counter[4]), .C(n185), .Y(n183) );
  NAND3X1 U203 ( .A(counter[1]), .B(n313), .C(n317), .Y(n186) );
  NAND3X1 U204 ( .A(n319), .B(counter[4]), .C(n188), .Y(n187) );
  NAND3X1 U205 ( .A(n145), .B(counter[11]), .C(n190), .Y(n189) );
  NOR3X1 U206 ( .A(n320), .B(counter[9]), .C(counter[10]), .Y(n190) );
  NAND3X1 U207 ( .A(n322), .B(n312), .C(n125), .Y(n85) );
  NAND3X1 U208 ( .A(n324), .B(n325), .C(n294), .Y(n150) );
  NAND3X1 U210 ( .A(n125), .B(n145), .C(n191), .Y(n142) );
  NOR3X1 U211 ( .A(n285), .B(counter[1]), .C(n327), .Y(n191) );
  NAND3X1 U212 ( .A(counter[11]), .B(n328), .C(n286), .Y(n159) );
  NOR3X1 U214 ( .A(counter[2]), .B(counter[4]), .C(n316), .Y(n125) );
  NAND3X1 U218 ( .A(counter[15]), .B(n309), .C(counter[16]), .Y(n194) );
  NAND3X1 U219 ( .A(n331), .B(n332), .C(n330), .Y(n193) );
  ddr2_init_engine_DW01_inc_0 add_94 ( .A(counter), .SUM({n26, n25, n24, n23, 
        n22, n21, n20, n19, n18, n17, n16, n15, n14, n13, n12, n11, n10}) );
  OR2X1 U8 ( .A(n285), .B(counter[9]), .Y(n139) );
  OR2X1 U9 ( .A(n281), .B(n282), .Y(n179) );
  AND2X1 U10 ( .A(n99), .B(n235), .Y(n79) );
  AND2X1 U11 ( .A(n299), .B(n292), .Y(n161) );
  AND2X1 U12 ( .A(n277), .B(n264), .Y(n61) );
  OR2X1 U13 ( .A(n65), .B(n236), .Y(n102) );
  AND2X1 U14 ( .A(n293), .B(n275), .Y(n197) );
  AND2X1 U15 ( .A(n293), .B(n270), .Y(n198) );
  AND2X1 U16 ( .A(n74), .B(n262), .Y(n200) );
  AND2X1 U17 ( .A(n74), .B(n255), .Y(n201) );
  AND2X1 U18 ( .A(n293), .B(n251), .Y(n202) );
  AND2X1 U19 ( .A(n307), .B(n268), .Y(n98) );
  AND2X1 U20 ( .A(n59), .B(n31), .Y(n96) );
  AND2X1 U21 ( .A(n99), .B(n60), .Y(n105) );
  AND2X1 U22 ( .A(n61), .B(n231), .Y(n97) );
  AND2X1 U23 ( .A(n280), .B(n99), .Y(n88) );
  BUFX2 U24 ( .A(n127), .Y(n1) );
  BUFX2 U25 ( .A(n107), .Y(n2) );
  BUFX2 U26 ( .A(n189), .Y(n3) );
  BUFX2 U27 ( .A(n187), .Y(n4) );
  BUFX2 U28 ( .A(n153), .Y(n5) );
  BUFX2 U29 ( .A(n128), .Y(n6) );
  BUFX2 U30 ( .A(n120), .Y(n7) );
  BUFX2 U31 ( .A(n121), .Y(n8) );
  OR2X1 U32 ( .A(n111), .B(n230), .Y(n65) );
  OR2X1 U33 ( .A(n129), .B(n94), .Y(n230) );
  OR2X1 U34 ( .A(n238), .B(n239), .Y(n236) );
  INVX1 U35 ( .A(n236), .Y(n9) );
  OR2X1 U36 ( .A(n122), .B(n237), .Y(n239) );
  OR2X1 U37 ( .A(n39), .B(n40), .Y(n129) );
  AND2X1 U38 ( .A(n118), .B(n136), .Y(n122) );
  BUFX2 U39 ( .A(n205), .Y(n27) );
  BUFX2 U40 ( .A(n204), .Y(n28) );
  AND2X1 U41 ( .A(n38), .B(n36), .Y(n206) );
  INVX1 U42 ( .A(n206), .Y(n29) );
  AND2X1 U43 ( .A(n241), .B(n37), .Y(n203) );
  INVX1 U44 ( .A(n203), .Y(n30) );
  BUFX2 U45 ( .A(n186), .Y(n31) );
  AND2X1 U46 ( .A(n18), .B(n300), .Y(n169) );
  INVX1 U47 ( .A(n169), .Y(n32) );
  AND2X1 U48 ( .A(csbar), .B(n113), .Y(n112) );
  INVX1 U49 ( .A(n112), .Y(n33) );
  AND2X1 U50 ( .A(rasbar), .B(n113), .Y(n106) );
  INVX1 U51 ( .A(n106), .Y(n34) );
  AND2X1 U52 ( .A(casbar), .B(n103), .Y(n104) );
  INVX1 U53 ( .A(n104), .Y(n35) );
  BUFX2 U54 ( .A(n91), .Y(n36) );
  AND2X1 U55 ( .A(a[7]), .B(n304), .Y(n81) );
  INVX1 U56 ( .A(n81), .Y(n37) );
  AND2X1 U57 ( .A(a[10]), .B(n306), .Y(n90) );
  INVX1 U58 ( .A(n90), .Y(n38) );
  BUFX2 U59 ( .A(n130), .Y(n39) );
  BUFX2 U60 ( .A(n131), .Y(n40) );
  BUFX2 U61 ( .A(n66), .Y(n41) );
  BUFX2 U62 ( .A(n132), .Y(n42) );
  BUFX2 U63 ( .A(n92), .Y(n43) );
  BUFX2 U64 ( .A(n82), .Y(n44) );
  AND2X1 U65 ( .A(n79), .B(n84), .Y(n86) );
  INVX1 U66 ( .A(n86), .Y(n45) );
  BUFX2 U67 ( .A(n114), .Y(n46) );
  BUFX2 U68 ( .A(n108), .Y(n47) );
  BUFX2 U69 ( .A(n142), .Y(n48) );
  BUFX2 U71 ( .A(n135), .Y(n49) );
  BUFX2 U72 ( .A(n133), .Y(n50) );
  BUFX2 U74 ( .A(n115), .Y(n51) );
  BUFX2 U75 ( .A(n143), .Y(n52) );
  BUFX2 U76 ( .A(n134), .Y(n53) );
  OR2X1 U77 ( .A(n290), .B(n312), .Y(n182) );
  INVX1 U78 ( .A(n182), .Y(n54) );
  AND2X1 U80 ( .A(n138), .B(n325), .Y(n137) );
  INVX1 U81 ( .A(n137), .Y(n55) );
  AND2X1 U82 ( .A(a[9]), .B(n304), .Y(n87) );
  INVX1 U83 ( .A(n87), .Y(n56) );
  AND2X1 U84 ( .A(a[8]), .B(n304), .Y(n83) );
  INVX1 U85 ( .A(n83), .Y(n57) );
  INVX1 U86 ( .A(n59), .Y(n58) );
  BUFX2 U87 ( .A(n85), .Y(n59) );
  AND2X1 U88 ( .A(n307), .B(n103), .Y(n113) );
  INVX1 U89 ( .A(n113), .Y(n60) );
  INVX1 U90 ( .A(n6), .Y(n94) );
  INVX1 U92 ( .A(n1), .Y(n111) );
  BUFX2 U95 ( .A(n68), .Y(n231) );
  INVX1 U97 ( .A(n97), .Y(n232) );
  AND2X1 U99 ( .A(n323), .B(n118), .Y(n110) );
  INVX1 U102 ( .A(n110), .Y(n233) );
  BUFX2 U106 ( .A(n89), .Y(n234) );
  INVX1 U109 ( .A(n96), .Y(n235) );
  INVX1 U111 ( .A(n8), .Y(n237) );
  INVX1 U115 ( .A(n7), .Y(n238) );
  INVX1 U116 ( .A(n105), .Y(n240) );
  BUFX2 U117 ( .A(n80), .Y(n241) );
  INVX1 U121 ( .A(n102), .Y(n242) );
  AND2X1 U123 ( .A(n19), .B(n301), .Y(n168) );
  INVX1 U124 ( .A(n168), .Y(n243) );
  AND2X1 U125 ( .A(a[2]), .B(n297), .Y(n73) );
  INVX1 U126 ( .A(n73), .Y(n244) );
  AND2X1 U129 ( .A(n10), .B(n300), .Y(n177) );
  INVX1 U130 ( .A(n177), .Y(n245) );
  AND2X1 U135 ( .A(n20), .B(n301), .Y(n167) );
  INVX1 U138 ( .A(n167), .Y(n246) );
  AND2X1 U150 ( .A(ba[0]), .B(n297), .Y(n63) );
  INVX1 U155 ( .A(n63), .Y(n247) );
  AND2X1 U157 ( .A(n11), .B(n300), .Y(n176) );
  INVX1 U159 ( .A(n176), .Y(n248) );
  AND2X1 U161 ( .A(n21), .B(n301), .Y(n166) );
  INVX1 U163 ( .A(n166), .Y(n249) );
  INVX1 U165 ( .A(n202), .Y(n250) );
  AND2X1 U167 ( .A(a[6]), .B(n297), .Y(n78) );
  INVX1 U169 ( .A(n78), .Y(n251) );
  AND2X1 U171 ( .A(n12), .B(n300), .Y(n175) );
  INVX1 U173 ( .A(n175), .Y(n252) );
  AND2X1 U175 ( .A(n22), .B(n301), .Y(n165) );
  INVX1 U177 ( .A(n165), .Y(n253) );
  INVX1 U179 ( .A(n201), .Y(n254) );
  AND2X1 U181 ( .A(a[4]), .B(n297), .Y(n76) );
  INVX1 U183 ( .A(n76), .Y(n255) );
  BUFX2 U185 ( .A(n149), .Y(n256) );
  BUFX2 U187 ( .A(n119), .Y(n257) );
  AND2X1 U189 ( .A(n13), .B(n300), .Y(n174) );
  INVX1 U192 ( .A(n174), .Y(n258) );
  AND2X1 U194 ( .A(n23), .B(n301), .Y(n164) );
  INVX1 U195 ( .A(n164), .Y(n259) );
  AND2X1 U202 ( .A(ready), .B(n305), .Y(n156) );
  INVX1 U209 ( .A(n156), .Y(n260) );
  INVX1 U213 ( .A(n200), .Y(n261) );
  AND2X1 U215 ( .A(a[3]), .B(n297), .Y(n75) );
  INVX1 U216 ( .A(n75), .Y(n262) );
  OR2X1 U217 ( .A(n287), .B(n277), .Y(n74) );
  BUFX2 U220 ( .A(n72), .Y(n263) );
  AND2X1 U221 ( .A(n147), .B(n152), .Y(n67) );
  INVX1 U222 ( .A(n67), .Y(n264) );
  AND2X1 U223 ( .A(n14), .B(n300), .Y(n173) );
  INVX1 U224 ( .A(n173), .Y(n265) );
  AND2X1 U225 ( .A(n24), .B(n301), .Y(n163) );
  INVX1 U226 ( .A(n163), .Y(n266) );
  AND2X1 U227 ( .A(cke), .B(n98), .Y(n100) );
  INVX1 U228 ( .A(n100), .Y(n267) );
  BUFX2 U229 ( .A(n101), .Y(n268) );
  INVX1 U230 ( .A(n198), .Y(n269) );
  AND2X1 U231 ( .A(a[1]), .B(n297), .Y(n71) );
  INVX1 U232 ( .A(n71), .Y(n270) );
  BUFX2 U233 ( .A(n141), .Y(n271) );
  AND2X1 U234 ( .A(n15), .B(n300), .Y(n172) );
  INVX1 U235 ( .A(n172), .Y(n272) );
  AND2X1 U236 ( .A(n25), .B(n301), .Y(n162) );
  INVX1 U237 ( .A(n162), .Y(n273) );
  INVX1 U238 ( .A(n197), .Y(n274) );
  AND2X1 U239 ( .A(a[0]), .B(n297), .Y(n70) );
  INVX1 U240 ( .A(n70), .Y(n275) );
  BUFX2 U241 ( .A(n150), .Y(n276) );
  BUFX2 U242 ( .A(n77), .Y(n277) );
  AND2X1 U243 ( .A(flag), .B(n307), .Y(n99) );
  INVX1 U244 ( .A(n99), .Y(n278) );
  AND2X1 U245 ( .A(n17), .B(n300), .Y(n170) );
  INVX1 U246 ( .A(n170), .Y(n279) );
  INVX1 U247 ( .A(n179), .Y(n280) );
  BUFX2 U248 ( .A(n193), .Y(n281) );
  BUFX2 U249 ( .A(n194), .Y(n282) );
  AND2X1 U250 ( .A(n116), .B(counter[1]), .Y(n109) );
  INVX1 U251 ( .A(n109), .Y(n283) );
  AND2X1 U252 ( .A(n294), .B(n146), .Y(n116) );
  BUFX2 U253 ( .A(n155), .Y(n284) );
  BUFX2 U254 ( .A(n159), .Y(n285) );
  OR2X1 U255 ( .A(counter[8]), .B(counter[5]), .Y(n192) );
  INVX1 U256 ( .A(n192), .Y(n286) );
  AND2X1 U257 ( .A(n99), .B(n303), .Y(n62) );
  INVX1 U258 ( .A(n62), .Y(n287) );
  AND2X1 U259 ( .A(n16), .B(n300), .Y(n171) );
  INVX1 U260 ( .A(n171), .Y(n288) );
  AND2X1 U261 ( .A(n26), .B(n301), .Y(n160) );
  INVX1 U262 ( .A(n160), .Y(n289) );
  BUFX2 U263 ( .A(n183), .Y(n290) );
  AND2X1 U264 ( .A(n319), .B(counter[8]), .Y(n136) );
  INVX1 U265 ( .A(n136), .Y(n291) );
  AND2X1 U266 ( .A(INIT), .B(n308), .Y(n178) );
  INVX1 U267 ( .A(n178), .Y(n292) );
  AND2X1 U268 ( .A(n79), .B(n303), .Y(n69) );
  INVX1 U269 ( .A(n69), .Y(n293) );
  INVX1 U270 ( .A(n139), .Y(n294) );
  INVX1 U271 ( .A(n88), .Y(n295) );
  INVX1 U272 ( .A(n84), .Y(n304) );
  BUFX2 U273 ( .A(n161), .Y(n300) );
  BUFX2 U274 ( .A(n161), .Y(n301) );
  INVX1 U275 ( .A(n65), .Y(n311) );
  INVX1 U276 ( .A(n276), .Y(n322) );
  INVX1 U277 ( .A(n93), .Y(n306) );
  INVX1 U278 ( .A(n297), .Y(n303) );
  INVX1 U279 ( .A(n257), .Y(n323) );
  BUFX2 U280 ( .A(n229), .Y(n299) );
  BUFX2 U281 ( .A(n229), .Y(n298) );
  BUFX2 U282 ( .A(n64), .Y(n297) );
  AND2X1 U283 ( .A(n124), .B(n318), .Y(n117) );
  AND2X1 U284 ( .A(n184), .B(n318), .Y(n146) );
  AND2X1 U285 ( .A(n138), .B(n312), .Y(n147) );
  INVX1 U286 ( .A(n263), .Y(n310) );
  INVX1 U287 ( .A(n290), .Y(n314) );
  AND2X1 U288 ( .A(n145), .B(n117), .Y(n144) );
  AND2X1 U289 ( .A(n322), .B(n124), .Y(n123) );
  INVX1 U290 ( .A(counter[16]), .Y(n334) );
  INVX1 U291 ( .A(counter[15]), .Y(n333) );
  INVX1 U292 ( .A(n285), .Y(n321) );
  AND2X1 U293 ( .A(counter[3]), .B(counter[2]), .Y(n185) );
  INVX1 U294 ( .A(flag), .Y(n308) );
  INVX1 U295 ( .A(n157), .Y(n305) );
  INVX1 U296 ( .A(counter[7]), .Y(n325) );
  INVX1 U297 ( .A(n4), .Y(n317) );
  AND2X1 U298 ( .A(counter[3]), .B(n326), .Y(n188) );
  INVX1 U299 ( .A(counter[3]), .Y(n316) );
  INVX1 U300 ( .A(counter[1]), .Y(n312) );
  OR2X1 U301 ( .A(n296), .B(n41), .Y(n196) );
  AND2X1 U302 ( .A(ba[1]), .B(n297), .Y(n296) );
  INVX1 U303 ( .A(counter[6]), .Y(n324) );
  INVX1 U304 ( .A(counter[4]), .Y(n318) );
  AND2X1 U305 ( .A(n125), .B(counter[1]), .Y(n118) );
  INVX1 U306 ( .A(counter[9]), .Y(n327) );
  INVX1 U307 ( .A(RESET), .Y(n307) );
  AND2X1 U308 ( .A(n184), .B(counter[4]), .Y(n152) );
  INVX1 U309 ( .A(counter[2]), .Y(n313) );
  INVX1 U310 ( .A(counter[5]), .Y(n320) );
  AND2X1 U311 ( .A(counter[7]), .B(n324), .Y(n145) );
  INVX1 U312 ( .A(counter[8]), .Y(n326) );
  AND2X1 U313 ( .A(counter[2]), .B(n312), .Y(n124) );
  AND2X1 U314 ( .A(counter[5]), .B(n181), .Y(n138) );
  AND2X1 U315 ( .A(n138), .B(counter[1]), .Y(n126) );
  INVX1 U316 ( .A(n5), .Y(n315) );
  INVX1 U317 ( .A(n2), .Y(n302) );
  INVX1 U318 ( .A(counter[10]), .Y(n328) );
  INVX1 U319 ( .A(counter[11]), .Y(n329) );
  INVX1 U320 ( .A(n3), .Y(n319) );
  INVX1 U321 ( .A(counter[0]), .Y(n309) );
  INVX1 U322 ( .A(counter[12]), .Y(n330) );
  INVX1 U323 ( .A(counter[14]), .Y(n332) );
  INVX1 U324 ( .A(counter[13]), .Y(n331) );
endmodule


module SSTL18DDR2DIFF ( PAD, PADN, Z, A, RI, TS );
  input A, RI, TS;
  output Z;
  inout PAD,  PADN;
  wire   n1, n2, n3, n5;

  TBUFX2 b2 ( .A(A), .EN(TS), .Y(PADN) );
  TBUFX2 b1 ( .A(n5), .EN(TS), .Y(PAD) );
  NAND3X1 U2 ( .A(PAD), .B(n2), .C(RI), .Y(n1) );
  BUFX2 U1 ( .A(n1), .Y(n3) );
  INVX1 U3 ( .A(n3), .Y(Z) );
  INVX1 U4 ( .A(A), .Y(n5) );
  INVX1 U5 ( .A(PADN), .Y(n2) );
endmodule


module SSTL18DDR2_42 ( PAD, Z, A, RI, TS );
  input A, RI, TS;
  output Z;
  inout PAD;
  wire   n1;

  TBUFX2 b1 ( .A(n1), .EN(TS), .Y(PAD) );
  AND2X1 U1 ( .A(RI), .B(PAD), .Y(Z) );
  INVX1 U2 ( .A(A), .Y(n1) );
endmodule


module SSTL18DDR2_41 ( PAD, Z, A, RI, TS );
  input A, RI, TS;
  output Z;
  inout PAD;
  wire   n1;

  TBUFX2 b1 ( .A(n1), .EN(TS), .Y(PAD) );
  AND2X1 U1 ( .A(RI), .B(PAD), .Y(Z) );
  INVX1 U2 ( .A(A), .Y(n1) );
endmodule


module SSTL18DDR2_40 ( PAD, Z, A, RI, TS );
  input A, RI, TS;
  output Z;
  inout PAD;
  wire   n1;

  TBUFX2 b1 ( .A(n1), .EN(TS), .Y(PAD) );
  AND2X1 U1 ( .A(RI), .B(PAD), .Y(Z) );
  INVX1 U2 ( .A(A), .Y(n1) );
endmodule


module SSTL18DDR2_39 ( PAD, Z, A, RI, TS );
  input A, RI, TS;
  output Z;
  inout PAD;
  wire   n1;

  TBUFX2 b1 ( .A(n1), .EN(TS), .Y(PAD) );
  AND2X1 U1 ( .A(RI), .B(PAD), .Y(Z) );
  INVX1 U2 ( .A(A), .Y(n1) );
endmodule


module SSTL18DDR2_38 ( PAD, Z, A, RI, TS );
  input A, RI, TS;
  output Z;
  inout PAD;
  wire   n1;

  TBUFX2 b1 ( .A(n1), .EN(TS), .Y(PAD) );
  AND2X1 U1 ( .A(RI), .B(PAD), .Y(Z) );
  INVX1 U2 ( .A(A), .Y(n1) );
endmodule


module SSTL18DDR2_37 ( PAD, Z, A, RI, TS );
  input A, RI, TS;
  output Z;
  inout PAD;
  wire   n1;

  TBUFX2 b1 ( .A(n1), .EN(TS), .Y(PAD) );
  AND2X1 U1 ( .A(RI), .B(PAD), .Y(Z) );
  INVX1 U2 ( .A(A), .Y(n1) );
endmodule


module SSTL18DDR2_36 ( PAD, Z, A, RI, TS );
  input A, RI, TS;
  output Z;
  inout PAD;
  wire   n1;

  TBUFX2 b1 ( .A(n1), .EN(TS), .Y(PAD) );
  AND2X1 U1 ( .A(RI), .B(PAD), .Y(Z) );
  INVX1 U2 ( .A(A), .Y(n1) );
endmodule


module SSTL18DDR2_35 ( PAD, Z, A, RI, TS );
  input A, RI, TS;
  output Z;
  inout PAD;
  wire   n1;

  TBUFX2 b1 ( .A(n1), .EN(TS), .Y(PAD) );
  AND2X1 U1 ( .A(RI), .B(PAD), .Y(Z) );
  INVX1 U2 ( .A(A), .Y(n1) );
endmodule


module SSTL18DDR2_34 ( PAD, Z, A, RI, TS );
  input A, RI, TS;
  output Z;
  inout PAD;
  wire   n1;

  TBUFX2 b1 ( .A(n1), .EN(TS), .Y(PAD) );
  AND2X1 U1 ( .A(RI), .B(PAD), .Y(Z) );
  INVX1 U2 ( .A(A), .Y(n1) );
endmodule


module SSTL18DDR2_33 ( PAD, Z, A, RI, TS );
  input A, RI, TS;
  output Z;
  inout PAD;
  wire   n1;

  TBUFX2 b1 ( .A(n1), .EN(TS), .Y(PAD) );
  AND2X1 U1 ( .A(RI), .B(PAD), .Y(Z) );
  INVX1 U2 ( .A(A), .Y(n1) );
endmodule


module SSTL18DDR2_32 ( PAD, Z, A, RI, TS );
  input A, RI, TS;
  output Z;
  inout PAD;
  wire   n1;

  TBUFX2 b1 ( .A(n1), .EN(TS), .Y(PAD) );
  AND2X1 U1 ( .A(RI), .B(PAD), .Y(Z) );
  INVX1 U2 ( .A(A), .Y(n1) );
endmodule


module SSTL18DDR2_31 ( PAD, Z, A, RI, TS );
  input A, RI, TS;
  output Z;
  inout PAD;
  wire   n1;

  TBUFX2 b1 ( .A(n1), .EN(TS), .Y(PAD) );
  AND2X1 U1 ( .A(RI), .B(PAD), .Y(Z) );
  INVX1 U2 ( .A(A), .Y(n1) );
endmodule


module SSTL18DDR2_30 ( PAD, Z, A, RI, TS );
  input A, RI, TS;
  output Z;
  inout PAD;
  wire   n1;

  TBUFX2 b1 ( .A(n1), .EN(TS), .Y(PAD) );
  AND2X1 U1 ( .A(RI), .B(PAD), .Y(Z) );
  INVX1 U2 ( .A(A), .Y(n1) );
endmodule


module SSTL18DDR2_29 ( PAD, Z, A, RI, TS );
  input A, RI, TS;
  output Z;
  inout PAD;
  wire   n1;

  TBUFX2 b1 ( .A(n1), .EN(TS), .Y(PAD) );
  AND2X1 U1 ( .A(RI), .B(PAD), .Y(Z) );
  INVX1 U2 ( .A(A), .Y(n1) );
endmodule


module SSTL18DDR2_28 ( PAD, Z, A, RI, TS );
  input A, RI, TS;
  output Z;
  inout PAD;
  wire   n1;

  TBUFX2 b1 ( .A(n1), .EN(TS), .Y(PAD) );
  AND2X1 U1 ( .A(RI), .B(PAD), .Y(Z) );
  INVX1 U2 ( .A(A), .Y(n1) );
endmodule


module SSTL18DDR2_27 ( PAD, Z, A, RI, TS );
  input A, RI, TS;
  output Z;
  inout PAD;
  wire   n1;

  TBUFX2 b1 ( .A(n1), .EN(TS), .Y(PAD) );
  AND2X1 U1 ( .A(RI), .B(PAD), .Y(Z) );
  INVX1 U2 ( .A(A), .Y(n1) );
endmodule


module SSTL18DDR2_26 ( PAD, Z, A, RI, TS );
  input A, RI, TS;
  output Z;
  inout PAD;
  wire   n1;

  TBUFX2 b1 ( .A(n1), .EN(TS), .Y(PAD) );
  AND2X1 U1 ( .A(RI), .B(PAD), .Y(Z) );
  INVX1 U2 ( .A(A), .Y(n1) );
endmodule


module SSTL18DDR2_25 ( PAD, Z, A, RI, TS );
  input A, RI, TS;
  output Z;
  inout PAD;
  wire   n1;

  TBUFX2 b1 ( .A(n1), .EN(TS), .Y(PAD) );
  AND2X1 U1 ( .A(RI), .B(PAD), .Y(Z) );
  INVX1 U2 ( .A(A), .Y(n1) );
endmodule


module SSTL18DDR2_24 ( PAD, Z, A, RI, TS );
  input A, RI, TS;
  output Z;
  inout PAD;
  wire   n1;

  TBUFX2 b1 ( .A(n1), .EN(TS), .Y(PAD) );
  AND2X1 U1 ( .A(RI), .B(PAD), .Y(Z) );
  INVX1 U2 ( .A(A), .Y(n1) );
endmodule


module SSTL18DDR2_23 ( PAD, Z, A, RI, TS );
  input A, RI, TS;
  output Z;
  inout PAD;
  wire   n1;

  TBUFX2 b1 ( .A(n1), .EN(TS), .Y(PAD) );
  AND2X1 U1 ( .A(RI), .B(PAD), .Y(Z) );
  INVX1 U2 ( .A(A), .Y(n1) );
endmodule


module SSTL18DDR2_22 ( PAD, Z, A, RI, TS );
  input A, RI, TS;
  output Z;
  inout PAD;
  wire   n1;

  TBUFX2 b1 ( .A(n1), .EN(TS), .Y(PAD) );
  AND2X1 U1 ( .A(RI), .B(PAD), .Y(Z) );
  INVX1 U2 ( .A(A), .Y(n1) );
endmodule


module SSTL18DDR2_21 ( PAD, Z, A, RI, TS );
  input A, RI, TS;
  output Z;
  inout PAD;
  wire   n1;

  TBUFX2 b1 ( .A(n1), .EN(TS), .Y(PAD) );
  AND2X1 U1 ( .A(RI), .B(PAD), .Y(Z) );
  INVX1 U2 ( .A(A), .Y(n1) );
endmodule


module SSTL18DDR2_20 ( PAD, Z, A, RI, TS );
  input A, RI, TS;
  output Z;
  inout PAD;
  wire   n1;

  TBUFX2 b1 ( .A(n1), .EN(TS), .Y(PAD) );
  AND2X1 U1 ( .A(RI), .B(PAD), .Y(Z) );
  INVX1 U2 ( .A(A), .Y(n1) );
endmodule


module SSTL18DDR2_19 ( PAD, Z, A, RI, TS );
  input A, RI, TS;
  output Z;
  inout PAD;
  wire   n1;

  TBUFX2 b1 ( .A(n1), .EN(TS), .Y(PAD) );
  AND2X1 U1 ( .A(RI), .B(PAD), .Y(Z) );
  INVX1 U2 ( .A(A), .Y(n1) );
endmodule


module SSTL18DDR2_18 ( PAD, Z, A, RI, TS );
  input A, RI, TS;
  output Z;
  inout PAD;
  wire   n1;

  TBUFX2 b1 ( .A(n1), .EN(TS), .Y(PAD) );
  AND2X1 U1 ( .A(RI), .B(PAD), .Y(Z) );
  INVX1 U2 ( .A(A), .Y(n1) );
endmodule


module SSTL18DDR2_17 ( PAD, Z, A, RI, TS );
  input A, RI, TS;
  output Z;
  inout PAD;
  wire   n1;

  TBUFX2 b1 ( .A(n1), .EN(TS), .Y(PAD) );
  AND2X1 U1 ( .A(RI), .B(PAD), .Y(Z) );
  INVX1 U2 ( .A(A), .Y(n1) );
endmodule


module SSTL18DDR2_16 ( PAD, Z, A, RI, TS );
  input A, RI, TS;
  output Z;
  inout PAD;
  wire   n1;

  TBUFX2 b1 ( .A(n1), .EN(TS), .Y(PAD) );
  AND2X1 U1 ( .A(RI), .B(PAD), .Y(Z) );
  INVX1 U2 ( .A(A), .Y(n1) );
endmodule


module SSTL18DDR2_15 ( PAD, Z, A, RI, TS );
  input A, RI, TS;
  output Z;
  inout PAD;
  wire   n1;

  TBUFX2 b1 ( .A(n1), .EN(TS), .Y(PAD) );
  AND2X1 U1 ( .A(RI), .B(PAD), .Y(Z) );
  INVX1 U2 ( .A(A), .Y(n1) );
endmodule


module SSTL18DDR2_14 ( PAD, Z, A, RI, TS );
  input A, RI, TS;
  output Z;
  inout PAD;
  wire   n1;

  TBUFX2 b1 ( .A(n1), .EN(TS), .Y(PAD) );
  AND2X1 U1 ( .A(RI), .B(PAD), .Y(Z) );
  INVX1 U2 ( .A(A), .Y(n1) );
endmodule


module SSTL18DDR2_13 ( PAD, Z, A, RI, TS );
  input A, RI, TS;
  output Z;
  inout PAD;
  wire   n1;

  TBUFX2 b1 ( .A(n1), .EN(TS), .Y(PAD) );
  AND2X1 U1 ( .A(RI), .B(PAD), .Y(Z) );
  INVX1 U2 ( .A(A), .Y(n1) );
endmodule


module SSTL18DDR2_12 ( PAD, Z, A, RI, TS );
  input A, RI, TS;
  output Z;
  inout PAD;
  wire   n1;

  TBUFX2 b1 ( .A(n1), .EN(TS), .Y(PAD) );
  AND2X1 U1 ( .A(RI), .B(PAD), .Y(Z) );
  INVX1 U2 ( .A(A), .Y(n1) );
endmodule


module SSTL18DDR2_11 ( PAD, Z, A, RI, TS );
  input A, RI, TS;
  output Z;
  inout PAD;
  wire   n1;

  TBUFX2 b1 ( .A(n1), .EN(TS), .Y(PAD) );
  AND2X1 U1 ( .A(RI), .B(PAD), .Y(Z) );
  INVX1 U2 ( .A(A), .Y(n1) );
endmodule


module SSTL18DDR2_10 ( PAD, Z, A, RI, TS );
  input A, RI, TS;
  output Z;
  inout PAD;
  wire   n1;

  TBUFX2 b1 ( .A(n1), .EN(TS), .Y(PAD) );
  AND2X1 U1 ( .A(RI), .B(PAD), .Y(Z) );
  INVX1 U2 ( .A(A), .Y(n1) );
endmodule


module SSTL18DDR2_9 ( PAD, Z, A, RI, TS );
  input A, RI, TS;
  output Z;
  inout PAD;
  wire   n1;

  TBUFX2 b1 ( .A(n1), .EN(TS), .Y(PAD) );
  AND2X1 U1 ( .A(RI), .B(PAD), .Y(Z) );
  INVX1 U2 ( .A(A), .Y(n1) );
endmodule


module SSTL18DDR2_8 ( PAD, Z, A, RI, TS );
  input A, RI, TS;
  output Z;
  inout PAD;
  wire   n1;

  TBUFX2 b1 ( .A(n1), .EN(TS), .Y(PAD) );
  AND2X1 U1 ( .A(RI), .B(PAD), .Y(Z) );
  INVX1 U2 ( .A(A), .Y(n1) );
endmodule


module SSTL18DDR2_7 ( PAD, Z, A, RI, TS );
  input A, RI, TS;
  output Z;
  inout PAD;
  wire   n1;

  TBUFX2 b1 ( .A(n1), .EN(TS), .Y(PAD) );
  AND2X1 U1 ( .A(RI), .B(PAD), .Y(Z) );
  INVX1 U2 ( .A(A), .Y(n1) );
endmodule


module SSTL18DDR2_6 ( PAD, Z, A, RI, TS );
  input A, RI, TS;
  output Z;
  inout PAD;
  wire   n1;

  TBUFX2 b1 ( .A(n1), .EN(TS), .Y(PAD) );
  AND2X1 U1 ( .A(RI), .B(PAD), .Y(Z) );
  INVX1 U2 ( .A(A), .Y(n1) );
endmodule


module SSTL18DDR2_5 ( PAD, Z, A, RI, TS );
  input A, RI, TS;
  output Z;
  inout PAD;
  wire   n1;

  TBUFX2 b1 ( .A(n1), .EN(TS), .Y(PAD) );
  AND2X1 U1 ( .A(RI), .B(PAD), .Y(Z) );
  INVX1 U2 ( .A(A), .Y(n1) );
endmodule


module SSTL18DDR2_4 ( PAD, Z, A, RI, TS );
  input A, RI, TS;
  output Z;
  inout PAD;
  wire   n1;

  TBUFX2 b1 ( .A(n1), .EN(TS), .Y(PAD) );
  AND2X1 U1 ( .A(RI), .B(PAD), .Y(Z) );
  INVX1 U2 ( .A(A), .Y(n1) );
endmodule


module SSTL18DDR2_3 ( PAD, Z, A, RI, TS );
  input A, RI, TS;
  output Z;
  inout PAD;
  wire   n1;

  TBUFX2 b1 ( .A(n1), .EN(TS), .Y(PAD) );
  AND2X1 U1 ( .A(RI), .B(PAD), .Y(Z) );
  INVX1 U2 ( .A(A), .Y(n1) );
endmodule


module SSTL18DDR2_2 ( PAD, Z, A, RI, TS );
  input A, RI, TS;
  output Z;
  inout PAD;
  wire   n1;

  TBUFX2 b1 ( .A(n1), .EN(TS), .Y(PAD) );
  AND2X1 U1 ( .A(RI), .B(PAD), .Y(Z) );
  INVX1 U2 ( .A(A), .Y(n1) );
endmodule


module SSTL18DDR2_1 ( PAD, Z, A, RI, TS );
  input A, RI, TS;
  output Z;
  inout PAD;
  wire   n1;

  TBUFX2 b1 ( .A(n1), .EN(TS), .Y(PAD) );
  AND2X1 U1 ( .A(RI), .B(PAD), .Y(Z) );
  INVX1 U2 ( .A(A), .Y(n1) );
endmodule


module SSTL18DDR2_0 ( PAD, Z, A, RI, TS );
  input A, RI, TS;
  output Z;
  inout PAD;
  wire   n1;

  TBUFX2 b1 ( .A(n1), .EN(TS), .Y(PAD) );
  AND2X1 U1 ( .A(RI), .B(PAD), .Y(Z) );
  INVX1 U2 ( .A(A), .Y(n1) );
endmodule


module SSTL18DDR2INTERFACE ( ck_pad, ckbar_pad, cke_pad, csbar_pad, rasbar_pad, 
        casbar_pad, webar_pad, ba_pad, a_pad, dm_pad, odt_pad, dq_o, dqs_o, 
        dqsbar_o, dq_pad, dqs_pad, dqsbar_pad, ri_i, ts_i, ck_i, cke_i, 
        csbar_i, rasbar_i, casbar_i, webar_i, ba_i, a_i, dq_i, dqs_i, dqsbar_i, 
        dm_i, odt_i );
  output [1:0] ba_pad;
  output [12:0] a_pad;
  output [1:0] dm_pad;
  output [15:0] dq_o;
  output [1:0] dqs_o;
  output [1:0] dqsbar_o;
  inout [15:0] dq_pad;
  inout [1:0] dqs_pad;
  inout [1:0] dqsbar_pad;
  input [1:0] ba_i;
  input [12:0] a_i;
  input [15:0] dq_i;
  input [1:0] dqs_i;
  input [1:0] dqsbar_i;
  input [1:0] dm_i;
  input ri_i, ts_i, ck_i, cke_i, csbar_i, rasbar_i, casbar_i, webar_i, odt_i;
  output ck_pad, ckbar_pad, cke_pad, csbar_pad, rasbar_pad, casbar_pad,
         webar_pad, odt_pad;


  SSTL18DDR2DIFF ck_sstl ( .PAD(ck_pad), .PADN(ckbar_pad), .Z(), .A(ck_i), 
        .RI(1'b0), .TS(1'b1) );
  SSTL18DDR2_42 cke_sstl ( .PAD(cke_pad), .Z(), .A(cke_i), .RI(1'b0), .TS(1'b1) );
  SSTL18DDR2_41 casbar_sstl ( .PAD(casbar_pad), .Z(), .A(casbar_i), .RI(1'b0), 
        .TS(1'b1) );
  SSTL18DDR2_40 rasbar_sstl ( .PAD(rasbar_pad), .Z(), .A(rasbar_i), .RI(1'b0), 
        .TS(1'b1) );
  SSTL18DDR2_39 csbar_sstl ( .PAD(csbar_pad), .Z(), .A(csbar_i), .RI(1'b0), 
        .TS(1'b1) );
  SSTL18DDR2_38 webar_sstl ( .PAD(webar_pad), .Z(), .A(webar_i), .RI(1'b0), 
        .TS(1'b1) );
  SSTL18DDR2_37 odt_sstl ( .PAD(odt_pad), .Z(), .A(odt_i), .RI(1'b0), .TS(1'b1) );
  SSTL18DDR2_36 BA_0__sstl_ba ( .PAD(ba_pad[0]), .Z(), .A(ba_i[0]), .RI(1'b0), 
        .TS(1'b1) );
  SSTL18DDR2_35 BA_1__sstl_ba ( .PAD(ba_pad[1]), .Z(), .A(ba_i[1]), .RI(1'b0), 
        .TS(1'b1) );
  SSTL18DDR2_34 A_0__sstl_a ( .PAD(a_pad[0]), .Z(), .A(a_i[0]), .RI(1'b0), 
        .TS(1'b1) );
  SSTL18DDR2_33 A_1__sstl_a ( .PAD(a_pad[1]), .Z(), .A(a_i[1]), .RI(1'b0), 
        .TS(1'b1) );
  SSTL18DDR2_32 A_2__sstl_a ( .PAD(a_pad[2]), .Z(), .A(a_i[2]), .RI(1'b0), 
        .TS(1'b1) );
  SSTL18DDR2_31 A_3__sstl_a ( .PAD(a_pad[3]), .Z(), .A(a_i[3]), .RI(1'b0), 
        .TS(1'b1) );
  SSTL18DDR2_30 A_4__sstl_a ( .PAD(a_pad[4]), .Z(), .A(a_i[4]), .RI(1'b0), 
        .TS(1'b1) );
  SSTL18DDR2_29 A_5__sstl_a ( .PAD(a_pad[5]), .Z(), .A(a_i[5]), .RI(1'b0), 
        .TS(1'b1) );
  SSTL18DDR2_28 A_6__sstl_a ( .PAD(a_pad[6]), .Z(), .A(a_i[6]), .RI(1'b0), 
        .TS(1'b1) );
  SSTL18DDR2_27 A_7__sstl_a ( .PAD(a_pad[7]), .Z(), .A(a_i[7]), .RI(1'b0), 
        .TS(1'b1) );
  SSTL18DDR2_26 A_8__sstl_a ( .PAD(a_pad[8]), .Z(), .A(a_i[8]), .RI(1'b0), 
        .TS(1'b1) );
  SSTL18DDR2_25 A_9__sstl_a ( .PAD(a_pad[9]), .Z(), .A(a_i[9]), .RI(1'b0), 
        .TS(1'b1) );
  SSTL18DDR2_24 A_10__sstl_a ( .PAD(a_pad[10]), .Z(), .A(a_i[10]), .RI(1'b0), 
        .TS(1'b1) );
  SSTL18DDR2_23 A_11__sstl_a ( .PAD(a_pad[11]), .Z(), .A(a_i[11]), .RI(1'b0), 
        .TS(1'b1) );
  SSTL18DDR2_22 A_12__sstl_a ( .PAD(a_pad[12]), .Z(), .A(a_i[12]), .RI(1'b0), 
        .TS(1'b1) );
  SSTL18DDR2_21 DQ_0__sstl_dq ( .PAD(dq_pad[0]), .Z(dq_o[0]), .A(dq_i[0]), 
        .RI(ri_i), .TS(ts_i) );
  SSTL18DDR2_20 DQ_1__sstl_dq ( .PAD(dq_pad[1]), .Z(dq_o[1]), .A(dq_i[1]), 
        .RI(ri_i), .TS(ts_i) );
  SSTL18DDR2_19 DQ_2__sstl_dq ( .PAD(dq_pad[2]), .Z(dq_o[2]), .A(dq_i[2]), 
        .RI(ri_i), .TS(ts_i) );
  SSTL18DDR2_18 DQ_3__sstl_dq ( .PAD(dq_pad[3]), .Z(dq_o[3]), .A(dq_i[3]), 
        .RI(ri_i), .TS(ts_i) );
  SSTL18DDR2_17 DQ_4__sstl_dq ( .PAD(dq_pad[4]), .Z(dq_o[4]), .A(dq_i[4]), 
        .RI(ri_i), .TS(ts_i) );
  SSTL18DDR2_16 DQ_5__sstl_dq ( .PAD(dq_pad[5]), .Z(dq_o[5]), .A(dq_i[5]), 
        .RI(ri_i), .TS(ts_i) );
  SSTL18DDR2_15 DQ_6__sstl_dq ( .PAD(dq_pad[6]), .Z(dq_o[6]), .A(dq_i[6]), 
        .RI(ri_i), .TS(ts_i) );
  SSTL18DDR2_14 DQ_7__sstl_dq ( .PAD(dq_pad[7]), .Z(dq_o[7]), .A(dq_i[7]), 
        .RI(ri_i), .TS(ts_i) );
  SSTL18DDR2_13 DQ_8__sstl_dq ( .PAD(dq_pad[8]), .Z(dq_o[8]), .A(dq_i[8]), 
        .RI(ri_i), .TS(ts_i) );
  SSTL18DDR2_12 DQ_9__sstl_dq ( .PAD(dq_pad[9]), .Z(dq_o[9]), .A(dq_i[9]), 
        .RI(ri_i), .TS(ts_i) );
  SSTL18DDR2_11 DQ_10__sstl_dq ( .PAD(dq_pad[10]), .Z(dq_o[10]), .A(dq_i[10]), 
        .RI(ri_i), .TS(ts_i) );
  SSTL18DDR2_10 DQ_11__sstl_dq ( .PAD(dq_pad[11]), .Z(dq_o[11]), .A(dq_i[11]), 
        .RI(ri_i), .TS(ts_i) );
  SSTL18DDR2_9 DQ_12__sstl_dq ( .PAD(dq_pad[12]), .Z(dq_o[12]), .A(dq_i[12]), 
        .RI(ri_i), .TS(ts_i) );
  SSTL18DDR2_8 DQ_13__sstl_dq ( .PAD(dq_pad[13]), .Z(dq_o[13]), .A(dq_i[13]), 
        .RI(ri_i), .TS(ts_i) );
  SSTL18DDR2_7 DQ_14__sstl_dq ( .PAD(dq_pad[14]), .Z(dq_o[14]), .A(dq_i[14]), 
        .RI(ri_i), .TS(ts_i) );
  SSTL18DDR2_6 DQ_15__sstl_dq ( .PAD(dq_pad[15]), .Z(dq_o[15]), .A(dq_i[15]), 
        .RI(ri_i), .TS(ts_i) );
  SSTL18DDR2_5 DQS_0__sstl_dqs ( .PAD(dqs_pad[0]), .Z(dqs_o[0]), .A(dqs_i[0]), 
        .RI(ri_i), .TS(ts_i) );
  SSTL18DDR2_4 DQS_1__sstl_dqs ( .PAD(dqs_pad[1]), .Z(dqs_o[1]), .A(dqs_i[1]), 
        .RI(ri_i), .TS(ts_i) );
  SSTL18DDR2_3 DQSBAR_0__sstl_dqsbar ( .PAD(dqsbar_pad[0]), .Z(dqsbar_o[0]), 
        .A(dqsbar_i[0]), .RI(ri_i), .TS(ts_i) );
  SSTL18DDR2_2 DQSBAR_1__sstl_dqsbar ( .PAD(dqsbar_pad[1]), .Z(dqsbar_o[1]), 
        .A(dqsbar_i[1]), .RI(ri_i), .TS(ts_i) );
  SSTL18DDR2_1 DM_0__sstl_dm ( .PAD(dm_pad[0]), .Z(), .A(dm_i[0]), .RI(1'b0), 
        .TS(1'b1) );
  SSTL18DDR2_0 DM_1__sstl_dm ( .PAD(dm_pad[1]), .Z(), .A(dm_i[1]), .RI(1'b0), 
        .TS(1'b1) );
endmodule


module ddr2_controller ( dout, raddr, fillcount, notfull, ready, ck_pad, 
        ckbar_pad, cke_pad, csbar_pad, rasbar_pad, casbar_pad, webar_pad, 
        ba_pad, a_pad, dm_pad, odt_pad, notempty, dq_pad, dqs_pad, dqsbar_pad, 
        clk, reset, read, cmd, din, addr, initddr );
  output [15:0] dout;
  output [24:0] raddr;
  output [5:0] fillcount;
  output [1:0] ba_pad;
  output [12:0] a_pad;
  output [1:0] dm_pad;
  inout [15:0] dq_pad;
  inout [1:0] dqs_pad;
  inout [1:0] dqsbar_pad;
  input [2:0] cmd;
  input [15:0] din;
  input [24:0] addr;
  input clk, reset, read, initddr;
  output notfull, ready, ck_pad, ckbar_pad, cke_pad, csbar_pad, rasbar_pad,
         casbar_pad, webar_pad, odt_pad, notempty;
  wire   ck_i, n7, init_csbar, init_rasbar, init_casbar, init_webar, init_cke,
         csbar_i, rasbar_i, casbar_i, webar_i, n2, n4, SYNOPSYS_UNCONNECTED_1,
         SYNOPSYS_UNCONNECTED_2, SYNOPSYS_UNCONNECTED_3,
         SYNOPSYS_UNCONNECTED_4, SYNOPSYS_UNCONNECTED_5,
         SYNOPSYS_UNCONNECTED_6, SYNOPSYS_UNCONNECTED_7,
         SYNOPSYS_UNCONNECTED_8, SYNOPSYS_UNCONNECTED_9,
         SYNOPSYS_UNCONNECTED_10, SYNOPSYS_UNCONNECTED_11,
         SYNOPSYS_UNCONNECTED_12, SYNOPSYS_UNCONNECTED_13,
         SYNOPSYS_UNCONNECTED_14, SYNOPSYS_UNCONNECTED_15,
         SYNOPSYS_UNCONNECTED_16, SYNOPSYS_UNCONNECTED_17,
         SYNOPSYS_UNCONNECTED_18, SYNOPSYS_UNCONNECTED_19,
         SYNOPSYS_UNCONNECTED_20, SYNOPSYS_UNCONNECTED_21,
         SYNOPSYS_UNCONNECTED_22, SYNOPSYS_UNCONNECTED_23,
         SYNOPSYS_UNCONNECTED_24, SYNOPSYS_UNCONNECTED_25,
         SYNOPSYS_UNCONNECTED_26, SYNOPSYS_UNCONNECTED_27,
         SYNOPSYS_UNCONNECTED_28, SYNOPSYS_UNCONNECTED_29,
         SYNOPSYS_UNCONNECTED_30, SYNOPSYS_UNCONNECTED_31,
         SYNOPSYS_UNCONNECTED_32, SYNOPSYS_UNCONNECTED_33,
         SYNOPSYS_UNCONNECTED_34, SYNOPSYS_UNCONNECTED_35,
         SYNOPSYS_UNCONNECTED_36, SYNOPSYS_UNCONNECTED_37,
         SYNOPSYS_UNCONNECTED_38, SYNOPSYS_UNCONNECTED_39,
         SYNOPSYS_UNCONNECTED_40, SYNOPSYS_UNCONNECTED_41,
         SYNOPSYS_UNCONNECTED_42, SYNOPSYS_UNCONNECTED_43,
         SYNOPSYS_UNCONNECTED_44, SYNOPSYS_UNCONNECTED_45,
         SYNOPSYS_UNCONNECTED_46, SYNOPSYS_UNCONNECTED_47,
         SYNOPSYS_UNCONNECTED_48, SYNOPSYS_UNCONNECTED_49,
         SYNOPSYS_UNCONNECTED_50, SYNOPSYS_UNCONNECTED_51,
         SYNOPSYS_UNCONNECTED_52, SYNOPSYS_UNCONNECTED_53,
         SYNOPSYS_UNCONNECTED_54, SYNOPSYS_UNCONNECTED_55,
         SYNOPSYS_UNCONNECTED_56, SYNOPSYS_UNCONNECTED_57,
         SYNOPSYS_UNCONNECTED_58, SYNOPSYS_UNCONNECTED_59,
         SYNOPSYS_UNCONNECTED_60, SYNOPSYS_UNCONNECTED_61,
         SYNOPSYS_UNCONNECTED_62, SYNOPSYS_UNCONNECTED_63,
         SYNOPSYS_UNCONNECTED_64, SYNOPSYS_UNCONNECTED_65,
         SYNOPSYS_UNCONNECTED_66, SYNOPSYS_UNCONNECTED_67,
         SYNOPSYS_UNCONNECTED_68, SYNOPSYS_UNCONNECTED_69,
         SYNOPSYS_UNCONNECTED_70, SYNOPSYS_UNCONNECTED_71,
         SYNOPSYS_UNCONNECTED_72, SYNOPSYS_UNCONNECTED_73,
         SYNOPSYS_UNCONNECTED_74, SYNOPSYS_UNCONNECTED_75,
         SYNOPSYS_UNCONNECTED_76, SYNOPSYS_UNCONNECTED_77,
         SYNOPSYS_UNCONNECTED_78, SYNOPSYS_UNCONNECTED_79,
         SYNOPSYS_UNCONNECTED_80, SYNOPSYS_UNCONNECTED_81,
         SYNOPSYS_UNCONNECTED_82, SYNOPSYS_UNCONNECTED_83,
         SYNOPSYS_UNCONNECTED_84, SYNOPSYS_UNCONNECTED_85,
         SYNOPSYS_UNCONNECTED_86, SYNOPSYS_UNCONNECTED_87,
         SYNOPSYS_UNCONNECTED_88, SYNOPSYS_UNCONNECTED_89,
         SYNOPSYS_UNCONNECTED_90, SYNOPSYS_UNCONNECTED_91,
         SYNOPSYS_UNCONNECTED_92, SYNOPSYS_UNCONNECTED_93,
         SYNOPSYS_UNCONNECTED_94, SYNOPSYS_UNCONNECTED_95,
         SYNOPSYS_UNCONNECTED_96, SYNOPSYS_UNCONNECTED_97,
         SYNOPSYS_UNCONNECTED_98, SYNOPSYS_UNCONNECTED_99,
         SYNOPSYS_UNCONNECTED_100, SYNOPSYS_UNCONNECTED_101,
         SYNOPSYS_UNCONNECTED_102, SYNOPSYS_UNCONNECTED_103,
         SYNOPSYS_UNCONNECTED_104, SYNOPSYS_UNCONNECTED_105,
         SYNOPSYS_UNCONNECTED_106, SYNOPSYS_UNCONNECTED_107,
         SYNOPSYS_UNCONNECTED_108, SYNOPSYS_UNCONNECTED_109,
         SYNOPSYS_UNCONNECTED_110, SYNOPSYS_UNCONNECTED_111,
         SYNOPSYS_UNCONNECTED_112, SYNOPSYS_UNCONNECTED_113,
         SYNOPSYS_UNCONNECTED_114, SYNOPSYS_UNCONNECTED_115,
         SYNOPSYS_UNCONNECTED_116, SYNOPSYS_UNCONNECTED_117,
         SYNOPSYS_UNCONNECTED_118, SYNOPSYS_UNCONNECTED_119,
         SYNOPSYS_UNCONNECTED_120, SYNOPSYS_UNCONNECTED_121,
         SYNOPSYS_UNCONNECTED_122, SYNOPSYS_UNCONNECTED_123,
         SYNOPSYS_UNCONNECTED_124, SYNOPSYS_UNCONNECTED_125,
         SYNOPSYS_UNCONNECTED_126, SYNOPSYS_UNCONNECTED_127,
         SYNOPSYS_UNCONNECTED_128, SYNOPSYS_UNCONNECTED_129,
         SYNOPSYS_UNCONNECTED_130, SYNOPSYS_UNCONNECTED_131,
         SYNOPSYS_UNCONNECTED_132, SYNOPSYS_UNCONNECTED_133,
         SYNOPSYS_UNCONNECTED_134, SYNOPSYS_UNCONNECTED_135,
         SYNOPSYS_UNCONNECTED_136, SYNOPSYS_UNCONNECTED_137,
         SYNOPSYS_UNCONNECTED_138, SYNOPSYS_UNCONNECTED_139,
         SYNOPSYS_UNCONNECTED_140, SYNOPSYS_UNCONNECTED_141,
         SYNOPSYS_UNCONNECTED_142, SYNOPSYS_UNCONNECTED_143,
         SYNOPSYS_UNCONNECTED_144, SYNOPSYS_UNCONNECTED_145,
         SYNOPSYS_UNCONNECTED_146, SYNOPSYS_UNCONNECTED_147,
         SYNOPSYS_UNCONNECTED_148, SYNOPSYS_UNCONNECTED_149,
         SYNOPSYS_UNCONNECTED_150, SYNOPSYS_UNCONNECTED_151,
         SYNOPSYS_UNCONNECTED_152, SYNOPSYS_UNCONNECTED_153,
         SYNOPSYS_UNCONNECTED_154, SYNOPSYS_UNCONNECTED_155,
         SYNOPSYS_UNCONNECTED_156, SYNOPSYS_UNCONNECTED_157,
         SYNOPSYS_UNCONNECTED_158, SYNOPSYS_UNCONNECTED_159,
         SYNOPSYS_UNCONNECTED_160, SYNOPSYS_UNCONNECTED_161,
         SYNOPSYS_UNCONNECTED_162, SYNOPSYS_UNCONNECTED_163,
         SYNOPSYS_UNCONNECTED_164, SYNOPSYS_UNCONNECTED_165,
         SYNOPSYS_UNCONNECTED_166, SYNOPSYS_UNCONNECTED_167,
         SYNOPSYS_UNCONNECTED_168, SYNOPSYS_UNCONNECTED_169,
         SYNOPSYS_UNCONNECTED_170, SYNOPSYS_UNCONNECTED_171;
  wire   [1:0] init_ba;
  wire   [10:0] init_a;
  wire   [10:0] a_i;
  wire   [1:0] ba_i;
  wire   [15:0] dq_i;
  wire   [1:0] dqs_i;
  wire   [1:0] dqsbar_i;
  wire   [1:0] dm_i;

  DFFPOSX1 ck_i_reg ( .D(n2), .CLK(clk), .Q(ck_i) );
  FIFO FIFO_IN ( .clk(clk), .reset(reset), .data_in(din), .put(), .get(), 
        .data_out(dout), .empty_bar(notempty), .full_bar(notfull), .fillcount(
        fillcount) );
  FIFO FIFO_CMD ( .clk(clk), .reset(reset), .data_in({SYNOPSYS_UNCONNECTED_1, 
        SYNOPSYS_UNCONNECTED_2, SYNOPSYS_UNCONNECTED_3, SYNOPSYS_UNCONNECTED_4, 
        SYNOPSYS_UNCONNECTED_5, SYNOPSYS_UNCONNECTED_6, SYNOPSYS_UNCONNECTED_7, 
        SYNOPSYS_UNCONNECTED_8, SYNOPSYS_UNCONNECTED_9, 
        SYNOPSYS_UNCONNECTED_10, SYNOPSYS_UNCONNECTED_11, 
        SYNOPSYS_UNCONNECTED_12, SYNOPSYS_UNCONNECTED_13, 
        SYNOPSYS_UNCONNECTED_14, SYNOPSYS_UNCONNECTED_15, 
        SYNOPSYS_UNCONNECTED_16, SYNOPSYS_UNCONNECTED_17, 
        SYNOPSYS_UNCONNECTED_18, SYNOPSYS_UNCONNECTED_19, 
        SYNOPSYS_UNCONNECTED_20, SYNOPSYS_UNCONNECTED_21, 
        SYNOPSYS_UNCONNECTED_22, SYNOPSYS_UNCONNECTED_23, 
        SYNOPSYS_UNCONNECTED_24, SYNOPSYS_UNCONNECTED_25, 
        SYNOPSYS_UNCONNECTED_26, SYNOPSYS_UNCONNECTED_27, 
        SYNOPSYS_UNCONNECTED_28, SYNOPSYS_UNCONNECTED_29, 
        SYNOPSYS_UNCONNECTED_30, SYNOPSYS_UNCONNECTED_31, 
        SYNOPSYS_UNCONNECTED_32, SYNOPSYS_UNCONNECTED_33}), .put(), .get(), 
        .data_out({SYNOPSYS_UNCONNECTED_34, SYNOPSYS_UNCONNECTED_35, 
        SYNOPSYS_UNCONNECTED_36, SYNOPSYS_UNCONNECTED_37, 
        SYNOPSYS_UNCONNECTED_38, SYNOPSYS_UNCONNECTED_39, 
        SYNOPSYS_UNCONNECTED_40, SYNOPSYS_UNCONNECTED_41, 
        SYNOPSYS_UNCONNECTED_42, SYNOPSYS_UNCONNECTED_43, 
        SYNOPSYS_UNCONNECTED_44, SYNOPSYS_UNCONNECTED_45, 
        SYNOPSYS_UNCONNECTED_46, SYNOPSYS_UNCONNECTED_47, 
        SYNOPSYS_UNCONNECTED_48, SYNOPSYS_UNCONNECTED_49, 
        SYNOPSYS_UNCONNECTED_50, SYNOPSYS_UNCONNECTED_51, 
        SYNOPSYS_UNCONNECTED_52, SYNOPSYS_UNCONNECTED_53, 
        SYNOPSYS_UNCONNECTED_54, SYNOPSYS_UNCONNECTED_55, 
        SYNOPSYS_UNCONNECTED_56, SYNOPSYS_UNCONNECTED_57, 
        SYNOPSYS_UNCONNECTED_58, SYNOPSYS_UNCONNECTED_59, 
        SYNOPSYS_UNCONNECTED_60, SYNOPSYS_UNCONNECTED_61, 
        SYNOPSYS_UNCONNECTED_62, SYNOPSYS_UNCONNECTED_63, 
        SYNOPSYS_UNCONNECTED_64, SYNOPSYS_UNCONNECTED_65, 
        SYNOPSYS_UNCONNECTED_66}), .empty_bar(), .full_bar(), .fillcount(
        fillcount) );
  FIFO FIFO_RETURN ( .clk(clk), .reset(reset), .data_in({
        SYNOPSYS_UNCONNECTED_67, SYNOPSYS_UNCONNECTED_68, 
        SYNOPSYS_UNCONNECTED_69, SYNOPSYS_UNCONNECTED_70, 
        SYNOPSYS_UNCONNECTED_71, SYNOPSYS_UNCONNECTED_72, 
        SYNOPSYS_UNCONNECTED_73, SYNOPSYS_UNCONNECTED_74, 
        SYNOPSYS_UNCONNECTED_75, SYNOPSYS_UNCONNECTED_76, 
        SYNOPSYS_UNCONNECTED_77, SYNOPSYS_UNCONNECTED_78, 
        SYNOPSYS_UNCONNECTED_79, SYNOPSYS_UNCONNECTED_80, 
        SYNOPSYS_UNCONNECTED_81, SYNOPSYS_UNCONNECTED_82, 
        SYNOPSYS_UNCONNECTED_83, SYNOPSYS_UNCONNECTED_84, 
        SYNOPSYS_UNCONNECTED_85, SYNOPSYS_UNCONNECTED_86, 
        SYNOPSYS_UNCONNECTED_87, SYNOPSYS_UNCONNECTED_88, 
        SYNOPSYS_UNCONNECTED_89, SYNOPSYS_UNCONNECTED_90, 
        SYNOPSYS_UNCONNECTED_91, SYNOPSYS_UNCONNECTED_92, 
        SYNOPSYS_UNCONNECTED_93, SYNOPSYS_UNCONNECTED_94, 
        SYNOPSYS_UNCONNECTED_95, SYNOPSYS_UNCONNECTED_96, 
        SYNOPSYS_UNCONNECTED_97, SYNOPSYS_UNCONNECTED_98, 
        SYNOPSYS_UNCONNECTED_99, SYNOPSYS_UNCONNECTED_100, 
        SYNOPSYS_UNCONNECTED_101, SYNOPSYS_UNCONNECTED_102, 
        SYNOPSYS_UNCONNECTED_103, SYNOPSYS_UNCONNECTED_104, 
        SYNOPSYS_UNCONNECTED_105, SYNOPSYS_UNCONNECTED_106, 
        SYNOPSYS_UNCONNECTED_107}), .put(), .get(), .data_out({
        SYNOPSYS_UNCONNECTED_108, SYNOPSYS_UNCONNECTED_109, 
        SYNOPSYS_UNCONNECTED_110, SYNOPSYS_UNCONNECTED_111, 
        SYNOPSYS_UNCONNECTED_112, SYNOPSYS_UNCONNECTED_113, 
        SYNOPSYS_UNCONNECTED_114, SYNOPSYS_UNCONNECTED_115, 
        SYNOPSYS_UNCONNECTED_116, SYNOPSYS_UNCONNECTED_117, 
        SYNOPSYS_UNCONNECTED_118, SYNOPSYS_UNCONNECTED_119, 
        SYNOPSYS_UNCONNECTED_120, SYNOPSYS_UNCONNECTED_121, 
        SYNOPSYS_UNCONNECTED_122, SYNOPSYS_UNCONNECTED_123, 
        SYNOPSYS_UNCONNECTED_124, SYNOPSYS_UNCONNECTED_125, 
        SYNOPSYS_UNCONNECTED_126, SYNOPSYS_UNCONNECTED_127, 
        SYNOPSYS_UNCONNECTED_128, SYNOPSYS_UNCONNECTED_129, 
        SYNOPSYS_UNCONNECTED_130, SYNOPSYS_UNCONNECTED_131, 
        SYNOPSYS_UNCONNECTED_132, SYNOPSYS_UNCONNECTED_133, 
        SYNOPSYS_UNCONNECTED_134, SYNOPSYS_UNCONNECTED_135, 
        SYNOPSYS_UNCONNECTED_136, SYNOPSYS_UNCONNECTED_137, 
        SYNOPSYS_UNCONNECTED_138, SYNOPSYS_UNCONNECTED_139, 
        SYNOPSYS_UNCONNECTED_140, SYNOPSYS_UNCONNECTED_141, 
        SYNOPSYS_UNCONNECTED_142, SYNOPSYS_UNCONNECTED_143, 
        SYNOPSYS_UNCONNECTED_144, SYNOPSYS_UNCONNECTED_145, 
        SYNOPSYS_UNCONNECTED_146, SYNOPSYS_UNCONNECTED_147, 
        SYNOPSYS_UNCONNECTED_148}), .empty_bar(), .full_bar(), .fillcount(
        fillcount) );
  ddr2_init_engine XINIT ( .ready(ready), .csbar(init_csbar), .rasbar(
        init_rasbar), .casbar(init_casbar), .webar(init_webar), .ba(init_ba), 
        .a({SYNOPSYS_UNCONNECTED_149, SYNOPSYS_UNCONNECTED_150, init_a[10:6], 
        SYNOPSYS_UNCONNECTED_151, init_a[4:0]}), .odt(), .ts_con(), .cke(
        init_cke), .clk(clk), .reset(reset), .init(initddr), .ck(1'b0) );
  SSTL18DDR2INTERFACE XSSTL ( .ck_pad(ck_pad), .ckbar_pad(ckbar_pad), 
        .cke_pad(cke_pad), .csbar_pad(csbar_pad), .rasbar_pad(rasbar_pad), 
        .casbar_pad(casbar_pad), .webar_pad(webar_pad), .ba_pad(ba_pad), 
        .a_pad(a_pad), .dm_pad(dm_pad), .odt_pad(odt_pad), .dq_o({
        SYNOPSYS_UNCONNECTED_152, SYNOPSYS_UNCONNECTED_153, 
        SYNOPSYS_UNCONNECTED_154, SYNOPSYS_UNCONNECTED_155, 
        SYNOPSYS_UNCONNECTED_156, SYNOPSYS_UNCONNECTED_157, 
        SYNOPSYS_UNCONNECTED_158, SYNOPSYS_UNCONNECTED_159, 
        SYNOPSYS_UNCONNECTED_160, SYNOPSYS_UNCONNECTED_161, 
        SYNOPSYS_UNCONNECTED_162, SYNOPSYS_UNCONNECTED_163, 
        SYNOPSYS_UNCONNECTED_164, SYNOPSYS_UNCONNECTED_165, 
        SYNOPSYS_UNCONNECTED_166, SYNOPSYS_UNCONNECTED_167}), .dqs_o({
        SYNOPSYS_UNCONNECTED_168, SYNOPSYS_UNCONNECTED_169}), .dqsbar_o({
        SYNOPSYS_UNCONNECTED_170, SYNOPSYS_UNCONNECTED_171}), .dq_pad(dq_pad), 
        .dqs_pad(dqs_pad), .dqsbar_pad(dqsbar_pad), .ri_i(1'b0), .ts_i(1'b0), 
        .ck_i(ck_i), .cke_i(init_cke), .csbar_i(csbar_i), .rasbar_i(rasbar_i), 
        .casbar_i(casbar_i), .webar_i(webar_i), .ba_i(ba_i), .a_i({1'b0, 1'b0, 
        a_i[10:6], 1'b0, a_i[4:0]}), .dq_i({1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 
        1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0}), .dqs_i({
        1'b0, 1'b0}), .dqsbar_i({1'b0, 1'b0}), .dm_i({1'b0, 1'b0}), .odt_i(
        1'b0) );
  OR2X1 U24 ( .A(reset), .B(ck_i), .Y(n7) );
  INVX1 U25 ( .A(n7), .Y(n2) );
  INVX1 U26 ( .A(ready), .Y(n4) );
  AND2X1 U27 ( .A(init_casbar), .B(n4), .Y(casbar_i) );
  AND2X1 U28 ( .A(init_rasbar), .B(n4), .Y(rasbar_i) );
  AND2X1 U29 ( .A(init_csbar), .B(n4), .Y(csbar_i) );
  AND2X1 U30 ( .A(init_webar), .B(n4), .Y(webar_i) );
  AND2X1 U31 ( .A(init_ba[0]), .B(n4), .Y(ba_i[0]) );
  AND2X1 U32 ( .A(init_ba[1]), .B(n4), .Y(ba_i[1]) );
  AND2X1 U33 ( .A(init_a[0]), .B(n4), .Y(a_i[0]) );
  AND2X1 U34 ( .A(init_a[1]), .B(n4), .Y(a_i[1]) );
  AND2X1 U35 ( .A(init_a[2]), .B(n4), .Y(a_i[2]) );
  AND2X1 U36 ( .A(init_a[3]), .B(n4), .Y(a_i[3]) );
  AND2X1 U37 ( .A(init_a[4]), .B(n4), .Y(a_i[4]) );
  AND2X1 U38 ( .A(init_a[6]), .B(n4), .Y(a_i[6]) );
  AND2X1 U39 ( .A(init_a[7]), .B(n4), .Y(a_i[7]) );
  AND2X1 U40 ( .A(init_a[8]), .B(n4), .Y(a_i[8]) );
  AND2X1 U41 ( .A(init_a[9]), .B(n4), .Y(a_i[9]) );
  AND2X1 U42 ( .A(init_a[10]), .B(n4), .Y(a_i[10]) );
endmodule

