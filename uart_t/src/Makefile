# VHDL compilation
VCOM            = vcom +acc -work work -2002 -explicit
VLOG_SRC        = .vhd
VLOG_DAT        = $(patsubst %.vhd,work/%/_primary.dat,$(VLOG_SRC))
TB_MODULE       = ..

vpath %.vhd $(pwd)../src


.PHONY: all clean vlogcompile

all:  vlogcompile

guisim:
	vsim -t 1ps work.$(TB_MODULE)
sim:
	vsim -t 1ps -c work.$(TB_MODULE)

work:
	vlib work

$(WRAP_DIR):
	mkdir $@

vlogcompile: $(VLOG_DAT)

work/%/_primary.dat:%.vhd | work
	$(VCOM) $<

clean: 	
	rm -rf work
	@rm -rf .*~
	@rm -rf .*#
	@rm -rf *~
	@rm -rf *#
	@rm -f  transcript vsim.wlf


