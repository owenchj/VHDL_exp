library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity create_hour is
  port(
    clk            : in std_logic;
    rstn           : in std_logic;
    add_a_day      : out std_logic;
    increament     : in std_logic;
    add_a_hour     : in std_logic;
    mode           : in std_logic_vector(3 downto 0);
    hour           : out std_logic_vector(5 downto 0)
    );
end entity;


architecture behavior  of create_hour is
  signal add_a_day_a     : std_logic;
  signal add_a_day_m     : std_logic;
  signal hour_m          : std_logic_vector(5 downto 0);

begin 

  hour       <= hour_m;
  add_a_day  <= add_a_day_m or add_a_day_a;
  
  process(add_a_hour, mode, hour_m)
  begin        
    if mode = x"0" and hour_m = "100011" and add_a_hour = '1' then
      add_a_day_m  <= '1';
    else
      add_a_day_m  <= '0';
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if rstn = '0' then
        add_a_day_a <= '0';
      else

        if add_a_day_a = '1'then
          add_a_day_a  <= '0';
        end if;
        
        if mode = x"3" then
          if increament = '1' then
            add_a_day_a  <= '1';
          end if;
        end if;

      end if;
    end if;
  end process;

  
  process(clk)
  begin
    if rising_edge(clk) then
      if rstn = '0' then
        hour_m  <= "100000";
      else
        if mode = x"0" or mode = x"4" then
          
          if add_a_hour = '1' then
            if hour_m(5 downto 4) = "10" then
              if hour_m(3 downto 0) = x"3" then
                hour_m(3 downto 0) <= x"0";       
                hour_m(5 downto 4) <= "00";
              else
                hour_m(3 downto 0) <= hour_m(3 downto 0) + "1";         
              end if;
              
            else
              if hour_m(3 downto 0) = x"9" then
                hour_m(3 downto 0) <= x"0";         
                hour_m(5 downto 4) <= hour_m(5 downto 4) + "1";
              else
                hour_m(3 downto 0) <= hour_m(3 downto 0) + "1";         
              end if;
            end if;
          end if;
          
        end if;
      end if;
    end if;
  end process;
  
end architecture;
