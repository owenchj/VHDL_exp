library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity reset_module is
  generic(
    state : boolean := false
    );
  
  port (
    clk     : in std_logic;
    rstn    : in std_logic;
    out_rst : out std_logic
    );  
end entity;


architecture behavior of reset_module is
  signal R : std_logic_vector(1 downto 0);

begin
  out_rst <= not R(1) when state = true else R(1);  
  
  process(clk, rstn)
  begin
    if rising_edge(clk) or falling_edge(rstn) then
      if rstn = '0' then
        R <= "00";
      else
        R(0) <= '1';
        R(1) <= R(0);
      end if;
    end if;
  end process;


end architecture;

