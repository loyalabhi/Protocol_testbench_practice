class apb_agent extends uvm_agent;

  apb_sequencer seqr;
  apb_driver drv;
  apb_monitor mon;

  `uvm_component_utils(apb_agent)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
    seqr = apb_sequencer::type_id::create("seqr", this);
    drv  = apb_driver::type_id::create("drv", this);
    mon  = apb_monitor::type_id::create("mon", this);
  endfunction : build_phase

  function void connect_phase(uvm_phase phase);
    drv.seq_item_port.connect(seqr.seq_item_export);
  endfunction : connect_phase

endclass : apb_agent
