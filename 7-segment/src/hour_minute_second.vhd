library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use IEEE.math_real.all;

entity hour_minute_second is
  generic(
 
    times  : integer := 50000000 - 1;
    length : integer := integer(ceil(log2(real(50000000))))
    );

  port(
    clk            : in std_logic;
    rstn           : in std_logic;
    add_a_day      : out std_logic;
    mode           : in std_logic_vector(3 downto 0);
    hour_i         : in std_logic_vector(5 downto 0); 
    minute_i       : in std_logic_vector(6 downto 0);
    second_i       : in std_logic_vector(6 downto 0);
    hour           : out std_logic_vector(5 downto 0);
    minute         : out std_logic_vector(6 downto 0);
    second         : out std_logic_vector(6 downto 0)
    );
end entity;


architecture behavior  of hour_minute_second is

  signal hour_m        : std_logic_vector(5 downto 0);
  signal minute_m      : std_logic_vector(6 downto 0);
  signal second_m      : std_logic_vector(6 downto 0);
  signal add_a_day_m   : std_logic;
  signal counter       : std_logic_vector(length - 1 downto 0);
  
begin 
  
  hour       <= hour_m;
  minute     <= minute_m;
  second     <= second_m;
  add_a_day  <= add_a_day_m;

  p1:  process(clk)
  begin
    if rising_edge(clk) then
      if rstn = '0' then
        counter  <= (others => '0');
      else
        if mode = x"0" then
          if (unsigned(counter) = times ) then  -- !
            counter  <= (others => '0');
          else
            counter  <= counter + "1";
          end if;
        end if;

      end if;
    end if;
  end process p1;
  

  p2:  process(clk)
  begin
    if rising_edge(clk) then
      if rstn = '0' then
        add_a_day_m  <= '0';
      else
        if add_a_day_m  = '1' then
          add_a_day_m  <= '0';
        end if;
        
        if hour_m = "100011" and minute_m = "1011001" and second_m = "1011001" and (unsigned(counter) = times - 1) then
          add_a_day_m  <= '1';
        end if;
        
      end if;
    end if;
  end process p2;
  
  
  p3:  process(clk)
  begin
    if rising_edge(clk) then
      if rstn = '0' then
        hour_m  <= hour_i;
        minute_m <= minute_i;
        second_m   <= second_i;
      elsif mode = "0" then
        
        if (unsigned(counter) = times) then
          second_m(3 downto 0) <= second_m(3 downto 0) + "1";    -- second add
          
          if second_m(3 downto 0) = x"9" then
            second_m(3 downto 0) <= x"0";
            if second_m(6 downto 4) = "101" then
              second_m(6 downto 4) <= "000";
              minute_m(3 downto 0) <= minute_m(3 downto 0) + "1";  -- minute add
            else
              second_m(6 downto 4) <= second_m(6 downto 4) + "1";
            end if;
          end if;

          if minute_m(3 downto 0) = x"9" then
            if second_m = "1011001" then
              minute_m(3 downto 0) <= x"0";
              if minute_m(6 downto 4) = "101" then
                minute_m(6 downto 4) <= "000";
                hour_m(3 downto 0) <= hour_m(3 downto 0) + "1";         -- hour add
              else
              minute_m(6 downto 4) <= minute_m(6 downto 4) + "1";
            end if;
          end if;
        end if;

        
        
        if hour_m(5 downto 4) = "10" then
          if hour_m(3 downto 0) = x"3" then
            if minute_m = "1011001" and second_m = "1011001"then
              hour_m(3 downto 0) <= x"0";         -- hour add
              hour_m(5 downto 4) <= "00";
            end if;
          end if;
        else
          if hour_m(3 downto 0) = x"9" then
            hour_m(3 downto 0) <= x"0";         -- hour add
            hour_m(5 downto 4) <= hour_m(5 downto 4) + "1";
          end if;
        end if;
        
                                    -- only when counter is valid
        end if;
      else
        hour_m  <= hour_i;
        minute_m <= minute_i;
        second_m   <= second_i;
        
      end if;
    end if;
  end process p3;
  
end architecture;
