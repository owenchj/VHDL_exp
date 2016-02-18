library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_textio.all;
use std.textio.all;

entity tb_rx_bps_module is

  generic (
    half_period : time := 10 ns;
    n : integer := 8
    );

end tb_rx_bps_module;
  
  architecture tb of tb_rx_bps_module is
    signal CLK : std_logic := '0';            -- clk
    signal RSTn : std_logic := '0';
    signal Count_Sig : std_logic := '0'; 
    signal BPS_CLK : std_logic ;
  begin

    user : entity work.rx_bps_module(count)
      port map( CLK => CLK, RSTn => RSTn, Count_Sig => Count_Sig, BPS_CLK => BPS_CLK);
    
    process 
    begin  -- process
      CLK<=not CLK;
      wait for half_period;
    end process;

    process
    begin
      wait for 5 ns; RSTn  <= '0';  Count_Sig  <= '0';
      wait for 4 ns; RSTn  <= '1';
      wait for 4 ns; Count_Sig  <= '1';
      wait;
    end process;

    monitor : process (CLK)
      variable c_str : line;
    begin
      if (CLK = '1' and CLK'event) then
        write(c_str, BPS_CLK);
        assert false report time'image(now) & 
          ": Current Count Value : " & c_str.all
          severity note;
        deallocate(c_str);
      end if;
    end process monitor;
    
  end architecture; 
