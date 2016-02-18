-- vcom -work work -2002 -explicit  <FILE_NAME>
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity rx_bps_module is
  generic(
    FreqS : integer := 50 ; -- Mhz  
    Porte_Rate : integer := 115200 -- bps       
    );
  
  port(CLK : in std_logic;
       RSTn : in std_logic;
       Count_Sig : in std_logic;
       BPS_CLK : out std_logic
       );
end rx_bps_module;


architecture count of rx_bps_module is
  signal reg_count : std_logic_vector(11 downto 0) := x"000";
  constant freq : integer := (FreqS * 1000000 / Porte_Rate - 1) ;
begin
  process(CLK)
  begin
    if rising_edge(CLK) then
      if RSTn = '0' then
        reg_count <= x"000";
      elsif unsigned(reg_count) = freq then
        reg_count <= x"000";         
      elsif Count_Sig = '1' then
        reg_count <=  reg_count + "1";        
      else       
        reg_count <= x"000";
      end if;
    end if;
  end process;

  BPS_CLK <= '1' when unsigned(reg_count) = freq /2  else '0';   
  
end architecture;
