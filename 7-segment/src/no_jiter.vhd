library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity no_jiter is
  generic(
   length : integer := integer(ceil(log2(real(5000))));
   times : integer := 5000 - 1
  );

 
  
  port(
    clk           : in std_logic;
    rstn          : in std_logic;
    in_sig        : in std_logic;
    out_sig       : out std_logic
    );
end entity;


architecture behavior of no_jiter is
  signal l2h_0   : std_logic := '0';
  signal l2h_1   : std_logic := '0';
  signal l2h     : std_logic := '0';
  signal flag    : std_logic := '0';
  signal out_sig_m    : std_logic := '0';
  signal counter : std_logic_vector(length - 1 downto 0);

begin
  
  l2h <= l2h_0 and (not l2h_1);
  out_sig <= out_sig_m;

  process(clk)
  begin
    if rising_edge(clk) then
      if rstn = '0' then
        counter  <= (others => '0');
        flag     <= '0';
      else
        if l2h = '1' then
          flag <= '1';
        end if;
        
        if (unsigned(counter) = times ) then  -- !
            counter  <= (others => '0');
            flag <= '0';
            
        elsif flag = '1' then
          counter  <= counter + "1";
        end if;

      end if;
    end if;
  end process;


  
process(clk)
  begin
    if rising_edge(clk) then
      if rstn = '0' then
        out_sig_m <= '0';        
      else
        
        if (unsigned(counter) = times ) then
           out_sig_m <= '1';        
        end if;

        if out_sig_m = '1' then 
           out_sig_m <= '0';        
        end if;
        
      end if;
    end if;
  end process;
  
  process(clk)
  begin
    if rising_edge(clk) then
      if rstn = '0' then
        l2h_0 <= '0';
        l2h_1 <= '0';
      else
        l2h_0 <= in_sig;
        l2h_1 <= l2h_0;
      end if;
    end if;
  end process;

  
end architecture;
