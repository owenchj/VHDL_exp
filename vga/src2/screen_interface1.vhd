library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity screen_interface1 is
  port (
    clk       : in std_logic;
    rstn      : in std_logic;
    qc1       : in std_logic_vector(10 downto 0);
    qc2       : in std_logic_vector(9 downto 0);
    hp        : in std_logic_vector(7 downto 0);
    maxhp     : in std_logic_vector(7 downto 0);
    rgb_sig   : out std_logic_vector(2 downto 0)
    );
end entity;

architecture behavior of screen_interface1 is


  signal wren_sig :  std_logic;
  signal wrdata   :  std_logic_vector(7 downto 0);
  signal wraddr   :  std_logic_vector(10 downto 0);

  signal rddata   :  std_logic_vector(7 downto 0);
  signal rdaddr   :  std_logic_vector(10 downto 0);

  component screen_control_module is
    port (
      clk       : in std_logic;
      rstn      : in std_logic;
      hp        : in std_logic_vector(7 downto 0);
      maxhp     : in std_logic_vector(7 downto 0);
      wren_sig  : out std_logic;
      wraddr    : out std_logic_vector(10 downto 0);
      wrdata    : out std_logic_vector(7 downto 0)
      );
  end component;

  component ram_module1 is
    port (
      clk       : in std_logic;
      rstn      : in std_logic;
      wren_sig  : in std_logic;
      wraddr    : in std_logic_vector(10 downto 0);
      wrdata    : in std_logic_vector( 7 downto 0);
      rdaddr    : in std_logic_vector(10 downto 0);
      rddata    : out std_logic_vector(7 downto 0)
      );
  end component;

  component vga_control_module_2 is
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



begin

  U0: screen_control_module port map(
    clk        => clk,
    rstn       => rstn,
    hp         => hp,
    maxhp      => maxhp,
    wren_sig   => wren_sig,
    wraddr     => wraddr,
    wrdata     => wrdata
    );

  U1: ram_module1 port map (
    clk        => clk,
    rstn       => rstn,
    wren_sig   => wren_sig,
    wraddr     => wraddr,
    wrdata     => wrdata,
    rdaddr     => rdaddr,
    rddata     => rddata
    );

  U2 :  vga_control_module_2 port map (
    clk       => clk,
    rstn      => rstn,
    qc1       => qc1,
    qc2       => qc2,
    rgb_sig   => rgb_sig,
    rom_data  => rddata,
    rom_addr  => rdaddr
    );

end architecture;
