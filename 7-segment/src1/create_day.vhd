library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;


entity create_day is
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
end entity;


architecture behavior  of create_day is
  signal add_a_month_m : std_logic;
  signal add_a_month_a : std_logic;
  signal day_m       : std_logic_vector(5 downto 0);
  
begin
  
  day         <= day_m;
  add_a_month <= add_a_month_a or add_a_month_m;

  
  process(clk)
  begin
    if rising_edge(clk) then
      if rstn = '0' then
        add_a_month_a <= '0';
      else

        if add_a_month_a = '1'then
          add_a_month_a  <= '0';
        end if;
        
        if mode = x"2" then
          if increament = '1' then
            add_a_month_a  <= '1';
          end if;
        end if;

      end if;
    end if;
  end process;

  
  process(add_a_day, mode, month, day_m, leap_day)
  begin
    if mode = x"0" then
      
      if month = "00001" or month = "00011" or month = "00101" or month = "00111" or month = "01000" or month = "10000" or month = "10010" then
        if add_a_day = '1' and day_m = "110001" then
          add_a_month_m <= '1';
        else
          add_a_month_m <= '0';
        end if;
        
      elsif month = "00100" or month = "00110" or month = "01001" or month = "10001"  then
        if add_a_day = '1' and day_m = "110000" then
          add_a_month_m <= '1';
        else
          add_a_month_m <= '0';
        end if;
        
      elsif month = "00010" then
        if leap_day = '1' then
          if add_a_day = '1' and day_m = "101001" then
            add_a_month_m <= '1';
          else
            add_a_month_m <= '0';
          end if;
        else
          if add_a_day = '1' and day_m = "101000" then
            add_a_month_m <= '1';
          else
            add_a_month_m <= '0';
          end if;
        end if;
		else
		  add_a_month_m <= '0';
      end if;
    else
      add_a_month_m <= '0';
    end if;                             -- mode = x"0"
  end process;

  
  process(clk)
  begin
    if rising_edge(clk) then
      if rstn = '0' then
        day_m   <= "000001";

      else
        if mode = x"0" or mode = x"3"then
          
          if add_a_day = '1' then
            day_m(3 downto 0) <= day_m(3 downto 0) + "1";
            -- ** set month

            case month is
              when "00001" | "00011" |"00101"|"00111"|"01000"|"10000"|"10010" =>
                if day_m(5 downto 4) = "11" then 
                  if day_m(3 downto 0) = x"1" then
                    day_m(3 downto 0) <= x"1";
                    day_m(5 downto 4) <= "00";
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
            
          end if;
          
        end if;

      end if;
    end if;
  end process;
  
end architecture;
