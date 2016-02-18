library ieee;
use ieee.std_logic_1164.all;


entity tb_exp5_env is
  
  generic (
    half_period : time := 20 ns
    );

  
end entity;

architecture behavior of tb_exp5_env is

  signal    clk          :  std_logic := '0';
  signal    rstn         :  std_logic := '0';
  signal    start_sig    :  std_logic := '0';
  signal    done_sig     :  std_logic := '0';
  signal    write_en_sig :  std_logic := '0';
  signal    rom_data     :  std_logic_vector(7 downto 0);
  signal    ram_addr     :  std_logic_vector(3 downto 0);
  signal    sq_rom_addr  :  std_logic_vector(3 downto 0);
  signal    i            :  std_logic := '0';
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
    wait for 100 * half_period;
    rstn <= '1';
    wait for 100000 * half_period;
    
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if rstn = '0' then
        i <= '0';
        start_sig <= '0';
      else
        case i is
          when '0' =>
            if done_sig = '1' then
              start_sig <= '0';
              i <= '1';
            else 
              start_sig <= '1';
            end if;
          when '1' =>
            i <= '1';
          when others => null;
        end case;
      end if;
    end if;
  end process;

  -- you can change your modules here:
  time: entity work.exp5_env(behavior)
    port map(
      clk          => clk,
      rstn         => rstn,
      start_sig    => start_sig,
      done_sig     => done_sig,
      write_en_sig => write_en_sig,
      rom_data     => rom_data,
      ram_addr     => ram_addr,
      sq_rom_addr  => sq_rom_addr
      );

end architecture;
