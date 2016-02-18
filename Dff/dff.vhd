library ieee;
use ieee.std_logic_1164.all;

entity dff is
  port(
    D:  in std_logic;
    CLK:in std_logic;
    RST:in std_logic;
    Q:  out std_logic
    );  
end  entity   dff;

architecture RTL of dff is
begin
  --process(D,CLK,RST) is
  --begin
    
  --  if(RST = '1')then
  --    Q <= '0';
  --  elsif (rising_edge(CLK)) then  
  --    Q <= D;
  --  end if;
  
  process(CLK) is
  begin
    if (rising_edge(CLK)) then  
      if(RST = '1')then
        Q <= '0';
      else
        Q <= D;
    end if;
  end if;
 end process;
end architecture RTL;


