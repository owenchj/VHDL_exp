library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity counter is
  generic(n : natural := 8);
    port(
      rst:in std_logic;
      clk:in std_logic;
      o:out std_logic_vector(n-1 downto 0)
      );
end counter;

architecture basic of counter is
  signal Pre_Q: std_logic_vector(n-1 downto 0);  
  
begin  -- basic

  -- purpose: count
  -- type   : combinational
  -- inputs : clk
  -- outputs: out
  process (clk)
  begin  -- process
    if(rising_edge(clk))then
      if(rst = '1') then
        Pre_Q <= "00000000";
      else
        Pre_Q <= Pre_Q + "1";
      end if;
    end if;
    
  end process;
  o <= Pre_Q;
end basic;


