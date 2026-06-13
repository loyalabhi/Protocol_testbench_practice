interface apb_interface (
    input logic PCLK
);
  logic        PRESETn;
  logic        PENABLE;
  logic        PSEL;
  logic        PWRITE;
  logic [ 7:0] PADDR;
  logic [31:0] PWDATA;
  logic [31:0] PRDATA;
  logic        PREADY;

  clocking drv_cb @(posedge PCLK);
    default input #1step output #1ns;

    output PSEL;
    output PENABLE;
    output PWRITE;
    output PADDR;
    output PWDATA;

    input PRDATA;
    input PREADY;
    input PRESETn;

  endclocking : drv_cb

  clocking mon_cb @(posedge PCLK);
    default input #1step output #1ns;

    input PSEL;
    input PENABLE;
    input PWRITE;
    input PADDR;
    input PWDATA;
    input PRDATA;
    input PREADY;
    input PRESETn;
  endclocking : mon_cb

  modport DRIVER(clocking drv_cb);
  modport MONITOR(clocking mon_cb);

  property p_enable_requires_select;
    @(posedge PCLK) disable iff (!PRESETn) PENABLE |-> PSEL;
  endproperty : p_enable_requires_select

  assert property (p_enable_requires_select)
  else $error("PENABLE should not be asserted without a previous PSEL assertion");

  // property p_write_requires_previous_select;
  //   @(posedge PCLK) disable iff (!PRESETn) PSEL |-> PWRITE == 0;
  // endproperty : p_write_requires_previous_select

  // assert property (p_write_requires_previous_select)
  // else $error("PWRITE should not be asserted without a previous PSEL assertion");

  // property p_ready_requires_previous_enable;
  //   @(posedge PCLK) disable iff (!PRESETn) PENABLE |-> PREADY == 0;
  // endproperty : p_ready_requires_previous_enable

  // assert property (p_ready_requires_previous_enable)
  // else $error("PREADY should not be asserted without a previous PENABLE assertion");

  property p_stable_during_wait;
    @(posedge PCLK) disable iff (!PRESETn) 
  PSEL && PENABLE && !PREADY |=> PSEL && PENABLE && $stable(
        {PADDR, PWRITE, PWDATA}
    );
  endproperty : p_stable_during_wait

  assert property (p_stable_during_wait)
  else $error("Address, Write and Write Data should be stable during an active transfer");

  property p_setup_followed_by_access;
    @(posedge PCLK) disable iff (!PRESETn) PSEL && !PENABLE |=> PSEL && PENABLE;
  endproperty : p_setup_followed_by_access

  assert property (p_setup_followed_by_access)
  else $error("Setup should be followed by access");


  property p_no_unknown_controls;
    @(posedge PCLK) disable iff (!PRESETn) !$isunknown(
        {PSEL, PENABLE, PWRITE, PADDR}
    );
  endproperty : p_no_unknown_controls

  assert property (p_no_unknown_controls)
  else $error("APB signals should not have unknown values");

endinterface : apb_interface
