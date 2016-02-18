library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;


entity create_month is
  port(
    clk         : in std_logic;
    rstn        : in std_logic;
    add_a_month : in std_logic;
    increament  : in std_logic;
    mode        : in std_logic_vector(3 downto 0);
    add_a_year  : out std_logic;
    month       : out std_logic_vector(4 downto 0)
    );
end entity;


architecture behavior  of create_month is
  signal add_a_year_a     : std_logic;
  signal add_a_year_m     : std_logic;
  signal month_m     : std_logic_vector(4 downto 0);

begin 

  month <= month_m;
  add_a_year  <= add_a_year_m or add_a_year_a;

  
  process(add_a_month, mode, month_m)
  begin
    if mode=x"0" and add_a_month = '1' and month_m = "10010" then
      add_a_year_m <='1'; 
    else
      add_a_year_m <='0'; 
    end if;
  end process;                -- delay between two DFF


  process(clk)
  begin
    if rising_edge(clk) then
      if rstn = '0' then
        add_a_year_a <= '0';
      else

        if add_a_year_a = '1'then
          add_a_year_a  <= '0';
        end if;
        
        if mode = x"1" then
          if increament = '1' then
            add_a_year_a  <= '1';
          end if;
        end if;

      end if;
    end if;
  end process;



  
  process(clk)
  begin
    if rising_edge(clk) then
      if rstn = '0' then
        month_m <= "10001";

      else
        if mode = x"0" or mode = x"2" then

          if add_a_month ='1' then
            if month_m(3 downto 0) = x"9"  then
              month_m(3 downto 0) <= x"0";
              month_m(4) <= '1';
            elsif month_m = "10010" then
              month_m <= "00001";
            else
              month_m(3 downto 0) <= month_m(3 downto 0) + "1";
            end if;  
          end if;                         -- add_a_month

        end if;
        
      end if;
    end if;
  end process;
  
end architecture;
