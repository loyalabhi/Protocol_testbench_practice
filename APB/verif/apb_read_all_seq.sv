class apb_read_all_seq extends uvm_sequence #(apb_seq_item);

    `uvm_object_utils(apb_read_all_seq)

    bit [7:0] addr_q[$];

    function new(string name = "read_all_seq");
        super.new(name);
    endfunction

    task body();
        apb_seq_item tr;

        addr_q.delete();

        for(int i = 0; i < 256; i++) begin
           addr_q.push_back(i[7:0]);
        end

        addr_q.shuffle();

        foreach(addr_q[i]) begin
            tr = apb_seq_item::type_id::create("tr");
            start_item(tr);

            tr.write = 0;
            tr.addr = addr_q[i];

            finish_item(tr);

        end
    endtask

    //  `uvm_info("APB_RD",
    //     $sformatf("Read addr=0x%02h data=0x%08h",
    //               tr.addr, tr.rdata),
    //     UVM_MEDIUM);

endclass
