library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity create_second is
  port(
    clk            : in std_logic;
    rstn           : in std_logic;
    add_a_minute   : out std_logic;
    increament     : in std_logic;
    add_a_second   : in std_logic;
    mode           : in std_logic_vector(3 downto 0);
    second         : out std_logic_vector(6 downto 0)
    );
end entity;


architecture behavior  of create_second is
  signal add_a_minute_a     : std_logic;
  signal add_a_minute_m     : std_logic;
  signal second_m         : std_logic_vector(6 downto 0);
  
begin 
  
  second        <= second_m;
  add_a_minute  <= add_a_minute_a or add_a_minute_m;
  
  process(add_a_second, mode, second_m)
  begin        
    if mode = x"0" and add_a_second = '1' and second_m  = "1011001" then
      add_a_minute_m  <= '1';
    else
      add_a_minute_m  <= '0';
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if rstn = '0' then
        add_a_minute_a <= '0';
      else

        if add_a_minute_a = '1'then
          add_a_minute_a  <= '0';
        end if;
        
        if mode = x"5" then
          if increament = '1' then
            add_a_minute_a  <= '1';
          end if;
        end if;

      end if;
    end if;
  end process;



  
  process(clk)
  begin
    if rising_edge(clk) then
      if rstn = '0' then
        second_m   <= "0000000";
      else
        if mode = x"0" or mode = x"6" then
          
          if add_a_second = '1' then

            if second_m(3 downto 0) = x"9" then
              second_m(3 downto 0) <= x"0";
              if second_m(6 downto 4) = "101" then
                second_m(6 downto 4) <= "000";
              else
                second_m(6 downto 4) <= second_m(6 downto 4) + "1";
              end if;
            else
              second_m(3 downto 0) <= second_m(3 downto 0) + "1";  
            end if;
          end if;
        end if;

      end if;
    end if;
  end process;
  
end architecture;
