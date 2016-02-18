# Verilog compilation
VLOG            = vcom +acc -work work -2002 -explicit
VLOG_SRC        = shifter.vhd n_bits_shifter.vhd tb_shifter.vhd 
VLOG_DAT        = $(patsubst %.vhd,work/%/_primary.dat,$(VLOG_SRC))
CC              = -t 1ps -voptargs=+acc
TEST_MAIN_MODULE     = tb_shifter
TEST_SUB_MODULE      = test
vpath %.vhd $(pwd)../src


.PHONY: all clean vlogcompile

all:  vlogcompile

guisim:
	vsim $(CC) work.$(TEST_MAIN_MODULE)
sim:
	vsim $(CC) -c work.$(TEST_MAIN_MODULE)

work:
	vlib work

$(WRAP_DIR):
	mkdir $@

vlogcompile: $(VLOG_DAT)

work/%/_primary.dat:%.vhd | work
	$(VLOG) $<

clean: 	
	rm -rf work
	@rm -rf *~
	@rm -rf *#
	@rm -f  transcript vsim.wlf


