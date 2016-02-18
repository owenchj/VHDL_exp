library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;


entity adjust_date_time is
  port(
    clk           : in std_logic;
    rstn          : in std_logic;
    adjust        : in std_logic;
    increament    : in std_logic;
    mode          : out std_logic_vector(3 downto 0);
    year_old      : in std_logic_vector(7 downto 0);  -- 2000-2099
    month_old     : in std_logic_vector(4 downto 0);
    day_old       : in std_logic_vector(5 downto 0);
    hour_old      : in std_logic_vector(5 downto 0);
    minute_old    : in std_logic_vector(6 downto 0);
    second_old    : in std_logic_vector(6 downto 0);
    year          : out std_logic_vector(7 downto 0);  -- 2000-2099
    month         : out std_logic_vector(4 downto 0);
    day           : out std_logic_vector(5 downto 0);
    hour          : out std_logic_vector(5 downto 0);
    minute        : out std_logic_vector(6 downto 0);
    second        : out std_logic_vector(6 downto 0)
    );
end entity;


architecture behavior of adjust_date_time is

  signal mode_m        : std_logic_vector(3 downto 0);
  signal year_m        : std_logic_vector(7 downto 0);  -- 2000-2099
  signal month_m       : std_logic_vector(4 downto 0);
  signal day_m         : std_logic_vector(5 downto 0);
  signal hour_m        : std_logic_vector(5 downto 0); 
  signal minute_m      : std_logic_vector(6 downto 0);
  signal second_m      : std_logic_vector(6 downto 0);
  signal adjust_n      : std_logic;
  signal increament_n  : std_logic;
  signal adjust_m     : std_logic;
  signal increament_m  : std_logic;
  signal save_old_value: std_logic;

  component no_jiter is
    port(
      clk           : in std_logic;
      rstn          : in std_logic;
      in_sig        : in std_logic;
      out_sig       : out std_logic
      );
  end component;
  
begin

  mode     <= mode_m;
  hour     <= hour_m;
  minute   <= minute_m;
  second   <= second_m;
  year     <= year_m;
  month    <= month_m;
  day      <= day_m;
  adjust_n <=  not adjust;
  increament_n <=not increament;
  
  U0: no_jiter port map(
    clk      => clk,
    rstn     => rstn,
    in_sig   => adjust_n,
    out_sig  => adjust_m
    );

  U1: no_jiter port map(
    clk      => clk,
    rstn     => rstn,
    in_sig   => increament_n,
    out_sig  => increament_m
    ); 

-- mode counter to change the mode
  process(clk)
  begin
    if rising_edge(clk) then
      if rstn = '0' then
        mode_m <= x"0";
      else
        if adjust_m = '1' then
          if mode_m = x"c" then
            mode_m <= x"0";
          else
            mode_m <= mode_m + "1";
          end if;
        end if;
        
      end if;
    end if;
  end process;


  process(clk)
  begin
    if rising_edge(clk) then
      if rstn = '0' then
        save_old_value <= '0';
      else
        case mode_m is
          when x"1" =>
            if save_old_value = '0' then
              save_old_value <= '1';
            end if;
            
          when x"c" =>
            save_old_value <= '0';
            
          when others => null;
        end case;            

      end if;   
    end if;
  end process;



  
  
-- adjust segment
  date : process(clk)
  begin
    if rising_edge(clk) then
      if rstn = '0' then
        year_m  <= x"15";
        month_m <= "00001";
        day_m   <= "000001";
      else
        case mode_m is
          
          when x"0" =>
            
          when x"1" =>
            if save_old_value ='0' then --save the old value once
              year_m  <= year_old;
              month_m <= month_old;
              day_m   <= day_old;
            end if;
            
            if increament_m = '1' then
              if year_m(7 downto 4) = "1001" then
                year_m(7 downto 4) <= x"0";
              else   
                year_m(7 downto 4) <= year_m(7 downto 4) + "1";
              end if;
            end if;

          when x"2" =>
            if increament_m = '1' then
              if year_m(3 downto 0) = "1001" then
                year_m(3 downto 0) <= x"0";
              else   
                year_m(3 downto 0) <= year_m(3 downto 0) + "1";
              end if;
            end if;

          when x"3" =>
            if increament_m = '1' then
              month_m(4) <= not month_m(4);
            end if;

          when x"4" =>
            if increament_m = '1' then
              if (month(4)='1' and  unsigned(month_m(3 downto 0)) >=2) or month_m(3 downto 0) = x"9" then
                month_m(3 downto 0) <= x"0";
              else   
                month_m(3 downto 0) <= month_m(3 downto 0) + "1";
              end if;
            end if;

          when x"5" =>
            if increament_m = '1' then
              day_m(5 downto 4) <= day_m(5 downto 4) + "1";
            end if;

          when x"6" =>                  --bug
            if increament_m = '1' then
              if day_m(3 downto 0) = "1001" then
                day_m(3 downto 0) <= x"0";
              else   
                day_m(3 downto 0) <= day_m(3 downto 0) + "1";
              end if;
            end if;

          when others => null;
        end case;
        
      end if;
    end if;
  end process date;

  times : process(clk)
  begin
    if rising_edge(clk) then
      if rstn = '0' then
        hour_m     <= "010010";
        minute_m   <= "0010011";
        second_m   <= "0100101";
      else
        case mode_m is
          
          when x"1" =>
            if save_old_value ='0' then --save the old value once
              hour_m  <= hour_old;
              minute_m <= minute_old;
              second_m   <= second_old;
            end if;
            
          when x"7" =>
            if increament_m = '1' then
              if hour_m(5 downto 4) = "10" then
                hour_m(5 downto 4) <= "00";
              else   
                hour_m(5 downto 4) <= hour_m(5 downto 4) + "1";
              end if;
            end if;

          when x"8" =>
            if increament_m = '1' then
              if (hour_m(5 downto 4) = "10" and unsigned(hour_m(3 downto 0)) >= 3) or hour_m(3 downto 0) = x"9" then
                hour_m(3 downto 0) <= x"0";
              else
                hour_m(3 downto 0) <= hour_m(3 downto 0) + "1";
              end if;
            end if;
            
          when x"9" =>
            if increament_m = '1' then
              if minute_m(6 downto 4) = "101" then
                minute_m(6 downto 4) <= "000";
              else   
                minute_m(6 downto 4) <= minute_m(6 downto 4) + "1";
              end if;
            end if;

          when x"a" =>
            if increament_m = '1' then
              if minute_m(3 downto 0) = "1001" then
                minute_m(3 downto 0) <= x"0";
              else   
                minute_m(3 downto 0) <= minute_m(3 downto 0) + "1";
              end if;
            end if;

          when x"b" =>
            if increament_m = '1' then
              if second_m(6 downto 4) = "101" then
                second_m(6 downto 4) <= "000";
              else   
                second_m(6 downto 4) <= second_m(6 downto 4) + "1";
              end if;
            end if;

          when x"c" =>
            if increament_m = '1' then
              if second_m(3 downto 0) = "1001" then
                second_m(3 downto 0) <= x"0";
              else   
                second_m(3 downto 0) <= second_m(3 downto 0) + "1";
              end if;
            end if;

          when others => null;
        end case;
        
      end if;
    end if;
  end process times;

end architecture;
