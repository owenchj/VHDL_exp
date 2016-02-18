library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity task_resulterror is
  port (
    issign_in      : in  std_logic;
    exp_in         : in  std_logic_vector(9 downto 0);
    temp_in        : in  std_logic_vector(48 downto 0);
    error_out      : out std_logic_vector(2 downto 0);
    result         : out std_logic_vector(31 downto 0)
    );
end entity;



architecture behavior of task_resulterror is
  signal iszero   :  std_logic;
  signal isunder   :  std_logic;
  signal isover   :  std_logic;
  signal isnormalise   :  std_logic;
  signal result1  :  std_logic_vector(31 downto 0);
  signal result2  :  std_logic_vector(31 downto 0);
begin
  iszero  <= '1' when temp_in(46 downto 23) = x"00000" & "000" else '0';
  isunder <= '1' when exp_in(9 downto 8) = "11" else '0';
  isover  <= '1' when exp_in(9 downto 8) = "01" else '0';

  isnormalise <= temp_in(22);

  result1 <= issign_in & exp_in(7 downto 0) & (temp_in(45 downto 23) + "1");
  result2 <= issign_in & exp_in(7 downto 0) & temp_in(45 downto 23);

  error_out <= isover & isunder & iszero;
  result    <= result1 when isnormalise = '1' else result2; 
end architecture;
