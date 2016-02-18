library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity task_preconfig is
port (
a_in   : in  std_logic_vector(31 downto 0);
b_in   : in  std_logic_vector(31 downto 0);
a_out  : out std_logic_vector(56 downto 0);
b_out  : out std_logic_vector(56 downto 0)
);
end entity;



architecture behavior of task_preconfig is
begin
  a_out <= a_in(31) & a_in(30 downto 23) & "01" & a_in(22 downto 0) & x"00000" & "000";
  b_out <= b_in(31) & b_in(30 downto 23) & "01" & b_in(22 downto 0) & x"00000" & "000";
end architecture;
