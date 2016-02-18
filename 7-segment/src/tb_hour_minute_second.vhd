library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_hour_minute_second is
  
  generic (
    half_period : time := 1 ns;          -- frequence
    n : natural := 8
    );
end entity;


architecture test of tb_hour_minute_second is
  
  signal clk       : std_logic := '0';
  signal rstn      : std_logic := '1';
  signal add_a_day : std_logic := '0';
  signal mode      : std_logic_vector(3 downto 0) := (others => '0');
  signal hour_i    : std_logic_vector(5 downto 0) := (others => '0');
  signal minute_i  : std_logic_vector(6 downto 0) := (others => '0');
  signal second_i  : std_logic_vector(6 downto 0) := (others => '0');
  signal hour      : std_logic_vector(5 downto 0) ;
  signal minute    : std_logic_vector(6 downto 0) ;
  signal second    : std_logic_vector(6 downto 0) ;

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
    rstn <= '0';
    hour_i(5 downto 4) <= "10";
    hour_i(3 downto 0) <= x"2";
    minute_i(6 downto 4) <= "001";
    minute_i(3 downto 0) <= x"2";
    second_i(6 downto 4) <= "010";
    second_i(3 downto 0) <= x"5";

    wait for 5 * half_period;
    rstn <= '1';

    wait for 40000 * half_period;
    
    wait for 7 * half_period;
    mode <= x"1";
    hour_i(5 downto 4) <= "01";
    hour_i(3 downto 0) <= x"1";
    minute_i(6 downto 4) <= "001";
    minute_i(3 downto 0) <= x"2";
    second_i(6 downto 4) <= "010";
    second_i(3 downto 0) <= x"5";
        
    
    wait;
  end process;

  time: entity work.hour_minute_second(behavior) 
    port map( clk => clk, 
              rstn => rstn, 
              add_a_day => add_a_day, 
              mode => mode, 
              hour_i => hour_i, 
              minute_i => minute_i,
              second_i => second_i, 
              hour   => hour, 
              minute => minute,
              second => second
              );
  
end test;
