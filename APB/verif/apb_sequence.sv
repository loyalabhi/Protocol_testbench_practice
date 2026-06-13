class apb_sequence extends uvm_sequence #(apb_seq_item);

  `uvm_object_utils(apb_sequence)

  function new(string name = "apb_sequence");
   super.new(name);
  endfunction : new

  task body();
    apb_seq_item trans;
    repeat (5) begin
      trans = apb_seq_item::type_id::create("trans");
      assert (trans.randomize());

      start_item(trans);
      finish_item(trans);
    end
  endtask : body


endclass : apb_sequence
