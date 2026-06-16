class apb_test extends uvm_test;

  apb_env env;
  `uvm_component_utils(apb_test)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
    env = apb_env::type_id::create("env", this);

     begin
            apb_agent_config agent_cfg;
            agent_cfg = config_agent_config::type_id::create("agent_cfg");
       uvm_config_db #(config_agent_config)::set(this, "env.apb_agent", "cfg", agent_cfg);
        end
  endfunction: build_phase

  function void end_of_elaboration_phase(uvm_phase phase);
    uvm_top.print_topology();
  endfunction: end_of_elaboration_phase

  task run_phase(uvm_phase phase);
    apb_sequence seq;
    phase.raise_objection(this);
    seq = apb_sequence::type_id::create("seq");
    seq.start(env.agnt.seqr);
    phase.drop_objection(this);
  endtask: run_phase

endclass : apb_test
