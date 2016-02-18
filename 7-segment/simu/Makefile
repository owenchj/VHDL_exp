# Verilog compilation
VLOG            = vcom +acc -work work -2002 -explicit
VLOG_SRC        = mux_date_time.vhd  display.vhd assign_seg.vhd year_month_day.vhd hour_minute_second.vhd \
			no_jiter.vhd adjust_date_time.vhd\
			create_year.vhd create_month.vhd create_day.vhd create_hour.vhd create_minute.vhd create_second.vhd  top_segment.vhd \
			tb_top_segment.vhd
			#tb_mux_date_time.vhd  tb_hour_minute_second.vhd tb_year_month_day.vhd\
			
VLOG_DAT        = $(patsubst %.vhd,work/%/_primary.dat,$(VLOG_SRC))
CC              = -t 1ps -voptargs=+acc
TEST_MAIN_MODULE     = tb_top_segment
TEST_SUB_MODULE      = test
vpath %.vhd $(pwd)../src1


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


