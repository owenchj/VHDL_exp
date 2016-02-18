library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity tx_module is 

  generic (
    -- 50 Mhz
    b115k : integer := 434 - 1 
    );


  port (
    clk        : in std_logic ;
    rstn       : in std_logic ;
    tx_en_sig  : in std_logic ;
    tx_done_sig: out std_logic ;
    tx_data    : in std_logic_vector(7 downto 0);
    tx_pin_out : out std_logic 
    );
end entity;

architecture behavior of tx_module is
  signal i          :  std_logic_vector(3 downto 0);
  signal counter    :  std_logic_vector(8 downto 0);
  signal rdata      :  std_logic_vector(10 downto 0);
  signal rpin       :  std_logic;
  signal isdone     :  std_logic;

begin

  tx_pin_out <= rpin;
  tx_done_sig <= isdone;
  
  process(clk)
  begin
    if rising_edge(clk) then
      if rstn = '0' then
        i <= x"0";
        counter <=(others => '0');
        rdata <= (others => '0');
        rpin <= '0';
        isdone <= '0';
      elsif tx_en_sig = '1' then
        case i is
          when x"0" =>
            rdata <= "11" & tx_data & '0';
            i <= i+ "1";
          when x"1"|x"2"|x"3"|x"4"|x"5"|x"6"|x"7"|x"8"|x"9"|x"a"|x"b" =>
            if unsigned(counter) = b115k then
              counter <= (others => '0');
              i <= i+ "1";
            else
              rpin <= rdata(to_integer(unsigned(i) - 1));
              counter <= counter + "1";
            end if;
          when x"c" =>
            isdone <= '1';
            i <= i+ "1";
          when x"d" =>
            isdone <= '0';
            i <= x"0";
          when others => null;
        end case;

      end if;
    end if;
  end process;

end architecture;
