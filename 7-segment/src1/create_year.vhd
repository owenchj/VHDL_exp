library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;


entity create_year is
  port(
    clk         : in std_logic;
    rstn        : in std_logic;
    add_a_year  : in std_logic;
    mode        : in std_logic_vector(3 downto 0);
    year        : out std_logic_vector(7 downto 0);  -- 2000-2099
    leap_day    : out std_logic
    );
end entity;


architecture behavior  of create_year is

  
  signal year_m      : std_logic_vector(7 downto 0);  -- 2000-2099
  
begin
  
  year  <= year_m;

  process(year_m)
  begin
    if(year_m(4) = '0' and year_m(1 downto 0) = "00") or (year_m(4) = '1' and year_m(1 downto 0) = "10") then
      leap_day <= '1';
    else
      leap_day <= '0';
    end if;
  end process;

    
  process(clk)
  begin
    if rising_edge(clk) then
      if rstn = '0' then
        year_m  <= x"15";

      else
        if mode = x"0" or mode = x"1" then
          
          if add_a_year = '1' then
            -- set year
            if year_m(3 downto 0) = x"9" then 
              year_m(3 downto 0) <= x"0";
              if year_m(7 downto 4) = x"9" then 
                year_m(7 downto 4) <= x"0";
              else
                year_m(7 downto 4) <= year_m(7 downto 4) + "1";
              end if;
            else
              year_m(3 downto 0) <=  year_m(3 downto 0) + "1";
            end if;
          end if;
          
        end if;
        
      end if;
    end if;
  end process;
  
end architecture;
