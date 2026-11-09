\m5_TLV_version 1d: tl-x.org
\m5

   // ============================================
   // Welcome, new visitors! Try the "Learn" menu.
   // ============================================

   //use(m5-1.0)   /// uncomment to use M5 macro library.

\SV
   // Macro providing required top-level module definition, random
   // stimulus support, and Verilator config.
   m5_makerchip_module   // (Expanded in Nav-TLV view.)
\TLV
   // CONSTANTS/IO
   $reset = *reset;
   //   input sigs
   $cachereq_val = 1'b1;
   $cachereq_rdy = /fsm$state_i;
   $memresp_val = 1'b1;
   $memresp_rdy = /fsm$state_ew || /fsm$state_rw;
   $cacheresp_val = /fsm$state_w;
   $cacheresp_rdy = 1'b1;
   $memreq_val = /fsm$state_er || /fsm$state_rr;
   $memreq_rdy = 1'b1;
   //    cachereq - test source, data is 4B (one word)
   $cachereq_msg[76:0] = 77'b0; //placeholder
   $cachereq_type[2:0] = $cachereq_msg[76:74];
   $cachereq_opaque[7:0] = $cachereq_msg[73:66];
   $cachereq_addr[31:0] = $cachereq_msg[65:34];
   $cachereq_len[1:0] = $cachereq_msg[33:32];
   $cachereq_data[31:0] = $cachereq_msg[31:0];
   $cachereq_en = /fsm$state_idle;

   //    memresp - test memory, data is 16B (one cache line)
   //$memresp_msg[144:0] = 145'b0; //placeholder
   //$memresp_type[2:0] = $memresp_msg[144:142];
   //$memresp_opaque[7:0] = $memresp_msg[141:134];
   //$memresp_test[1:0] = $memresp_msg[133:132];
   //$memresp_len[3:0] = $memresp_msg[131:128];
   //$memresp_data[127:0] = $memresp_msg[127:0];
   //  output sigs
   //    cacheresp - test sink
   //$cacheresp_msg[46:0] = {$cacheresp_type, $cacheresp_opaque, $cacheresp_test, $cacheresp_len, $cacheresp_data};
   //    memreq - test memory, data is 16B (one cache line)
   //$memreq_msg[174:0] = {$memreq_type, $memreq_opaque, $memreq_addr, $memreq_len, $memreq_data};


   //SV macro region for tag and data array SRAMs

   //CACHE
   //  hold registers
   $cachereq_type_reg[2:0] = $reset ? 3'b0:
                             $cachereq_en ? $cachereq_type:
                             >>1$cachereq_type_reg;
   $cachereq_opaque_reg[7:0] = $reset ? 8'b0:
                             $cachereq_en ? $cachereq_opaque:
                             >>1$cachereq_opaque_reg;
   $cachereq_addr_reg[2:0] = $reset ? 3'b0:
                             $cachereq_en ? $cachereq_addr:
                             >>1$cachereq_addr_reg;
   $cachereq_len_reg[2:0] = $reset ? 3'b0:
                             $cachereq_en ? $cachereq_len:
                             >>1$cachereq_len_reg;
   $cachereq_data_reg[2:0] = $reset ? 3'b0:
                             $cachereq_en ? $cachereq_data:
                             >>1$cachereq_data_reg;
   //  request type flags


   /fsm
      //  FSM state flags
      $state_i = $reset ? 1'b1:
                 >>1$state_w && >>1$cacheresp_rdy:
                 >>1$state_i && >>1!$cachereq_val;
      $state_tc = $reset ? 1'b0:
                  >>1$state_i && >>1$cachereq_val;
                  >>1$state_tc && >>1$is_read_hit; //rd
                  >>1$state_tc && >>1$is_write_hit; //wd
                  >>1$state_tc && >>1$is_miss && $dirty; //ep
                  >>1$state_tc && >>1$is_miss && !$dirty; //rr
      $state_in = $reset ? 1'b0:
                  >>1$state_tc && >>1$is_init ? 1'b1:
                  1'b0;
      $state_rd = $reset ? 1'b0:
                  1'b0;
      $state_wd = $reset ? 1'b0:
                  1'b0;
      $state_ep = $reset ? 1'b0:
                  1'b0;
      $state_er = $reset ? 1'b0:
                  1'b0;
      $state_ew = $reset ? 1'b0:
                  1'b0;
      $state_rr = $reset ? 1'b0:
                  1'b0;
      $state_rw = $reset ? 1'b0:
                  1'b0;
      $state_ru = $reset ? 1'b0:
                  1'b0;
      $state_w = $reset ? 1'b0:
                 >>1$state_w && >>1!$cacheresp_rdy ? 1'b1:
                 >>1$state_in || >>1$state_rd || >>1$state_wd ? 1'b1:
                 1'b0;





   // Assert these to end simulation (before the cycle limit).
   *passed = *cyc_cnt > 40;
   *failed = 1'b0;
\SV
   endmodule
