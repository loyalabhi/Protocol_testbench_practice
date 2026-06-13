class apb_monitor extends uvm_monitor;
  virtual apb_interface.MONITOR vif;
  uvm_analysis_port #(apb_seq_item) ap;

  `uvm_component_utils(apb_monitor)


  covergroup cg with function sample (apb_seq_item trans);

    option.per_instance = 1;

    cp_addr: coverpoint trans.addr {bins aall_addressess[] = {[8'h00 : 8'hFF]};}

    cp_direction: coverpoint trans.write {bins write = {1'b1}; bins read = {1'b0};}

    cp_data: coverpoint trans.write ? trans.wdata : trans.rdata {
      bins zero = {32'h0};
      bins all_ones = {32'hffff_ffff};
      bins alternating_a = {32'haaaa_aaaa};
      bins alternating_5 = {32'h5555_5555};
      bins other = default;
    }

    addr_direction_cross: cross cp_addr, cp_direction;
    data_direction_cross: cross cp_data, cp_direction;

  endgroup : cg

  function new(string name, uvm_component parent);
    super.new(name, parent);
    ap = new("ap", this);
    cg = new();
  endfunction : new

  function void build_phase(uvm_phase phase);
    if (!uvm_config_db#(virtual apb_interface.MONITOR)::get(this, "", "vif", vif))
      `uvm_fatal("MON", "APB inteface is not set");

  endfunction : build_phase

  task run_phase(uvm_phase phase);
    apb_seq_item trans;

    forever begin
      @(vif.mon_cb);

      if (vif.mon_cb.PSEL && vif.mon_cb.PENABLE && vif.mon_cb.PREADY) begin
        trans = apb_seq_item::type_id::create("trans");

        trans.write = vif.mon_cb.PWRITE;
        trans.addr = vif.mon_cb.PADDR;
        trans.wdata = vif.mon_cb.PWDATA;
        trans.rdata = vif.mon_cb.PRDATA;
        `uvm_info("APB_MON", trans.sprint(), UVM_HIGH)

        cg.sample(trans);
        ap.write(trans);
      end
    end
  endtask : run_phase
endclass : apb_monitor
