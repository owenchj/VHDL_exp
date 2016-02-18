library ieee;
use ieee.std_logic_1164.all;

entity exp6_env is
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

architecture behavior of exp6_env is
  signal  delay_ram_addr       : std_logic_vector(3 downto 0);
  signal  delay_write_en_sig   : std_logic;
  signal  rom_addr             : std_logic_vector(3 downto 0);        

  component control_module is
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

  U0: control_module port map (
    clk          => clk ,
    rstn         => rstn,
    start_sig    => start_sig,
    done_sig     => done_sig,
    write_en_sig => delay_write_en_sig,
    rom_addr     => rom_addr,
    ram_addr     => delay_ram_addr
    );
  
  U1: rom_module port map (
    clk      => clk,
    rstn     => rstn,
    rom_addr => rom_addr,
    rom_data => rom_data
    );

  sq_rom_addr <= rom_addr;

  process(clk)
  begin
    if rising_edge(clk) then
      if rstn = '0' then
        ram_addr <= x"0";
        write_en_sig <= '0';
      else
        ram_addr <= delay_ram_addr;
        write_en_sig <= delay_write_en_sig;
      end if;
    end if;
  end process;
  
end architecture;
