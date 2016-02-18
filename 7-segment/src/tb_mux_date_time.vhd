library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_mux_date_time is
  
  generic (
    period : time := 1 ns;          -- frequence
    n : natural := 8
    );
end entity;


architecture test of tb_mux_date_time is
  signal date_time_n   : std_logic := '0';
  signal mode   : std_logic_vector(3 downto 0) := x"0";
  signal year   : std_logic_vector(7 downto 0) := x"00";
  signal month  : std_logic_vector(4 downto 0) := "00000";
  signal day    : std_logic_vector(5 downto 0) := "000000";
  signal hour   : std_logic_vector(5 downto 0) := "000000";
  signal minute : std_logic_vector(6 downto 0) := "0000000";
  signal second : std_logic_vector(6 downto 0) := "0000000";
  signal seg_h : std_logic_vector(7 downto 0) ;
  signal seg_m : std_logic_vector(7 downto 0) ;
  signal seg_l : std_logic_vector(7 downto 0) ;
  
begin  -- test

  process
  begin  -- process
    wait for 5 * period;
    date_time_n <= '1';
    year <= x"15";
    month(4) <= '0';             --std_logic_vector(to_unsigned(7, 5));
    month(3 downto 0) <= x"7";           
    day(5 downto 4) <= "01";
    day(3 downto 0) <= x"6";
    hour(5 downto 4) <= "01";
    hour(3 downto 0) <= x"1";
    minute(6 downto 4) <= "001";
    minute(3 downto 0) <= x"2";
    second(6 downto 4) <= "010";
    second(3 downto 0) <= x"5";

    wait for 5 * period;
    date_time_n <= '0';
    year <= x"16";
    month(4) <= '0';             --std_logic_vector(to_unsigned(7, 5));
    month(3 downto 0) <= x"8";           
    day(5 downto 4) <= "01";
    day(3 downto 0) <= x"7";
    hour(5 downto 4) <= "01";
    hour(3 downto 0) <= x"2";
    minute(6 downto 4) <= "001";
    minute(3 downto 0) <= x"3";
    second(6 downto 4) <= "010";
    second(3 downto 0) <= x"6";
    
    
    wait for 3 * period;
    date_time_n <= '1';
    year <= x"15";
    month(4) <= '0';             --std_logic_vector(to_unsigned(7, 5));
    month(3 downto 0) <= x"9";           
    day(5 downto 4) <= "01";
    day(3 downto 0) <= x"8";
    hour(5 downto 4) <= "01";
    hour(3 downto 0) <= x"3";
    minute(6 downto 4) <= "001";
    minute(3 downto 0) <= x"4";
    second(6 downto 4) <= "010";
    second(3 downto 0) <= x"7";
    
    wait for 7 * period;
    date_time_n <= '0';
    mode <= x"6";
    year <= x"15";
    month(4) <= '1';             --std_logic_vector(to_unsigned(7, 5));
    month(3 downto 0) <= x"0";           
    day(5 downto 4) <= "01";
    day(3 downto 0) <= x"9";
    hour(5 downto 4) <= "01";
    hour(3 downto 0) <= x"4";
    minute(6 downto 4) <= "001";
    minute(3 downto 0) <= x"5";
    second(6 downto 4) <= "010";
    second(3 downto 0) <= x"8";
    wait for 7 * period;
    date_time_n <= '1';
    mode <= x"7";
    
    
    wait;
  end process;

  mux: entity work.mux_date_time(behavior) 
    port map(
      date_time_n => date_time_n,
      mode => mode,
      year  => year,
      month => month,
      day => day,
      hour => hour,
      minute => minute,
      second => second,
      seg_h => seg_h,
      seg_m => seg_m,
      seg_l => seg_l
      );
  
end test;
