# Verilog compilation
VLOG            = vcom +acc -work work -2002 -explicit
VLOG_SRC        = counter.vhd tb_counter.vhd
VLOG_DAT        = $(patsubst %.vhd,work/%/_primary.dat,$(VLOG_SRC))

vpath %.vhd $(pwd)../src


.PHONY: all clean vlogcompile

all:  vlogcompile

guisim:
	vsim -t 1ps work.test_counter
sim:
	vsim -t 1ps -c work.test_counter

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


