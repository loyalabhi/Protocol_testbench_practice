class apb_env extends uvm_env;

  apb_agent agnt;
  apb_scoreboard scb;

  `uvm_component_utils(apb_env)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
    agnt = apb_agent::type_id::create("agnt", this);
    scb  = apb_scoreboard::type_id::create("scb", this);
  endfunction : build_phase

  function void connect_phase(uvm_phase phase);
    agnt.mon.ap.connect(scb.imp);
  endfunction : connect_phase
endclass : apb_env
