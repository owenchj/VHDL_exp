library ieee;
use ieee.std_logic_1164.all;

entity SPI_rx2_top is
  Port ( SCK  : in  STD_LOGIC;    -- SPI input clock
         DATA : in  STD_LOGIC;    -- SPI serial data input
         CS   : in  STD_LOGIC;    -- chip select input (active low)
         LED  : inout STD_LOGIC_VECTOR (7 downto 0));
end SPI_rx2_top;



architecture receiver  of SPI_rx2_top is
  signal data_reg: STD_LOGIC_VECTOR(7 downto 0) :=(others=>'0');
begin  -- receiver 

  process(SCK)
  begin
    if rising_edge(SCK) then
      if CS = '0' then 
        data_reg<=data_reg(6 downto 0) & DATA; 
        

      else
        -- update LEDs with new data on rising edge of CS
        LED <= data_reg;
        data_reg <= x"00";
      end if;
    end if;
  end  process;
  

end receiver ;
