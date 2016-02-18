library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity hour_minute_second is
  generic(
    times  : integer := 3 - 1;
    length : integer := integer(ceil(log2(real(3))))
    );
  --generic(
  --  times  : integer := 50000000 - 1;
  --  length : integer := integer(ceil(log2(real(50000000))))
  --  );

  port(
    clk            : in std_logic;
    rstn           : in std_logic;
    add_a_day      : out std_logic;
    increament     : in std_logic;
    mode           : in std_logic_vector(3 downto 0);
    hour           : out std_logic_vector(5 downto 0);
    minute         : out std_logic_vector(6 downto 0);
    second         : out std_logic_vector(6 downto 0)
    );
end entity;


architecture behavior  of hour_minute_second is

  signal add_a_minute    : std_logic;
  signal add_a_hour      : std_logic;
  signal add_a_second    : std_logic;
  signal add_a_second_a  : std_logic;
  signal add_a_second_m  : std_logic;
  signal counter         : std_logic_vector(length - 1 downto 0);

  component create_hour is
    port(
      clk            : in std_logic;
      rstn           : in std_logic;
      increament     : in std_logic;
      add_a_day      : out std_logic;
      add_a_hour     : in std_logic;
      mode           : in std_logic_vector(3 downto 0);
      hour           : out std_logic_vector(5 downto 0)
      );
  end component;

  component create_minute is
    port(
      clk            : in std_logic;
      rstn           : in std_logic;
      add_a_minute   : in std_logic;
      increament     : in std_logic;
      add_a_hour     : out std_logic;
      mode           : in std_logic_vector(3 downto 0);
      minute         : out std_logic_vector(6 downto 0)
      );
  end component;

  component create_second is
    port(
      clk            : in std_logic;
      rstn           : in std_logic;
      add_a_minute   : out std_logic;
      increament     : in std_logic;
      add_a_second   : in std_logic;
      mode           : in std_logic_vector(3 downto 0);
      second         : out std_logic_vector(6 downto 0)
      );
  end component;

begin 


  add_a_second <= add_a_second_a or add_a_second_m;
    
  process(counter, mode)
  begin
    if mode = x"0" and (unsigned(counter) = times - 1) then 
      add_a_second_m  <= '1';    
    else
      add_a_second_m  <= '0';    
    end if;
  end process;

  process(clk)
  begin
    if rising_edge(clk) then
      if rstn = '0' then
        add_a_second_a <= '0';
      else

        if add_a_second_a = '1'then
          add_a_second_a  <= '0';
        end if;
        
        if mode = x"6" then
          if increament = '1' then
            add_a_second_a  <= '1';
          end if;
        end if;

      end if;
    end if;
  end process;

  p0: process(clk)
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
  end process p0;
  

  U0: create_hour port map(
    clk            => clk,
    rstn           => rstn,
    add_a_day      => add_a_day,
    increament     => increament,
    add_a_hour     => add_a_hour,
    mode           => mode,
    hour           => hour
    );


U1: create_minute port map(
  clk            => clk,
  rstn           => rstn,
  add_a_minute   => add_a_minute,
  increament     => increament,
  add_a_hour     => add_a_hour,
  mode           => mode,
  minute         => minute
  );


U2: create_second port map(
  clk            => clk,
  rstn           => rstn,
  add_a_minute   => add_a_minute,
  increament     => increament,
  add_a_second   => add_a_second,
  mode           => mode,
  second         => second
  );

end architecture;
