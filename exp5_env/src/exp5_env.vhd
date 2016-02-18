library ieee;
use ieee.std_logic_1164.all;

entity exp5_env is
  port (
    clk          : in std_logic;
    rstn         : in std_logic;
    start_sig    : in std_logic;
    done_sig     : out std_logic;
    write_en_sig : out std_logic;
    rom_data     : out std_logic_vector(7 downto 0);
    ram_addr     : out std_logic_vector(3 downto 0);
    sq_rom_addr  : out std_logic_vector(3 downto 0)        
    );
end entity;

architecture behavior of exp5_env is
  signal  rom_addr  : std_logic_vector(3 downto 0);        

  -- you can replace your modules here:
  component control_module_new is
    port (
      clk          : in std_logic;
      rstn         : in std_logic;
      start_sig    : in std_logic;
      done_sig     : out std_logic;
      write_en_sig : out std_logic;
      rom_addr     : out std_logic_vector(3 downto 0);
      ram_addr     : out std_logic_vector(3 downto 0)        
      );  
  end component;

  component  rom_module is
    port (
      clk      : in std_logic;
      rstn     : in std_logic;
      rom_addr : in std_logic_vector(3 downto 0);
      rom_data : out std_logic_vector(7 downto 0)
      );  
  end component;

begin

  U0: control_module_new port map (
      clk          => clk ,
      rstn         => rstn,
      start_sig    => start_sig,
      done_sig     => done_sig,
      write_en_sig => write_en_sig,
      rom_addr     => rom_addr,
      ram_addr     => ram_addr
);
  
  U1: rom_module port map (
      clk      => clk,
      rstn     => rstn,
      rom_addr => rom_addr,
      rom_data => rom_data
);

  sq_rom_addr <= rom_addr;
end architecture;
