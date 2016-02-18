library ieee;
use ieee.std_logic_1164.all;

entity tb_dff is
  
  generic (
    half_periods  : time := 1NS
    );
end tb_dff;


architecture behavior  of tb_dff is
  signal clk : std_logic := '0';
  signal d : std_logic := '0';
  signal rst : std_logic := '0';        
  signal q : std_logic;

begin  -- behavior 
  dff:entity work.dff(rtl) 
    port map (d, clk, rst, q);
  
  clock:   process 
  begin
    clk <=not clk;
    wait for half_periods;
    assert NOW<=200 ns report "End of test" severity error;
  end process ;

  value:   process 
  begin
    rst <= '1';    
    wait for 10 ns;
    
    d   <=  '1';
    wait for 5 ns;
    d   <=  '0';
    wait for 6 ns;
    d   <=  '1';
    rst <= '0';    
    wait for 100 ns;
    d   <=  '0';
    wait for 30 ns;
    d   <=  '1';
    wait;
    assert NOW<=200 ns report "End of test" severity error;
  end process ;


end architecture;
