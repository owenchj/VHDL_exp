library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
entity task_expact2 is
  port (
    a_in           : in  std_logic_vector(56 downto 0);
    b_in           : in  std_logic_vector(56 downto 0);
    exp_in         : in  std_logic_vector(9 downto 0);
    expdiff_in     : in  std_logic_vector(9 downto 0);
    a_out          : out std_logic_vector(56 downto 0);
    b_out          : out std_logic_vector(56 downto 0)
    );
end entity;



architecture behavior of task_expact2 is
  signal is1  :  std_logic;
  signal a1   :  std_logic_vector(56 downto 0);
  signal a2   :  std_logic_vector(56 downto 0);
  signal b1   :  std_logic_vector(56 downto 0);
  signal b2   :  std_logic_vector(56 downto 0);
begin
  
  is1 <= '1' when exp_in(8) = '1' else '0';
  
  a1  <= a_in(56) & b_in(55 downto 48) & std_logic_vector(unsigned(a_in(47 downto 0)) srl to_integer(unsigned(expdiff_in)));
  a2  <= a_in;
  b1  <= b_in(56) & a_in(55 downto 48) & std_logic_vector(unsigned(b_in(47 downto 0)) srl to_integer(unsigned(expdiff_in)));
  b2  <= b_in;

  a_out <= a1 when is1 = '1' else a2;
  b_out <= b1 when is1 = '0' else b2;
  
--process(exp)
--begin
--  if exp(8) = '1' then
--  expdiff_out <= not exp + "1";
--  else
--  expdiff_out <= exp;
--  end if; 
--end process;
end architecture;
