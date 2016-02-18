library ieee;
use ieee.std_logic_1164.all;


entity tb_shifter is
  
  generic (
    period : time := 1 ns;          -- frequence
    n : natural := 8
    );
end tb_shifter;


architecture test of tb_shifter is
  signal clk : std_logic := '0';
  signal reset : std_logic := '0';
  signal din : std_logic := '0';
  signal dout  : std_logic;
begin  -- test

  -- purpose: create clk
  -- type   : combinational
  -- inputs : 
  -- outputs: clk
  process
  begin  -- process
    clk <=not clk;
    wait for period;        
  end process;

  -- purpose: provide value
  -- type   : combinational
  -- inputs : 
  -- outputs: din
  process
  begin  -- process
    din <= '0';
    reset <= '1';
    wait for 5 * period;
    din <= '1';
    reset <= '0';
    wait for 3 * period;
    din <= '0';
    wait for 7 * period;
    din <= '1';
    wait for 3 * period;
    din <= '0';
    wait for 4 * period;
    din <= '1';
    
    wait;
  end process;

  shifter: entity work.shifter(basic) 
    port map(clk, reset, din, dout);
  
end test;





architecture test_n_bits of tb_shifter is
  signal clk : std_logic := '0';
 
  signal din : std_logic := '0';
  signal n_dout  : std_logic_vector(n-1 downto 0);
begin  -- test

  -- purpose: create clk
  -- type   : combinational
  -- inputs : 
  -- outputs: clk
  process
  begin  -- process
    clk <=not clk;
    wait for period;        
  end process;

  -- purpose: provide value
  -- type   : combinational
  -- inputs : 
  -- outputs: din
  process
  begin  -- process
    din <= '0';
  
    wait for 5 * period;
    din <= '1';
  
    wait for 3 * period;
    din <= '0';
    wait for 7 * period;
    din <= '1';
    wait for 3 * period;
    din <= '0';
    wait for 4 * period;
    din <= '1';
    
    wait;
  end process;

  n_shifter: entity work.n_shifter(bhv) 
    port map(clk, din, n_dout);
  
end architecture;
