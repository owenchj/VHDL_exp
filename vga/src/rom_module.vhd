library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity rom_module is
  port (
    clk      : in std_logic;
    rom_addr : in std_logic_vector(10 downto 0);
    rom_data : out std_logic_vector(7 downto 0)
    );  
end entity;


architecture behavior of rom_module is
  signal rdata : std_logic_vector(7 downto 0);

begin

  rom_data <= rdata;
  
  process(clk)
  begin
    if rising_edge(clk) then
      rdata <= rom_addr(7 downto 0);
      end if;
  end process;


end architecture;

