library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;


entity tb_iic is
  generic (
    half_period : time := 20 ns
    );

end entity;

architecture behavior of tb_iic is 
  signal clk        : std_logic := '0';
  signal rstn       : std_logic := '0';
  signal scl        : std_logic := '0';
  signal sda        : std_logic := '0';

  signal rddata     : std_logic_vector(7 downto 0) := x"00";
  signal done_sig   : std_logic := '0';
  signal sq_i       : std_logic_vector(4 downto 0) := "00000";

  signal i          : std_logic_vector(3 downto 0) ;
  signal raddr      : std_logic_vector(7 downto 0) ;
  signal rdata      : std_logic_vector(7 downto 0) ;
  signal isstart    : std_logic_vector(1 downto 0) ;
  signal rled       : std_logic_vector(3 downto 0) ;

  


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
    wait for 15 * half_period;
    rstn <= '1';
    wait;
  end process;



  process(clk)
  begin  -- process

    if rising_edge(clk) then
      if rstn = '0'  then
        i          <= x"0";
        raddr      <= x"00";
        rdata      <= x"00";
        isstart    <= "00";
        rled       <= x"0";
      else
        case i is
          when x"0"  =>
            if done_sig = '1' then
              isstart <= "00";
              i <= i + "1";
            else
              isstart <= "01";
              rdata <= x"12";
              raddr <= x"00";
            end if;
          when x"1"  =>
            if done_sig = '1' then
              isstart <= "00";
              i <= i + "1";
            else
              isstart <= "10";
              raddr <= x"00";
            end if;
          when x"2"  =>
            rled <= rddata(3 downto 0);
          when others => null;
        end case;
      end if;
    end if;
  end process;


    
  time: entity work.iic_func_module(behavior)
    port map(
      clk        => clk,
      rstn       => rstn,
      start_sig  => isstart,
      addr_sig   => raddr,
      wrdata     => rdata,
      rddata     => rddata,
      done_sig   => done_sig,
      scl        => scl,
      sda        => sda,
      sq_i       => sq_i
      );


end architecture;

