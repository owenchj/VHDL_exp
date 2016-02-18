# VHDL compilation
VCOM            = vcom +acc -work work -2002 -explicit
VLOG            = vlog +acc
VLOG_SRC        = sdram_init_module.v sdram_func_module.v sdram_control_module.v sdram_module.v sdram_demo.v tb_sdram.v
VHDL_SRC        = 
VHDL_DAT        = $(patsubst %.vhd,work/%/_primary.dat,$(VHDL_SRC))
VLOG_DAT        = $(patsubst %.v,work/%/_primary.dat,$(VLOG_SRC))
TB_MODULE       = tb_sdram

vpath %.vhd $(pwd)../src 
vpath %.v $(pwd)../src 


.PHONY: all clean  vcomcompile vlogcompile

all:  vcomcompile vlogcompile 

guisim:
	vsim -t 1ps -L altera_lnsim work.$(TB_MODULE)
sim:
	vsim -t 1ps  -L altera_lnsim -c work.$(TB_MODULE)

work:
	vlib work

$(WRAP_DIR):
	mkdir $@

vcomcompile: $(VHDL_DAT)
vlogcompile: $(VLOG_DAT)

work/%/_primary.dat:%.vhd | work
	$(VCOM) $<


work/%/_primary.dat:%.v | work
	$(VLOG) $<

clean: 	
	rm -rf work
	@rm -rf .*~
	@rm -rf .*#
	@rm -rf *~
	@rm -rf *#
	@rm -f  transcript vsim.wlf


