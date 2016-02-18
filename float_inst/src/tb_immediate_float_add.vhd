library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
entity tb_immediate_float_add is 

  generic (
    half_period : time := 2 ns
    );

end entity;

architecture behavior of tb_immediate_float_add is 
  signal clk         :  std_logic := '0';  
  signal rstn        :  std_logic := '0';
  signal a           :  std_logic_vector(31 downto 0);
  signal b           :  std_logic_vector(31 downto 0);
  signal result      :  std_logic_vector(31 downto 0);
  signal error_out   :  std_logic_vector(2 downto 0);
  signal sq_a_out_t0, sq_b_out_t0           : std_logic_vector(56 downto 0);
  signal sq_exp_out_t1, sq_expdiff_out_t1   : std_logic_vector(9 downto 0);
  signal sq_a_out_t2, sq_b_out_t2           : std_logic_vector(56 downto 0);
  signal sq_tempa_out_t3, sq_tempb_out_t3   : std_logic_vector(48 downto 0);
  signal sq_issign_out_t4  : std_logic;
  signal sq_exp_out_t4     : std_logic_vector(9 downto 0);
  signal sq_temp_out_t4    : std_logic_vector(48 downto 0);
  signal sq_exp_out_t5     : std_logic_vector(9 downto 0);
  signal sq_temp_out_t5    : std_logic_vector(48 downto 0);

  signal i   :  std_logic_vector(3 downto 0);

begin

  process
  begin  -- process
    clk<=not clk;
    wait for half_period;
  end process;

  

  process
  begin  -- process
    wait for 5 * half_period;
    rstn <= '0';
    wait for 10 * half_period;
    rstn <= '1';

    wait for 10000* half_period;
    
  end process;



  process(clk)
  begin
    if rising_edge(clk) then
      if rstn = '0' then
        a         <= (others => '0');
        b         <= (others => '0');
        i         <= x"0";
      else
        case i is
          -- a=3.65 b= -7.4
          when x"0" =>
            a <= '0' & "10000000" & "11010011001100110011010";
            b <= '1' & "10000001" & "11011001100110011001101";
            i <= i + "1";
          -- exp undeflow check
          when x"1" =>
            a <= '0' & "00000000" & "01010000101101000101101";
            b <= '1' & "00000000" & "00010000101100001000111";
            i <= i + "1";
          --a= 1.9999997, b= -1.9999998
          when x"2" =>
            a <= '0' & "01111111" & "11111111111111111111110";
            b <= '1' & "01111111" & "11111111111111111111111";
            i <= i + "1";
          --exp overflow
          when x"3" =>
            a <= '0' & "11111111" & "11111111111111111111111";
            b <= '0' & "11111111" & "11111111111111111111111";
            i <= i + "1";
          -- a= -12.558, b= -7.309
          when x"4" =>
            a <= '1' & "10000010" & "10010001110110110010001";
            b <= '1' & "10000001" & "11010011110001101010100";
            i <= i + "1";
          -- a= 111.7762, b= 302.4409
          when x"5" =>
            a <= '0' & "10000101" & "10111111000110101101010";
            b <= '0' & "10000111" & "00101110011100001101111";
            i <= i + "1";

          -- a= 2112.2012, b= -2002.2012
          when x"6" =>
            a <= '0' & "10001010" & "00001000000001100111000";
            b <= '1' & "10001001" & "11110100100011001110000";
            i <= i + "1";
            
          when x"7" =>
            i <= i;
            
            
          when others => null;
        end case;       
      end if;
    end if;
  end process;


  time: entity work.immediate_float_add_module(behavior)
    port map(
      a           => a,
      b           => b,
      result      => result,
      error_out   => error_out,      
      sq_a_out_t0 => sq_a_out_t0,
      sq_b_out_t0 => sq_b_out_t0,          
      sq_exp_out_t1      => sq_exp_out_t1,
      sq_expdiff_out_t1  => sq_expdiff_out_t1,
      sq_a_out_t2        => sq_a_out_t2,
      sq_b_out_t2        => sq_b_out_t2,
      sq_tempa_out_t3    => sq_tempa_out_t3,
      sq_tempb_out_t3    => sq_tempb_out_t3,
      sq_issign_out_t4   => sq_issign_out_t4,
      sq_exp_out_t4      => sq_exp_out_t4,
      sq_temp_out_t4     => sq_temp_out_t4,
      sq_exp_out_t5      => sq_exp_out_t5,
      sq_temp_out_t5     => sq_temp_out_t5
      );


end architecture;
