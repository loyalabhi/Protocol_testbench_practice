TOP := tb_top
WORK := work 

RTL_DIR := ../../design
TB_DIR := ../../verif

RTL_FILES := \
	$(RTL_DIR)/apb_slave.sv

TB_FILES := \
	$(TB_DIR)/apb_interface.sv\
	$(TB_DIR)/tb_pkg.sv\
	$(TB_DIR)/tb_top.sv
	

all: compile run

all_mem: compile run_mem

compile: 
	vlib $(WORK)
	vlog -sv -cover bcst +incdir+$(TB_DIR) $(RTL_FILES) $(TB_FILES)

run: 
	vsim -coverage -c work.$(TOP) -do "run -all; coverage report; coverage save apb_cov.ucdb; quit" 
# 	-wlf vsim.wlf -l sim.log \
# 	vsim -view vsim.wlf


run_mem:
	vsim -coverage -c work.$(TOP) \
	 +UVM_TESTNAME=apb_mem_test \
	-wlf vsim.wlf \
	-l apb_mem.log \
	-do "coverage report; run -all; coverage report; coverage save apb_mem_cov.ucdb ; quit -f"

clean:
	rm -rf $(WORK) transcript vsim.wlf
