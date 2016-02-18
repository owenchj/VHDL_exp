library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity create_minute is
  port(
    clk            : in std_logic;
    rstn           : in std_logic;
    add_a_minute   : in std_logic;
    increament     : in std_logic;
    add_a_hour     : out std_logic;
    mode           : in std_logic_vector(3 downto 0);
    minute         : out std_logic_vector(6 downto 0)
    );
end entity;


architecture behavior  of create_minute is
  signal add_a_hour_a : std_logic;
  signal add_a_hour_m : std_logic;
  signal minute_m       : std_logic_vector(6 downto 0);
  
begin 
  
  minute      <= minute_m;
  add_a_hour  <= add_a_hour_m or add_a_hour_a;

  process(add_a_minute, mode, minute_m)
  begin
    if mode = x"0" and add_a_minute ='1' and minute_m = "1011001" then
      add_a_hour_m  <= '1';
    else
      add_a_hour_m  <= '0';
    end if;
  end process;

  
  process(clk)
  begin
    if rising_edge(clk) then
      if rstn = '0' then
        add_a_hour_a <= '0';
      else

        if add_a_hour_a = '1'then
          add_a_hour_a  <= '0';
        end if;
        
        if mode = x"4" then
          if increament = '1' then
            add_a_hour_a  <= '1';
          end if;
        end if;

      end if;
    end if;
  end process;


  
  process(clk)
  begin
    if rising_edge(clk) then
      if rstn = '0' then
        minute_m <= "0000000";

      else
        if mode = x"0" or mode = x"5" then
          
          if add_a_minute = '1' then
            if minute_m(3 downto 0) = x"9" then
              minute_m(3 downto 0) <= x"0";
              if minute_m(6 downto 4) = "101" then
                minute_m(6 downto 4) <= "000";
              else
                minute_m(6 downto 4) <= minute_m(6 downto 4) + "1";
              end if;
            else
              minute_m(3 downto 0) <= minute_m(3 downto 0) + "1";
            end if;
          end if;
          
        end if; 
        
      end if;
    end if;
  end process;
  
end architecture;
