library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;


entity year_month_day is
  port(
    clk         : in std_logic;
    rstn        : in std_logic;
    add_a_day   : in std_logic;
    mode        : in std_logic_vector(3 downto 0);
    year_i      : in std_logic_vector(7 downto 0);  -- 2000-2099
    month_i     : in std_logic_vector(4 downto 0);
    day_i       : in std_logic_vector(5 downto 0);
    year        : out std_logic_vector(7 downto 0);  -- 2000-2099
    month       : out std_logic_vector(4 downto 0);
    day         : out std_logic_vector(5 downto 0)
    );
end entity;


architecture behavior  of year_month_day is

  signal leap_day    :  std_logic :='0';
  signal year_m      : std_logic_vector(7 downto 0);  -- 2000-2099
  signal month_m     : std_logic_vector(4 downto 0);
  signal day_m       : std_logic_vector(5 downto 0);
  
begin 
  leap_day <= '1' when ( (unsigned(year_m(7 downto 4))*10 + unsigned(year_m(3 downto 0))) mod 4 = 0) else '0';
  
  year  <= year_m;
  month <= month_m;
  day   <= day_m;
  
  
  process(clk)
  begin
    if rising_edge(clk) then
      if rstn = '0' then
        year_m  <= year_i;
        month_m <= month_i;
        day_m   <= day_i;
      elsif mode = "0" then
        
        if add_a_day = '1' then
          day_m(3 downto 0) <= day_m(3 downto 0) + "1";
          

          
          -- ** set month
          
          case month_m is
            when "00001" | "00011" |"00101"|"00111"|"01000"|"10000"|"10010" =>
              if day_m(5 downto 4) = "11" then 
                if day_m(3 downto 0) = x"1" then
                  day_m(3 downto 0) <= x"1";
                  day_m(5 downto 4) <= "00";
                  month_m(3 downto 0) <= month_m(3 downto 0) + "1";
                end if;         
              else
                if day_m(3 downto 0) = x"9" then
                  day_m(3 downto 0) <= x"0";
                  day_m(5 downto 4) <= day_m(5 downto 4) + "1";
                end if;
              end if;
              
            when "00100"|"00110"|"01001"|"10001" =>
              if day_m(5 downto 4) = "11" then 
                if day_m(3 downto 0) = x"0" then
                  day_m(3 downto 0) <= x"1";
                  day_m(5 downto 4) <= "00";
                  month_m(3 downto 0) <= month_m(3 downto 0) + "1";
                end if;         
              else
                if day_m(3 downto 0) = x"9" then
                  day_m(3 downto 0) <= x"0";
                  day_m(5 downto 4) <= day_m(5 downto 4) + "1";
                end if;
              end if;


            when "00010" =>
              if leap_day = '1' then
                if day_m(5 downto 4) = "10" then 
                  if day_m(3 downto 0) = x"9" then
                    day_m(3 downto 0) <= x"1";
                    day_m(5 downto 4) <= "00";
                    month_m(3 downto 0) <= month_m(3 downto 0) + "1";
                  end if;         
                else
                  if day_m(3 downto 0) = x"9" then
                    day_m(3 downto 0) <= x"0";
                    day_m(5 downto 4) <= day_m(5 downto 4) + "1";
                  end if;
                end if;
              else
                if day_m(5 downto 4) = "10" then 
                  if day_m(3 downto 0) = x"8" then
                    day_m(3 downto 0) <= x"1";
                    day_m(5 downto 4) <= "00";
                    month_m(3 downto 0) <= month_m(3 downto 0) + "1";
                  end if;         
                else
                  if day_m(3 downto 0) = x"9" then
                    day_m(3 downto 0) <= x"0";
                    day_m(5 downto 4) <= day_m(5 downto 4) + "1";
                  end if;
                end if;
              end if;
            when others => null;
          end case;

          if month_m(3 downto 0) = x"9" and day_m = "110000"  then
            month_m(3 downto 0) <= x"0";
            month_m(4) <= '1';
          end if;

          -- set year

          if month_m = "10010" and day_m = "110001"then
            month_m <= "00001";
            year_m(3 downto 0) <=  year_m(3 downto 0) + "1";
          end if;

          if year_m(3 downto 0) = x"9" then 
            year_m(3 downto 0) <= x"0";

            if year_m(7 downto 4) = x"9" then 
              year_m(7 downto 4) <= x"0";
            else
              year_m(7 downto 4) <= year_m(7 downto 4) + "1";
            end if;
          end if;


          
        end if;                         -- add_a_day
      else
        year_m  <= year_i;
        month_m <= month_i;
        day_m   <= day_i;
      end if;
    end if;
  end process;
  
end architecture;
