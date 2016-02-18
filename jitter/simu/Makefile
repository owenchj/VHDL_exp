# Verilog compilation
VLOG            = vlog +acc 
VLOG_SRC        = detect_module.v tb_detect_module.v
VLOG_DAT        = $(patsubst %.v,work/%/_primary.dat,$(VLOG_SRC))
TB_MODULE       = tb_detect_module
vpath %.v $(pwd)../src


.PHONY: all clean vlogcompile

all:  vlogcompile

guisim:
	vsim -t 1ps $(TB_MODULE)
sim:
	vsim -t 1ps -c $(TB_MODULE)

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


