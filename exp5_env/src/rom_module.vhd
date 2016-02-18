library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity rom_module is
  port (

    clk      : in std_logic;
    rstn     : in std_logic;
    rom_addr : in std_logic_vector(3 downto 0);
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
      if rstn = '0' then
        rdata <= x"00";
      else
        case rom_addr is
          when x"0" =>
            rdata <= "01111110";
          when x"1" =>
            rdata <= "01000010";
          when x"2" =>
            rdata <= "01000010";
          when x"3" =>
            rdata <= "01000010";
          when x"4" =>
            rdata <= "01000010";
          when x"5" =>
            rdata <= "01000010";
          when x"6" =>
            rdata <= "01000010";
          when x"7" =>
            rdata <= "01000010";
          when x"8" =>
            rdata <= "01000010";
          when x"9" =>
            rdata <= "01000010";
          when x"a" =>
            rdata <= "01000010";
          when x"b" =>
            rdata <= "01000010";
          when x"c" =>
            rdata <= "01000010";
          when x"d" =>
            rdata <= "01000010";
          when x"e" =>
            rdata <= "01000010";
          when x"f" =>
            rdata <= "01111110";
          when others => null;
        end case;
      end if;
    end if;
    
  end process;


end architecture;

