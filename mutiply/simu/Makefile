# Verilog compilation
VLOG            = vlog +acc
VLOG_SRC        = fifo_module.v tb_multiplier.v multiplier.v modified_booth_multiplier_module_2.v
VLOG_DAT        = $(patsubst %.v,work/%/_primary.dat,$(VLOG_SRC))

vpath %.v $(pwd)../src


.PHONY: all clean vlogcompile

all:  vlogcompile

guisim:
	vsim -t 1ps tb_multiplier
sim:
	vsim -t 1ps -c  tb_multiplier

work:
	vlib work

$(WRAP_DIR):
	mkdir $@

vlogcompile: $(VLOG_DAT)

work/%/_primary.dat:%.v | work
	$(VLOG) $<

clean: 	
	rm -rf work
	@rm -rf *~
	@rm -rf *#
	@rm -f  transcript vsim.wlf


