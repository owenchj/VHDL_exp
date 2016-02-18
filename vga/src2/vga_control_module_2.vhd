library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity vga_control_module_2 is
  generic (
    x_i   : integer := 128;
    y_i   : integer := 128;
    x_off : integer := 128;
    y_off : integer := 0
    );
  
  port (
    clk       : in std_logic;
    rstn      : in std_logic;
    qc1       : in std_logic_vector(10 downto 0);
    qc2       : in std_logic_vector(9 downto 0);
    rgb_sig   : out std_logic_vector(2 downto 0);
    rom_data  : in std_logic_vector(7 downto 0);
    rom_addr  : out std_logic_vector(10 downto 0)
    );

end entity;



architecture behavior of vga_control_module_2 is
  signal x     :  std_logic_vector(6 downto 0);
  signal x_a   :  std_logic_vector(10 downto 0);
  signal y     :  std_logic_vector(6 downto 0);
  signal y_a   :  std_logic_vector(9 downto 0);
  signal n1    :  std_logic_vector(2 downto 0);
  signal n2    :  std_logic_vector(2 downto 0);
  signal raddr :  std_logic_vector(10 downto 0);
  signal rrgb  :  std_logic_vector(2 downto 0);
  signal r     :  std_logic;
  signal g     :  std_logic;
  signal b     :  std_logic;
  
begin
  r <= rom_data(to_integer(unsigned(n2)));
  g <= rom_data(to_integer(unsigned(n2)));
  b <= rom_data(to_integer(unsigned(n2)));
  x <= x_a(6 downto 0);
  y <= y_a(6 downto 0);

  process(clk)
  begin
    if rising_edge(clk) then
      if rstn = '0' then
        x_a <= (others => '0');
        y_a <= (others => '0');
        n1 <= (others => '0');
        n2 <= (others => '0');
        raddr <= (others => '0');
        rrgb <= (others => '0');
      else
        if (unsigned(qc1) > (128 + 88 + x_off) and unsigned(qc1) <= (128 + 88 + x_off + x_i)  )   and (unsigned(qc2) > (4 + 23 + y_off) and unsigned(qc2) <= (4 + 23 + y_off + y_i)  ) then
          x_a <=  std_logic_vector(unsigned(qc1) - x_off - 128 -88 -1);
          y_a <=  std_logic_vector(unsigned(qc2) - y_off -  4 - 23 -1) ;
          -- 128 * 128, 16 * 8 bits
          raddr <= y & x"0" + x(6 downto 3);
          n1 <= x(2 downto 0);
        else
          n1 <= "000";
          raddr <= "00000010001";
        end if;
        
        n2 <= n1;
        rrgb <= r & g & b;
      end if;
    end if;
  end process;

  rgb_sig <= rrgb;
  rom_addr <= raddr;
end architecture;
