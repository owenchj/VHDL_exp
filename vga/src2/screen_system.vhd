library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity screen_system is
  
  port (
    clk       : in std_logic;
    rstn      : in std_logic;
    hsync     : out std_logic;
    vsync     : out std_logic;
    rgb_sig   : out std_logic_vector(2 downto 0)
    );

end entity;

architecture behavior of screen_system is

  signal clk_40M      :  std_logic;
  signal qc1          :  std_logic_vector(10 downto 0);
  signal qc2          :  std_logic_vector(9 downto 0);
  signal u_hsync      :  std_logic;
  signal u_vsync      :  std_logic;
  signal rgb_sig_1    :  std_logic_vector(2 downto 0);
  signal rgb_sig_2    :  std_logic_vector(2 downto 0);
  signal reg_0        :  std_logic_vector(1 downto 0);
  signal reg_1        :  std_logic_vector(1 downto 0);
  signal reg_2        :  std_logic_vector(1 downto 0);
  signal rst          :  std_logic;
  signal rst_n        :  std_logic;

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

  component screen_module is
    port (
      clk       : in std_logic;
      rstn      : in std_logic;
      qc1       : in std_logic_vector(10 downto 0);
      qc2       : in std_logic_vector(9 downto 0);
      rgb_sig   : out std_logic_vector(2 downto 0)
      );
  end component;

  component screen_interface1 is
    port (
      clk       : in std_logic;
      rstn      : in std_logic;
      qc1       : in std_logic_vector(10 downto 0);
      qc2       : in std_logic_vector(9 downto 0);
      hp        : in std_logic_vector(7 downto 0);
      maxhp     : in std_logic_vector(7 downto 0);
      rgb_sig   : out std_logic_vector(2 downto 0)
      );
  end component;
  
begin

  rst <= '0';

  U0 : pll_vga port map(
    refclk   => clk,
    rst      => rst,
    outclk_0 => clk_40M
    );

  -- syncronization
  U1 : reset_module
    generic map(
      state => false
      )
    
    port map(
      clk     => clk_40M,
      rstn    => rstn,
      out_rst => rst_n
      );

  U2: sync_module port map (
    clk    => clk_40M,
    rstn   => rst_n,
    hsync  => u_hsync,
    vsync  => u_vsync,
    qc1    => qc1,
    qc2    => qc2
    );

  U3: screen_module port map (
      clk        => clk_40M,
      rstn       => rst_n,
      qc1        => qc1,
      qc2        => qc2,
      rgb_sig    => rgb_sig_1
      );

  U4 : screen_interface1 port map (
      clk        => clk_40M,
      rstn       => rst_n,
      qc1        => qc1,
      qc2        => qc2,
      hp         => x"32",
      maxhp      => x"64",
      rgb_sig    => rgb_sig_2
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
  rgb_sig <= rgb_sig_2 or rgb_sig_1;

end architecture;
