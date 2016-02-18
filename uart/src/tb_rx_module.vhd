library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_textio.all;
use std.textio.all;


entity tb_rx_module is
  
  generic (
    half_period : time := 1 ns;          -- period
    n: natural := 8
    );
end tb_rx_module;

architecture behavior of tb_rx_module is

  signal  CLK : std_logic := '0';            -- clk
  signal  RSTn : std_logic := '0';
  signal  RX_Pin_In :  std_logic;
  signal  RX_En_Sig :  std_logic;
  signal  RX_Done_Sig :  std_logic;
  signal  RX_Data :  std_logic_vector(7 downto 0);
begin
  
  user: 
    entity work.rx_module(behavior) 
      port map (RSTn => RSTn, CLK => CLK, RX_Pin_In => RX_Pin_In, RX_En_Sig => RX_En_Sig, RX_Done_Sig => RX_Done_Sig, RX_Data => RX_Data); 
  
  process 
  begin  -- process
    CLK<=not CLK;
    wait for half_period;
  end process;
  
  process
  begin
    wait for 5 ns; RSTn  <= '0'; RX_Pin_In  <= '0'; RX_En_Sig <= '0';        
    wait for 4 ns; RSTn  <= '1'; RX_En_Sig <= '1';     
    wait for 20 ns; RX_Pin_In  <= '1';
   
    wait;
  end process;

  monitor : process (CLK)
    variable c_str : line;
  begin
    if (CLK = '1' and CLK'event) then
      write(c_str, RX_Data);
      assert false report time'image(now) & 
        ": Current Count Value : " & c_str.all
        severity note;
      deallocate(c_str);
    end if;
  end process monitor;
  
end behavior;
