library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux_date_time is
  port(
    date_time_n : in std_logic;
    mode        : in std_logic_vector(3 downto 0);
    year        : in std_logic_vector(7 downto 0);
    month       : in std_logic_vector(4 downto 0);
    day         : in std_logic_vector(5 downto 0);
    hour        : in std_logic_vector(5 downto 0);
    minute      : in std_logic_vector(6 downto 0);
    second      : in std_logic_vector(6 downto 0);
    seg_h       : out std_logic_vector(7 downto 0);
    seg_m       : out std_logic_vector(7 downto 0);
    seg_l       : out std_logic_vector(7 downto 0)
    );
end entity;

architecture behavior of mux_date_time is
begin
  seg_h(7 downto 4) <= year(7 downto 4)          when (mode = x"0" and date_time_n = '1') or (unsigned(mode) < 7 and unsigned(mode) > 0)  else "00" & hour(5 downto 4);
  seg_h(3 downto 0) <= year(3 downto 0)          when (mode = x"0" and date_time_n = '1') or (unsigned(mode) < 7 and unsigned(mode) > 0)  else hour(3 downto 0);

  seg_m(7 downto 4) <= "000" & month(4)          when (mode = x"0" and date_time_n = '1') or (unsigned(mode) < 7 and unsigned(mode) > 0)  else "0" & minute(6 downto 4);
  seg_m(3 downto 0) <= month(3 downto 0)         when (mode = x"0" and date_time_n = '1') or (unsigned(mode) < 7 and unsigned(mode) > 0)  else minute(3 downto 0);
  
  seg_l(7 downto 4) <= "00" & day(5 downto 4)    when (mode = x"0" and date_time_n = '1') or (unsigned(mode) < 7 and unsigned(mode) > 0)  else "0" & second(6 downto 4);
  seg_l(3 downto 0) <= day(3 downto 0)           when (mode = x"0" and date_time_n = '1') or (unsigned(mode) < 7 and unsigned(mode) > 0)  else second(3 downto 0);
end architecture;
