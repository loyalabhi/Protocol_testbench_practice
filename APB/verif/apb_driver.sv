class apb_driver extends uvm_driver #(apb_seq_item);

  virtual apb_interface.DRIVER vif;

  `uvm_component_utils(apb_driver)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
    if (!uvm_config_db#(virtual apb_interface.DRIVER)::get(this, "", "vif", vif))
      `uvm_fatal("DRV", "APB interface is not set");

  endfunction : build_phase

  task reset_signals();
    vif.drv_cb.PSEL <= 0;
    vif.drv_cb.PENABLE <= 0;
    vif.drv_cb.PWRITE <= 0;
    vif.drv_cb.PADDR <= 0;
    vif.drv_cb.PWDATA <= 0;

    wait (vif.drv_cb.PRESETn == 1'b1);
    @(vif.drv_cb);
  endtask : reset_signals

  task drive_transfer(apb_seq_item trans);

    `uvm_info("APB_DRV", trans.sprint(), UVM_HIGH)
    // Setup
    @(vif.drv_cb);
    vif.drv_cb.PSEL <= 1'b1;
    vif.drv_cb.PENABLE <= 1'b0;
    vif.drv_cb.PWRITE <= trans.write;
    vif.drv_cb.PADDR <= trans.addr;
    vif.drv_cb.PWDATA <= trans.wdata;

    // Access phase
    @(vif.drv_cb);
    vif.drv_cb.PSEL <= 1'b1;
    vif.drv_cb.PENABLE <= 1'b1;

    wait (vif.drv_cb.PREADY);

    // End or Idle
    vif.drv_cb.PSEL <= 1'b0;
    vif.drv_cb.PENABLE <= 1'b0;
  endtask : drive_transfer

  task run_phase(uvm_phase phase);
    apb_seq_item trans;

    reset_signals();

    forever begin
      seq_item_port.get_next_item(trans);
      drive_transfer(trans);
      seq_item_port.item_done();

    end
  endtask : run_phase


endclass : apb_driver
