class apb_scoreboard extends uvm_scoreboard;

  uvm_analysis_imp #(apb_seq_item, apb_scoreboard) imp;

  `uvm_component_utils(apb_scoreboard)

  bit [31:0] ref_mem[256];

  function new(string name, uvm_component parent);
    super.new(name, parent);
    imp = new("imp", this);
  endfunction : new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    foreach (ref_mem[i]) ref_mem[i] = 32'h0;
  endfunction : build_phase

  function void write(apb_seq_item trans);

    if (trans.write) begin
      ref_mem[trans.addr] = trans.wdata;

      `uvm_info("SCB", $sformatf("WRITE addr =%02h data = 0x%08h", trans.addr, trans.wdata),
                UVM_HIGH)
    end else begin
      if (trans.rdata !== ref_mem[trans.addr]) begin
        `uvm_error("SCB", $sformatf("READ Mismatch addr=%02h expected=%08h actual=%08h",
                                    trans.addr, ref_mem[trans.addr], trans.rdata))
      end else begin
        `uvm_info("SCB", $sformatf("READ Match addr=%02h data=%08h", trans.addr, trans.rdata),
                  UVM_HIGH)
      end
    end
  endfunction : write

endclass : apb_scoreboard
