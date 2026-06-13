class apb_seq_item extends uvm_sequence_item;

  rand logic write;
  rand logic [7:0] addr;
  rand logic [31:0] wdata;
  logic [31:0] rdata;

  // constraint add_c {addr inside {8'h00, 8'h04, 8'h08, 8'h0c};}

  `uvm_object_utils_begin(apb_seq_item)
  `uvm_field_int(write, UVM_DEFAULT)
  `uvm_field_int(addr, UVM_DEFAULT)
  `uvm_field_int(wdata, UVM_DEFAULT)
  `uvm_field_int(rdata, UVM_DEFAULT)

  `uvm_object_utils_end

  function new(string name = "apb_seq_item");
    super.new(name);
  endfunction : new

endclass : apb_seq_item
