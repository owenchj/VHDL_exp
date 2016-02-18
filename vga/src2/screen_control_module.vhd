library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity screen_control_module is
  generic (
    xoff : integer := 16;
    yoff : integer := 30
    );
  port (
    clk       : in std_logic;
    rstn      : in std_logic;
    hp        : in std_logic_vector(7 downto 0);
    maxhp     : in std_logic_vector(7 downto 0);
    wren_sig  : out std_logic;
    wraddr    : out std_logic_vector(10 downto 0);
    wrdata    : out std_logic_vector(7 downto 0)
    );

end entity;

architecture behavior of screen_control_module is

  signal f1   :  std_logic_vector(7 downto 0);
  signal f2   :  std_logic_vector(7 downto 0);
  signal f3   :  std_logic_vector(7 downto 0);
  signal f4   :  std_logic_vector(7 downto 0);

  signal i      :  std_logic_vector(4 downto 0);
  signal go     :  std_logic_vector(4 downto 0);
  signal raddr  :  std_logic_vector(10 downto 0);
  signal rdata  :  std_logic_vector(7 downto 0);
  signal t1     :  std_logic_vector(7 downto 0);
  signal t2     :  std_logic_vector(7 downto 0);
  signal t3     :  std_logic_vector(7 downto 0);
  signal result :  std_logic_vector(7 downto 0);
  signal temp   :  std_logic_vector(15 downto 0);
  signal iswrite:  std_logic;

  signal xoff_t :  std_logic_vector(10 downto 0);
begin

  
  process(clk)
  begin
    if rising_edge(clk) then
      if rstn = '0' then
        f1 <= x"00";
        f2 <= x"00";
        f3 <= x"00";
        f4 <= x"00";
      else
        f1 <= hp;
        f2 <= f1;
        f3 <= maxhp;
        f4 <= f3;
      end if;
    end if;
  end process;



  xoff_t <= std_logic_vector(to_unsigned(xoff, raddr'length));
  
  process(clk)
  begin
    if rising_edge(clk) then
      if rstn = '0' then
        i       <= (others => '0'); 
        go      <= (others => '0'); 
        raddr   <= (others => '0'); 
        rdata   <= (others => '0'); 
        t1      <= (others => '0'); 
        t2      <= (others => '0'); 
        t3      <= (others => '0'); 
        result  <= (others => '0'); 
        temp    <= (others => '0'); 
        iswrite <= '0';
      else
        case i is
          -- compute hp/maxhp*96%
          when "00000" =>
            if f1 /= f2 or f3 /= f4 then
              t1 <= hp;
              t2 <= maxhp;
              t3 <= std_logic_vector(to_unsigned(96, t3'length));
              i <= i + "1";
            end if;
          -- compute hp*96
          when "00001" =>
            if t3 = x"00" then
              i <= i + "1";
            else
              temp <= temp + t1;
              t3 <= t3 - "1";
            end if;
          -- compute hp*96/maxhp
          when "00010" =>
            if temp < t2 then
              i <= i + "1";
            else
              temp <= temp - t2;
              result <= result + "1";
            end if;
          -- full 8 time hp-row
          when "00011"|"00100"|"00101"|"00110"|"00111"|"01000"|"01001"|"01010"  =>
            t1 <= result;
            t2 <= std_logic_vector( to_unsigned(yoff - 3 + to_integer(unsigned(i)) , t2'length));
            i <= std_logic_vector(to_unsigned(12, i'length));
            go <= i + "1";
          when "01011" =>
            i <= (others=>'0');
          when "01100"|"01101"|"01110"|"01111"|"10000"|"10001"|"10010"|"10011"|"10100"|"10101"|"10110"|"10111" =>
            if t1 >= x"08" then
              rdata <= x"ff";
              t1 <= t1 -x"08";
            elsif t1 = x"01" then
              rdata <= x"01";
              t1 <= x"00";
            elsif t1 = x"02" then
              rdata <= x"02";
              t1 <= x"00";
            elsif t1 = x"03" then
              rdata <= x"03";
              t1 <= x"00";
            elsif t1 = x"04" then
              rdata <= x"04";
              t1 <= x"00";
            elsif t1 = x"05" then
              rdata <= x"05";
              t1 <= x"00";
            elsif t1 = x"06" then
              rdata <= x"06";
              t1 <= x"00";
            elsif t1 = x"07" then
              rdata <= x"07";
              t1 <= x"00";
            else 
              rdata <= x"00";
            end if;
            iswrite <= '1';
            raddr <= t2 & x"0" + "000" & xoff_t(10 downto 3) + std_logic_vector(to_unsigned(to_integer(unsigned(i)) -12, raddr'length)) ;
            i <= i + 1;

          when "11000" =>
            iswrite <= '0';
            i <= go;
          when others => null;
        end case;
        
      end if;
    end if;
  end process;


  wren_sig <= iswrite;
  wrdata   <= rdata;
  wraddr   <= raddr;
end architecture;
