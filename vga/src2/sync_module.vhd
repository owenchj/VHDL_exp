library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity sync_module is
  port (
    clk    : in std_logic;
    rstn   : in std_logic;
    hsync  : out std_logic;
    vsync  : out std_logic;
    qc1    : out std_logic_vector(10 downto 0);
    qc2    : out std_logic_vector(9 downto 0)
    );

end entity;



architecture behavior of sync_module is
  signal c1    :  std_logic_vector(10 downto 0);
  signal c2    :  std_logic_vector(9 downto 0);
  signal rh    :  std_logic;
  signal rv    :  std_logic;


begin

  process(clk)
  begin
    if rising_edge(clk) then
      if rstn = '0' then
        c1 <= (others => '0');
        c2 <= (others => '0');
        rh <= '1';
        rv <= '1';
      else
        if unsigned(c1) = 1056 then
          rh <= '0';
        elsif unsigned(c1) = 128 then
          rh <= '1';
        end if;

        if unsigned(c2) = 628 then
          rv <= '0';
        elsif unsigned(c2) = 4 then
          rv <= '1';
        end if;
        
        if unsigned(c2) = 628 then
          c2 <= "00" & x"01";
        elsif unsigned(c1) = 1056 then
          c2 <= c2 + "1";
        end if;
        
        
        if unsigned(c1) = 1056 then
          c1 <=  "000" & x"01";
        else
          c1 <= c1 + "1";
        end if;
        
      end if;
    end if;
  end process;


  qc1 <= c1;
  qc2 <= c2;
  hsync <= rh;
  vsync <= rv;
end architecture;
