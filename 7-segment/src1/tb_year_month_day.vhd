library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_year_month_day is
  
  generic (
    half_period : time := 1 ns;          -- frequence
    n : natural := 8
    );
end entity;


architecture test of tb_year_month_day is
  
  signal clk       : std_logic := '0';
  signal rstn      : std_logic := '1';
  signal add_a_day : std_logic := '0';
  signal mode      : std_logic_vector(3 downto 0) := (others => '0');
  signal year_i    : std_logic_vector(7 downto 0) := (others => '0');
  signal month_i  : std_logic_vector(4 downto 0) := (others => '0');
  signal day_i  : std_logic_vector(5 downto 0) := (others => '0');
  signal year      : std_logic_vector(7 downto 0) ;
  signal month    : std_logic_vector(4 downto 0) ;
  signal day    : std_logic_vector(5 downto 0) ;

begin  -- test

  process 
  begin  -- process
    clk<=not clk;
    wait for half_period;
  end process;

  process
  begin  -- process
    wait for 5 * half_period;
    mode <= x"0";
    add_a_day <= '1';
    rstn <= '0';
    year_i <= x"15";
    month_i(4) <= '0';
    month_i(3 downto 0) <= x"1";
    day_i(5 downto 4) <= "00";
    day_i(3 downto 0) <= x"1";

    wait for 5 * half_period;
    rstn <= '1';

    wait for 1400 * half_period;
    
    wait for 7 * half_period;
    mode <= x"1";
    
    rstn <= '0';
    year_i <= x"16";
    month_i(4) <= '1';
    month_i(3 downto 0) <= x"2";
    day_i(5 downto 4) <= "10";
    day_i(3 downto 0) <= x"6";
    
    wait;
  end process;

  time: entity work.year_month_day(behavior) 
    port map( clk => clk, 
              rstn => rstn, 
              add_a_day => add_a_day, 
              mode => mode, 
              year_i => year_i, 
              month_i => month_i,
              day_i => day_i, 
              year   => year, 
              month => month,
              day => day
              );
  
end test;
