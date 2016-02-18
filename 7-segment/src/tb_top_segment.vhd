library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_top_segment is
  
  generic (
    half_period : time := 1 ns;          -- frequence
    n : natural := 8
    );
end entity;


architecture test of tb_top_segment is
  
  signal clk         : std_logic := '0';
  signal rstn        : std_logic := '1';
  signal date_time_n : std_logic := '0';
  signal adjust      : std_logic := '0';
  signal increament  : std_logic := '0';
  signal seg_5       : std_logic_vector(6 downto 0) :=(others => '1');
  signal seg_4       : std_logic_vector(6 downto 0) :=(others => '1');
  signal seg_3       : std_logic_vector(6 downto 0) :=(others => '1');
  signal seg_2       : std_logic_vector(6 downto 0) :=(others => '1');
  signal seg_1       : std_logic_vector(6 downto 0) :=(others => '1');
  signal seg_0       : std_logic_vector(6 downto 0) :=(others => '1');

begin  -- test

  process 
  begin  -- process
    clk<=not clk;
    wait for half_period;
  end process;

  process
  begin  -- process
    
    wait for 5 * half_period;
    rstn <= '0';
    date_time_n <= '0';
   
    
    wait for 5 * half_period;
    rstn <= '1'; 

    wait for 40000 * half_period;
    date_time_n <= '1';
    wait for 7 * half_period;




    adjust <= '1';                      -- mode 1
    wait for 20 * half_period;
    adjust <= '0';

    increament<= '1';
    wait for 20 * half_period;
    increament <= '0';
    wait for 20 * half_period;
    increament<= '1';
    wait for 20 * half_period;
    increament <= '0';
    wait for 20 * half_period;
    increament<= '1';
    wait for 20 * half_period;
    increament <= '0';
    wait for 20 * half_period;
    adjust <= '1';
    wait for 20 * half_period;
    adjust <= '0';
    wait for 20 * half_period;
    increament<= '1';
    wait for 20 * half_period;
    increament <= '0';
    
    adjust <= '1';                  -- mode 2
    wait for 20 * half_period;
    adjust <= '0';

    wait for 20 * half_period;

    adjust <= '1';                    -- mode 3
    wait for 20 * half_period;
    adjust <= '0';


    increament<= '1';
    wait for 20 * half_period;
    increament <= '0';
    wait for 20 * half_period;
    increament<= '1';
    wait for 20 * half_period;
    increament <= '0';
    wait for 20 * half_period;
    increament<= '1';
    wait for 20 * half_period;
    increament <= '0';
    wait for 20 * half_period;
    adjust <= '1';
    wait for 20 * half_period;
    adjust <= '0';
    wait for 20 * half_period;
    increament<= '1';
    wait for 20 * half_period;
    increament <= '0';
    
    adjust <= '1';                  -- mode 4
    wait for 20 * half_period;
    adjust <= '0';

    wait for 20 * half_period;

    adjust <= '1';                    -- mode 5
    wait for 20 * half_period;
    adjust <= '0';

    wait for 20 * half_period;
    
    adjust <= '1';                  -- mode 6
    wait for 20 * half_period;
    adjust <= '0';

    wait for 20 * half_period;

    adjust <= '1';                    -- mode 7
    wait for 20 * half_period;
    adjust <= '0';

    wait for 20 * half_period;
    
    adjust <= '1';                  -- mode 8
    wait for 20 * half_period;
    adjust <= '0';

    wait for 20 * half_period;

    adjust <= '1';                    -- mode 9
    wait for 20 * half_period;
    adjust <= '0';

    wait for 20 * half_period;
    
    adjust <= '1';                    -- mode 10
    wait for 20 * half_period;
    adjust <= '0';

    wait for 20 * half_period;
    
    adjust <= '1';                    -- mode 11
    wait for 20 * half_period;
    adjust <= '0';

    wait for 20 * half_period;
    
    --adjust <= '1';                    -- mode 12
    --wait for 20 * half_period;
    --adjust <= '0';

    --wait for 20 * half_period;

    --adjust <= '1';                    -- mode 0
    --wait for 20 * half_period;
    --adjust <= '0';
    
    date_time_n <= '0';


    
    wait;
  end process;

  time: entity work.top_segment(behavior) 
    port map(
      clk          => clk, 
      rstn         => rstn,
      date_time_n  => date_time_n,
      adjust       => adjust,
      increament   => increament,
      seg_5        => seg_5,
      seg_4        => seg_4,
      seg_3        => seg_3,
      seg_2        => seg_2,
      seg_1        => seg_1,
      seg_0        => seg_0
      );

end test;
