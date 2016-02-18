library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;


entity year_month_day is
  port(
    clk         : in std_logic;
    rstn        : in std_logic;
    add_a_day   : in std_logic;
    increament  : in std_logic;
    mode        : in std_logic_vector(3 downto 0);
    year        : out std_logic_vector(7 downto 0);  -- 2000-2099
    month       : out std_logic_vector(4 downto 0);
    day         : out std_logic_vector(5 downto 0)
    );
end entity;


architecture behavior  of year_month_day is

  signal leap_day    :  std_logic :='0';
  signal add_a_month :  std_logic :='0';
  signal add_a_year  :  std_logic :='0';
  signal month_m     :  std_logic_vector(4 downto 0);
  

  component create_year is
    port(
      clk         : in std_logic;
      rstn        : in std_logic;
      add_a_year  : in std_logic;
      mode        : in std_logic_vector(3 downto 0);
      year        : out std_logic_vector(7 downto 0);  -- 2000-2099
      leap_day    : out std_logic
      );
  end component;
  
  component create_month is
    port(
      clk         : in std_logic;
      rstn        : in std_logic;
      add_a_month : in std_logic;
      increament  : in std_logic;
      mode        : in std_logic_vector(3 downto 0);
      add_a_year  : out std_logic;
      month       : out std_logic_vector(4 downto 0)
      );
  end component;


  component create_day is
    port(
      clk         : in std_logic;
      rstn        : in std_logic;
      add_a_day   : in std_logic;
      increament  : in std_logic;
      leap_day    : in std_logic;
      mode        : in std_logic_vector(3 downto 0);
      month       : in std_logic_vector(4 downto 0);  
      add_a_month : out std_logic;
      day         : out std_logic_vector(5 downto 0)
      );
  end component;

begin 


  month <= month_m;
  
  U0: create_year port map(
    clk         =>  clk,
    rstn        =>  rstn,
    add_a_year  =>  add_a_year,
    mode        =>  mode,
    year        =>  year,
    leap_day    => leap_day
    );

  
  U1: create_month port map(
    clk         =>  clk,
    rstn        =>  rstn,
    add_a_month =>  add_a_month,
    increament  => increament,
    mode        =>  mode,
    add_a_year  =>  add_a_year,
    month       =>  month_m
    );



  U2: create_day port map(
    clk         => clk,
    rstn        => rstn,
    add_a_day   => add_a_day,
    increament  => increament,
    leap_day    => leap_day,
    mode        => mode,
    month       => month_m,
    add_a_month => add_a_month,
    day         => day
    );


end architecture;
