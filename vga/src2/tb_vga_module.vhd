library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
entity tb_vga_module is 

  generic (
    -- 50Mhz 50%
    half_period : time := 10 ns;
    n : natural := 0 
    );

end entity;

architecture behavior of tb_vga_module is 
  signal clk        : std_logic := '0';
  signal rstn       : std_logic := '0';
  signal hsync      : std_logic;
  signal vsync      : std_logic;
  signal rgb_sig    : std_logic_vector(2 downto 0);
    
  
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
    wait for 100 * half_period;
    rstn <= '1';

    wait;
  end process;

  time: entity work.vga_module(behavior)
    port map (
    clk       => clk,
    rstn      => rstn,
    hsync     => hsync,
    vsync     => vsync,
    rgb_sig   => rgb_sig
    );

end architecture;
