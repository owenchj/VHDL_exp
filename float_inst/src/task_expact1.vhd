library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity task_expact1 is
  port (
    a_in           : in  std_logic_vector(56 downto 0);
    b_in           : in  std_logic_vector(56 downto 0);
    exp_out        : out std_logic_vector(9 downto 0);
    expdiff_out    : out std_logic_vector(9 downto 0)
    );
end entity;



architecture behavior of task_expact1 is
  signal exp   :  std_logic_vector(9 downto 0);
begin
  exp         <= '0' & std_logic_vector(unsigned('0' & a_in(55 downto 48)) - unsigned('0' & b_in(55 downto 48))); 
  exp_out     <= exp;
  expdiff_out <= ('0' & not exp(8 downto 0) + "1" )when exp(8) = '1' else exp;
--process(exp)
--begin
--  if exp(8) = '1' then
--  expdiff_out <= not exp + "1";
--  else
--  expdiff_out <= exp;
--  end if; 
--end process;
end architecture;
