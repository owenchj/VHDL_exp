library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity task_2ndlmp is
  port (
    a_in           : in  std_logic_vector(56 downto 0);
    b_in           : in  std_logic_vector(56 downto 0);
    temp_a         : out std_logic_vector(48 downto 0);
    temp_b         : out std_logic_vector(48 downto 0)
    );
end entity;

architecture behavior of task_2ndlmp is

begin
  temp_a  <=  a_in(56) & (not a_in(47 downto 0) + "1") when a_in(56) = '1' else a_in(56) & a_in(47 downto 0);

  temp_b  <=  b_in(56) & (not b_in(47 downto 0) + "1") when b_in(56) = '1' else b_in(56) & b_in(47 downto 0);

  
--process(exp)
--begin
--  if exp(8) = '1' then
--  expdiff_out <= not exp + "1";
--  else
--  expdiff_out <= exp;
--  end if; 
--end process;
end architecture;

