library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;


entity iic_func_module is

  generic(
    F100K : integer := 200
    );
  
  port(
    clk        : in std_logic;
    rstn       : in std_logic;
    start_sig  : in std_logic_vector(1 downto 0);
    addr_sig   : in std_logic_vector(7 downto 0);
    wrdata     : in std_logic_vector(7 downto 0);
    rddata     : out std_logic_vector(7 downto 0);
    done_sig   : out std_logic;
    scl        : out std_logic;
    sda        : inout std_logic;
    sq_i       : out std_logic_vector(4 downto 0)
    );

end entity;



architecture behavior of iic_func_module is
  signal i      : std_logic_vector(4 downto 0);
  signal go     : std_logic_vector(4 downto 0);
  signal c1     : std_logic_vector(8 downto 0);
  signal rdata  : std_logic_vector(7 downto 0);
  signal rscl   : std_logic;
  signal rsda   : std_logic;
  signal isack  : std_logic;
  signal isdone : std_logic;
  signal isout  : std_logic;

begin

  process(clk)
  begin
    if rising_edge(clk) then
      if rstn = '0' then
        i      <= "00000";
        go     <= "00000";
        c1     <= (others => '0');
        rdata  <= x"00";
        rscl   <= '1';
        rsda   <= '1';
        isack  <= '1';
        isdone <= '0';
        isout  <= '1';
      elsif start_sig(0)='1' then
        case i is
          -- start
          when "00000" =>
            isout <= '1';
            if unsigned(c1) = 0 then
              rscl <= '1';
            elsif unsigned(c1) = 200 then
              rscl <= '0';
            end if;

            if unsigned(c1) = 0 then
              rsda <= '1';
            elsif unsigned(c1) = 100 then
              rsda <= '0';
            end if;

            if unsigned(c1) = 250 - 1 then
              c1 <= (others => '0');
              i <= i + "1";
            else
              c1 <= c1 + "1";
            end if;
          -- write device addr
          when "00001" =>
            rdata <= "1010" & "000" & '0';
            i <= "00111";
            go <= i + "1";
          -- write word addr 
          when "00010" =>
            rdata <= addr_sig;
            i <= "00111";
            go <= i + "1";
          -- write data
          when "00011" =>
            rdata <= wrdata;
            i <= "00111";
            go <= i + "1";

          -- stop
          when "00100" =>
            isout <= '1';
            if unsigned(c1) = 0 then
              rscl <= '0';
            elsif unsigned(c1) = 50 then
              rscl <= '1';
            end if;

            if unsigned(c1) = 0 then
              rsda <= '0';
            elsif unsigned(c1) = 150 then
              rsda <= '1';
            end if;

            if unsigned(c1) = 250 - 1 then
              c1 <= (others => '0');
              i <= i + "1";
            else
              c1 <= c1 + "1";
            end if;
            
          when "00101" =>
            isdone <= '1';
            i <= i + "1";

          when "00110" =>
            isdone <= '0';
            i <= "00000";

          when "00111"|"01000"|"01001"|"01010"|"01011"|"01100"|"01101"|"01110" =>
            isout <= '1';

            rsda <= rdata(14 - to_integer(unsigned(i)));
            
            if unsigned(c1) = 0 then
              rscl <= '0';
            elsif unsigned(c1) = 50 then
              rscl <= '1';
            elsif unsigned(c1) = 150 then
              rscl <= '0';
            end if;

            if unsigned(c1) = F100K - 1 then
              c1 <= (others => '0');
              i <= i + "1";
            else
              c1 <= c1 + "1";
            end if;

          when "01111" =>
            isout <= '0';

            if unsigned(c1) = 100 then
              isack <= sda;
            end if;
            
            if unsigned(c1) = 0 then
              rscl <= '0';
            elsif unsigned(c1) = 50 then
              rscl <= '1';
            elsif unsigned(c1) = 150 then
              rscl <= '0';
            end if;

            if unsigned(c1) = F100K - 1 then
              c1 <= (others => '0');
              i <= i + "1";
            else
              c1 <= c1 + "1";
            end if;

          when "10000" =>
            if isack /= '0' then
              i <= "00000";
            else
              i <= go;
            end if;
            
          when others => null;
        end case;
        
      elsif start_sig(1)='1' then
        case i is
          -- start
          when "00000" =>
            isout <= '1';
            if unsigned(c1) = 0 then
              rscl <= '1';
            elsif unsigned(c1) = 200 then
              rscl <= '0';
            end if;

            if unsigned(c1) = 0 then
              rsda <= '1';
            elsif unsigned(c1) = 100 then
              rsda <= '0';
            end if;

            if unsigned(c1) = 250 - 1 then
              c1 <= (others => '0');
              i <= i + "1";
            else
              c1 <= c1 + "1";
            end if;
          -- write device addr
          when "00001" =>
            rdata <= "1010" & "000" & '0';
            i <= "01001";
            go <= i + "1";
          -- write word addr 
          when "00010" =>
            rdata <= addr_sig;
            i <= "01001";
            go <= i + "1";

          -- restart
          when "00011" =>
            isout <= '1';
            if unsigned(c1) = 0 then
              rscl <= '0';
            elsif unsigned(c1) = 50 then
              rscl <= '1';
            elsif unsigned(c1) = 250 then
              rscl <= '0';
            end if;

            if unsigned(c1) = 0 then
              rsda <= '0';
            elsif unsigned(c1) = 50 then
              rsda <= '1';
            elsif unsigned(c1) = 150 then
              rsda <= '0';
            end if;

            if unsigned(c1) = 300 - 1 then
              c1 <= (others => '0');
              i <= i + "1";
            else
              c1 <= c1 + "1";
            end if;
          -- write device addr
          when "00100" =>
            rdata <= "1010" & "000" & '1';
            i <= "01001";
            go <= i + "1";
          -- write word addr 
          when "00101" =>
            rdata <= x"00";
            i <= "10011";
            go <= i + "1";
          -- stop
          when "00110" =>
            isout <= '1';
            if unsigned(c1) = 0 then
              rscl <= '0';
            elsif unsigned(c1) = 50 then
              rscl <= '1';
            end if;

            if unsigned(c1) = 0 then
              rsda <= '0';
            elsif unsigned(c1) = 150 then
              rsda <= '1';
            end if;

            if unsigned(c1) = 250 - 1 then
              c1 <= (others => '0');
              i <= i + "1";
            else
              c1 <= c1 + "1";
            end if;
            
          when "00111" =>
            isdone <= '1';
            i <= i + "1";

          when "01000" =>
            isdone <= '0';
            i <= "00000";

          when "01001"|"01010"|"01011"|"01100"|"01101"|"01110"|"01111"|"10000" =>
            isout <= '1';

            rsda <= rdata(16 - to_integer(unsigned(i)));
            
            if unsigned(c1) = 0 then
              rscl <= '0';
            elsif unsigned(c1) = 50 then
              rscl <= '1';
            elsif unsigned(c1) = 150 then
              rscl <= '0';
            end if;

            if unsigned(c1) = F100K - 1 then
              c1 <= (others => '0');
              i <= i + "1";
            else
              c1 <= c1 + "1";
            end if;

          when "10001" =>
            isout <= '0';

            if unsigned(c1) = 100 then
              isack <= sda;
            end if;
            
            if unsigned(c1) = 0 then
              rscl <= '0';
            elsif unsigned(c1) = 50 then
              rscl <= '1';
            elsif unsigned(c1) = 150 then
              rscl <= '0';
            end if;

            if unsigned(c1) = F100K - 1 then
              c1 <= (others => '0');
              i <= i + "1";
            else
              c1 <= c1 + "1";
            end if;
            
          when "10010" =>
            if isack /= '0' then
              i <= "00000";
            else
              i <= go;
            end if;

          when "10011"|"10100"|"10101"|"10110"|"10111"|"11000"|"11001"|"11010" =>
            isout <= '0';

            if unsigned(c1) = 100 then
              rdata(26-to_integer(unsigned(i))) <= sda;
            end if;
            
            if unsigned(c1) = 0 then
              rscl <= '0';
            elsif unsigned(c1) = 50 then
              rscl <= '1';
            elsif unsigned(c1) = 150 then
              rscl <= '0';
            end if;

            if unsigned(c1) = F100K - 1 then
              c1 <= (others => '0');
              i <= i + "1";
            else
              c1 <= c1 + "1";
            end if;

          when "11011" =>
            isout <= '1';

            if unsigned(c1) = 100 then
              isack <= sda;
            end if;
            
            if unsigned(c1) = 0 then
              rscl <= '0';
            elsif unsigned(c1) = 50 then
              rscl <= '1';
            elsif unsigned(c1) = 150 then
              rscl <= '0';
            end if;

            if unsigned(c1) = F100K - 1 then
              c1 <= (others => '0');
              i <= i + "1";
            else
              c1 <= c1 + "1";
            end if;
          when others => null;
        end case;
        
      end if;
    end if;
  end process;

  done_sig <= isdone;
  rddata <= rdata;
  scl <= rscl;
  sda <= rsda when isout = '1' else 'Z';

  sq_i <= i;

end architecture;
