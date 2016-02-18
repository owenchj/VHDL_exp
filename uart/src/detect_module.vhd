library IEEE;
use ieee.std_logic_1164.all;

entity detect_module is
  Port( CLK : in std_logic;
        RSTn : in std_logic;
        RX_Pin_In : in std_logic;
        H2L_Sig : out std_logic
        );              
end detect_module;


architecture detect of detect_module is
  signal H2L_F1 : std_logic := '1';
  signal H2L_F2 : std_logic := '1';
  
begin
  H2L_Sig <= H2L_F2 and (not H2L_F1);
  

  process(CLK)
  begin
    if rising_edge(CLK) then
  
        if RSTn = '0' then
          H2L_F1 <= '1';
          H2L_F2 <= '1';
        else
          H2L_F1 <= RX_Pin_In;
          H2L_F2 <= H2L_F1;
        end if;
    end if;
  end process;
  
end detect;


