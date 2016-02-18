library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
entity tb_tx_module is 

  generic (
    half_period : time := 20 ns;
    n : natural := 0 
    );

end entity;

architecture behavior of tb_tx_module is 
  signal clk        : std_logic := '0';
  signal rstn       : std_logic := '0';
  signal tx_en_sig  : std_logic := '0';
  signal tx_data    : std_logic_vector(7 downto 0) := x"00";
  signal tx_done_sig: std_logic := '0';
  signal tx_pin_out : std_logic := '0';
  

  
  
begin

  process
  begin  -- process
    clk<=not clk;
    wait for half_period;
  end process;

  

  process
  begin  -- process
    wait for 5 * half_period;
    rstn <= '0';
    wait for 15 * half_period;
    rstn <= '1';
    tx_data <= "01010101";
    tx_en_sig <= '1';
    wait for 100000 * half_period;
    wait for 100000 * half_period;
    
  end process;

  time: entity work.tx_module(behavior)
    port map(
      clk        => clk,
      rstn       => rstn,
      tx_en_sig  => tx_en_sig,
      tx_done_sig=> tx_done_sig,
      tx_data    => tx_data,
      tx_pin_out => tx_pin_out
      );


end architecture;
