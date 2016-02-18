library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity tb_spi is
  
  generic (
    half_period : time := 1 ns;
    n_bit : natural := 8
    );

end tb_spi;


architecture test of tb_spi is
  signal SCK : std_logic := '0';
  signal CS : std_logic := '1';
  signal DATA : std_logic := '0';
  signal LED : std_logic_vector(7 downto 0) ; 
  signal  data_in : std_logic_vector(n_bit-1 downto 0) := (others=>'0') ;
  signal count : std_logic_vector(3 downto 0) := x"1" ;
begin  -- test

  clk: process
  begin
    SCK <= not SCK;
    wait for half_period ;
  end process;

  -- generate serial data
  process(SCK)
  begin
    if SCK'event and SCK = '0' then
      if CS='0' then
        DATA <= data_in(n_bit - conv_integer(count));     
      end if;
    end if;
  end process;
  
  process(SCK)
    -- generate signal chip select
  begin
    if SCK'event and SCK = '1' then
      if CS='0' then
        count <= count + "1";     
      end if;

      if count(3)='1' then
        CS <= '1';
        count <=x"1" ;
        data_in <= data_in + "1";
      else
        CS <= '0';
      end if;
    end if;
    
  end process;
  
  process
    variable times : natural := 0;
  begin
    while times < 50 loop
      times := times +1;
    end loop;
    wait;     
  end process;
  
  spi:entity work.SPI_rx2_top(receiver)
    port map (
      SCK  => SCK,
      CS   => CS,
      DATA => DATA,
      LED  => LED);
  
end test;
