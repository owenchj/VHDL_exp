library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity task_resultmodify is
  port (
    a_exp_in       : in  std_logic_vector(7 downto 0);
    tempa_in       : in  std_logic_vector(48 downto 0);
    tempb_in       : in  std_logic_vector(48 downto 0);
    issign_out     : out std_logic;
    exp_out        : out std_logic_vector(9 downto 0);
    temp_out       : out std_logic_vector(48 downto 0)
    );
end entity;



architecture behavior of task_resultmodify is

  signal addresult   :  std_logic_vector(48 downto 0);
begin

  addresult <= tempa_in + tempb_in; 
  
  issign_out <= addresult(48);
  temp_out   <= not addresult + "1" when addresult(48) = '1' else addresult;
  exp_out    <= "00" & a_exp_in; 
--process(exp)
--begin
--  if exp(8) = '1' then
--  expdiff_out <= not exp + "1";
--  else
--  expdiff_out <= exp;
--  end if; 
--end process;
end architecture;

