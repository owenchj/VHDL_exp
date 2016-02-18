library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity ram_module1 is
  
  port (
    clk       : in std_logic;
    rstn      : in std_logic;
    wren_sig  : in std_logic;
    wraddr    : in std_logic_vector(10 downto 0);
    wrdata    : in std_logic_vector( 7 downto 0);
    rdaddr    : in std_logic_vector(10 downto 0);
    rddata    : out std_logic_vector(7 downto 0)
    );

end entity;

architecture behavior of ram_module1 is
  type ram_type is array (0 to (2**11)-1) of std_logic_vector(7 downto 0);
  signal ram   : ram_type;
  signal rdata : std_logic_vector(7 downto 0);
begin

  process(clk)
  begin
    if rising_edge(clk) then
      if rstn = '0' then
        rdata <= x"00";
      elsif wren_sig = '1' then
        ram(to_integer(unsigned(wraddr))) <= wrdata;
      else
        rdata <= ram(to_integer(unsigned(rdaddr))); 
      end if;
    end if;
  end process;

    rddata <= rdata;
  
end architecture;
