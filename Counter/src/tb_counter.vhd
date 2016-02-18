library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_textio.all;
use std.textio.all;


entity test_counter is
  
  generic (
    half_period : time := 1 ns;          -- period
    n: natural := 8
    );
end test_counter;

architecture test of test_counter is

 --component counter
 --   port ( count : out std_logic_vector(3 downto 0);
 --          clk   : in std_logic;
 --          enable: in std_logic;
 --          reset : in std_logic);
 --end component ;

  
  signal clk : std_logic := '0';            -- clk
  signal rst : std_logic := '0';
  signal output : std_logic_vector(n-1 downto 0);  -- output
begin  -- test
-- purpose: generate clk
-- type   : combinational
-- inputs : clk
-- outputs: output

user: 
entity work.counter(basic) 
   port map (rst => rst, clk => clk, o => output);
  
  process 
  begin  -- process
    clk<=not clk;
    wait for half_period;
  end process;
  
process
    begin
      wait for 5 ns; rst  <= '1';
      wait for 4 ns; rst  <= '0';
      
      wait;
 end process;

monitor : process (clk)
    variable c_str : line;
    begin
    if (clk = '1' and clk'event) then
        write(c_str, output);
        assert false report time'image(now) & 
          ": Current Count Value : " & c_str.all
        severity note;
        deallocate(c_str);
      end if;
    end process monitor;
   
end test;
