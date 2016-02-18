library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity control_module_new is
  port (

    clk          : in std_logic;
    rstn         : in std_logic;
    start_sig    : in std_logic;
    done_sig     : out std_logic;
    write_en_sig : out std_logic;
    rom_addr     : out std_logic_vector(3 downto 0);
    ram_addr     : out std_logic_vector(3 downto 0)        
    );  
end entity;


architecture behavior of control_module_new is
  signal rrom    : std_logic_vector(3 downto 0);
  signal rram    : std_logic_vector(3 downto 0);
  signal i       : std_logic_vector(1 downto 0);
  signal x       : std_logic_vector(4 downto 0);
  signal y       : std_logic_vector(4 downto 0);
  signal counter : std_logic_vector(4 downto 0);
  signal iswrite : std_logic;
  signal isdone  : std_logic;
begin

  
  process(clk)
  begin
    if rising_edge(clk) then
      if rstn = '0' then
        rram <= x"0";
        rrom <= x"0";
        i <= "00";
        x <= "00000";
        y <= "00000";
        counter <= "00000";
        iswrite <= '0';
        isdone <= '0';
      elsif start_sig = '1' then
        case i is
          when "00" =>
            if y = counter then
              rrom <= y(3 downto 0);
              y <= y + "1";
            end if;
            
            if x + "1" = counter then
              rram <= x(3 downto 0);
              x <= x + "1";
              iswrite <= '1';
            end if;
            
            if counter = "10000" then
              x <= "00000";
              y <= "00000";
              iswrite <= '0';
              i <= i + "1";
            else
              counter <= counter + "1";
            end if;
            
          when "01" =>
            isdone <= '1';
            i <= i + "1";
            
          when "10" =>
            isdone <= '0';
            i <= "00";
          when others => null;    
        end case;
      end if;
    end if;
    
  end process;

  rom_addr <= rrom;
  ram_addr <= rram;
  write_en_sig <= iswrite;
  done_sig <= isdone;

end architecture;
