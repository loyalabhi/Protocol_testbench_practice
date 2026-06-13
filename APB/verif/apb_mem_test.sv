class apb_mem_test extends apb_test;

  `uvm_component_utils(apb_mem_test)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    apb_write_all_seq wr_seq;
    apb_read_all_seq  rd_seq;

    phase.raise_objection(this);

    wr_seq = apb_write_all_seq::type_id::create("wr_seq");
    wr_seq.start(env.agnt.seqr);

    rd_seq = apb_read_all_seq::type_id::create("rd_seq");
    rd_seq.start(env.agnt.seqr);

    phase.drop_objection(this);
  endtask

endclass
