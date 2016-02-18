library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity vga_module is
  
  port (
    clk       : in std_logic;
    rstn      : in std_logic;
    hsync     : out std_logic;
    vsync     : out std_logic;
    rgb_sig   : out std_logic_vector(2 downto 0)
    );

end entity;

architecture behavior of vga_module is
  

  component reset_module is
    generic(
      state : boolean := false
      );
    
    port (
      clk     : in std_logic;
      rstn    : in std_logic;
      out_rst : out std_logic
      );  
  end component;

  component pll_vga is
    port (
      refclk   : in  std_logic := '0'; --  refclk.clk
      rst      : in  std_logic := '0'; --   reset.reset
      outclk_0 : out std_logic         -- outclk0.clk
      );
  end component;
  
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

  component sync_module is
    port (
      clk    : in std_logic;
      rstn   : in std_logic;
      hsync  : out std_logic;
      vsync  : out std_logic;
      qc1    : out std_logic_vector(10 downto 0);
      qc2    : out std_logic_vector(9 downto 0)
      );

  end component;

  signal clk_40M  :  std_logic;
  signal qc1      :  std_logic_vector(10 downto 0);
  signal qc2      :  std_logic_vector(9 downto 0);
  signal u_hsync  :  std_logic;
  signal u_vsync  :  std_logic;
  signal rom_addr :  std_logic_vector(10 downto 0);
  signal rom_data :  std_logic_vector(7 downto 0);
  signal reg_0    :  std_logic_vector(1 downto 0);
  signal reg_1    :  std_logic_vector(1 downto 0);
  signal reg_2    :  std_logic_vector(1 downto 0);
  signal rst      :  std_logic;
  signal rst_n    :  std_logic;

begin

  rst <= '0';
  

  U0 : pll_vga port map(
    refclk   => clk,
    rst      => rst,
    outclk_0 => clk_40M
    );

  -- syncronization
  U4 : reset_module
    generic map(
      state => false
      )
    
    port map(
      clk     => clk_40M,
      rstn    => rstn,
      out_rst => rst_n
      );
  
  U1 :  vga_control_module port map (
    clk       => clk_40M,
    rstn      => rst_n,
    qc1       => qc1,
    qc2       => qc2,
    rgb_sig   => rgb_sig,
    rom_data  => rom_data,
    rom_addr  => rom_addr
    );


  U2: rom_module  port map (
    clk      => clk_40M,
    rom_addr => rom_addr,
    rom_data => rom_data
    );  


  U3: sync_module port map (
    clk    => clk_40M,
    rstn   => rst_n,
    hsync  => u_hsync,
    vsync  => u_vsync,
    qc1    => qc1,
    qc2    => qc2
    );


  process(clk_40M)
  begin
    if rising_edge(clk_40M) then
      if rst_n = '0' then
        reg_0 <= "11";
        reg_1 <= "11";
        reg_2 <= "11";
      else
        reg_0 <= u_hsync & u_vsync;
        reg_1 <= reg_0;
        reg_2 <= reg_1;
      end if;
    end if;
  end process;

  hsync <= reg_2(1);
  vsync <= reg_2(0);

end architecture;
