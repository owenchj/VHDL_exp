library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity screen_module is
  port (
    clk       : in std_logic;
    rstn      : in std_logic;
    qc1       : in std_logic_vector(10 downto 0);
    qc2       : in std_logic_vector(9 downto 0);
    rgb_sig   : out std_logic_vector(2 downto 0)
    );
end entity;

architecture behavior of screen_module is
  
  
  component vga_control_module is
    port (
      clk       : in std_logic;
      rstn      : in std_logic;
      qc1       : in std_logic_vector(10 downto 0);
      qc2       : in std_logic_vector(9 downto 0);
      rgb_sig   : out std_logic_vector(2 downto 0);
      rom_data  : in std_logic_vector(7 downto 0);
      rom_addr  : out std_logic_vector(10 downto 0)
      );

  end component;

  component rom_module is
    port (
      clk      : in std_logic;
      rom_addr : in std_logic_vector(10 downto 0);
      rom_data : out std_logic_vector(7 downto 0)
      );  
  end component;


  signal rom_data   :  std_logic_vector(7 downto 0);
  signal rom_addr   :  std_logic_vector(10 downto 0);

begin

  
  U0 :  vga_control_module port map (
    clk       => clk,
    rstn      => rstn,
    qc1       => qc1,
    qc2       => qc2,
    rgb_sig   => rgb_sig,
    rom_data  => rom_data,
    rom_addr  => rom_addr
    );

  
  U1: rom_module  port map (
    clk      => clk,
    rom_addr => rom_addr,
    rom_data => rom_data
    );  

end architecture;
