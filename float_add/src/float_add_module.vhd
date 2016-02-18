library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;


entity float_add_module is
  port (
    clk         : in std_logic;  
    rstn        : in std_logic;
    a           : in std_logic_vector(31 downto 0);
    b           : in std_logic_vector(31 downto 0);
    result      : out std_logic_vector(31 downto 0);
    start_sig   : in std_logic;
    done_sig    : out std_logic_vector(3 downto 0);

    sq_ra       : out std_logic_vector(56 downto 0);
    sq_rb       : out std_logic_vector(56 downto 0);
    sq_temp     : out std_logic_vector(48 downto 0);
    sq_tempa    : out std_logic_vector(48 downto 0);
    sq_tempb    : out std_logic_vector(48 downto 0);
    sq_rexp     : out std_logic_vector(9 downto 0);
    sq_rexpdiff : out std_logic_vector(7 downto 0)
    );

end float_add_module;



architecture behavior of float_add_module is

  signal  i            :  std_logic_vector(3 downto 0);
  signal  ra           :  std_logic_vector(56 downto 0);
  signal  rb           :  std_logic_vector(56 downto 0);
  signal  temp         :  std_logic_vector(48 downto 0);
  signal  tempa        :  std_logic_vector(48 downto 0);
  signal  tempb        :  std_logic_vector(48 downto 0);
  signal  rresult      :  std_logic_vector(31 downto 0);
  signal  rexp         :  std_logic_vector(9 downto 0);
  signal  rexpdiff     :  std_logic_vector(7 downto 0);
  signal  issign       :  std_logic;
  signal  isover       :  std_logic;
  signal  isunder      :  std_logic;
  signal  iszero       :  std_logic;
  signal  isdone       :  std_logic;
  
begin

  process(clk)
  begin
    if rising_edge(clk) then
      if rstn = '0' then
        i            <= x"0";
        ra           <= (others => '0');
        rb           <= (others => '0');
        temp         <= (others => '0');
        tempa        <= (others => '0');
        tempb        <= (others => '0');
        rresult      <= (others => '0');
        rexp         <= (others => '0');
        rexpdiff     <= (others => '0');
        issign       <= '0'; 
        isover       <= '0';
        isunder      <= '0';
        iszero       <= '0';
        isdone       <= '0';
      elsif start_sig = '1' then
        case i is
          -- initial a, b and other reg
          when x"0" =>
            ra <= a(31) & a(30 downto 23) & "01" & a(22 downto 0) & "000" & x"00000";
            rb <= b(31) & b(30 downto 23) & "01" & b(22 downto 0) & "000" & x"00000";
            isover   <= '0';
            isunder  <= '0';
            iszero   <= '0';
            i <= i + "1";
          -- if rexp[9..8] is 1, mean a.exp smaller than b.exp
          -- while rexp[9..8] is 0, mean a.exp larger than b.exp or is the same
          when x"1" =>
            rexp <= '0' & std_logic_vector(unsigned('0' & a(30 downto 23)) - unsigned('0' & b(30 downto 23)) ) ;
            i <= "1111";

          when x"f" =>
            if rexp(8) = '1' then
              rexpdiff <= not rexp(7 downto 0) + "1";
            else
              rexpdiff <= rexp(7 downto 0);
            end if;
            i <= "0010";
            
          -- if a < b; a.M move and a.E=b.E, else opposite act;
          when x"2" =>
            if rexp(8) = '1' then
              ra(47 downto 0) <= std_logic_vector(unsigned(ra(47 downto 0)) srl to_integer(unsigned(rexpdiff)));
              ra(55 downto 48) <= rb(55 downto 48);
            else
              rb(47 downto 0) <= std_logic_vector(unsigned(rb(47 downto 0)) srl to_integer(unsigned(rexpdiff)));
              rb(55 downto 48) <= ra(55 downto 48);
            end if;
            i <= i + "1";

          -- modify tempa and tempb with sign
          when x"3" =>
            if ra(56) = '1' then
              --tempa <= ra(56) & std_logic_vector(unsigned(not ra(47 downto 0)) + 1);
              tempa <= ra(56) & (not ra(47 downto 0) + "1");
            else
              tempa <= ra(56) & ra(47 downto 0) ;
            end if;
            
            if rb(56) = '1' then
              --tempb <= rb(56) & std_logic_vector(unsigned(not rb(47 downto 0)) + 1);
              tempb <= rb(56) & (not rb(47 downto 0) + "1");
            else
              tempb <= rb(56) & rb(47 downto 0) ;
            end if;
            
            
            -- tempa <= ra(56) & std_logic_vector(unsigned(not ra(47 downto 0)) + 1) when ra(56) = '1' else ra(56) & ra(47 downto 0) ;
            -- tempb <= rb(56) & std_logic_vector(unsigned(not rb(47 downto 0)) + 1) when rb(56) = '1' else rb(56) & rb(47 downto 0) ;
            i <= i + "1";
          -- addition
          when x"4" =>
            temp <= tempa + tempb; 
            i <= i + "1";

          -- modify result
          when x"5" =>
            issign <= temp(48);
            if temp(48) = '1' then
              temp <= not temp + "1";
            end if; 
            rexp <= "00" & ra(55 downto 48); -- or rb(55 downto 48)
            i <= i + "1";

          -- check M'hidden bit and modify to 2'b01
          when x"6" =>
            if temp(47 downto 46) = "10" or temp(47 downto 46) = "11" then
              temp <= std_logic_vector(unsigned(temp) srl 1);
              rexp <= rexp + "1";
            elsif temp(47 downto 46) = "00" and temp(45) = '1' then
              temp <= std_logic_vector(unsigned(temp) sll 1);
              rexp <= rexp - "1";
            elsif temp(47 downto 46) = "00" and temp(44) = '1' then
              temp <= std_logic_vector(unsigned(temp) sll 2);
              rexp <= rexp - "0000000010";
            elsif temp(47 downto 46) = "00" and temp(43) = '1' then
              temp <= std_logic_vector(unsigned(temp) sll 3);
              rexp <= rexp - "0000000011";
            elsif temp(47 downto 46) = "00" and temp(42) = '1' then
              temp <= std_logic_vector(unsigned(temp) sll 4);
              rexp <= rexp - "0000000100";
            elsif temp(47 downto 46) = "00" and temp(41) = '1' then
              temp <= std_logic_vector(unsigned(temp) sll 5);
              rexp <= rexp - "0000000101";
            elsif temp(47 downto 46) = "00" and temp(40) = '1' then
              temp <= std_logic_vector(unsigned(temp) sll 6);
              rexp <= rexp - "0000000110";
            elsif temp(47 downto 46) = "00" and temp(39) = '1' then
              temp <= std_logic_vector(unsigned(temp) sll 7);
              rexp <= rexp - "0000000111";
            elsif temp(47 downto 46) = "00" and temp(38) = '1' then
              temp <= std_logic_vector(unsigned(temp) sll 8);
              rexp <= rexp - "0000001000";
            elsif temp(47 downto 46) = "00" and temp(37) = '1' then
              temp <= std_logic_vector(unsigned(temp) sll 9);
              rexp <= rexp - "0000001001";
            elsif temp(47 downto 46) = "00" and temp(36) = '1' then
              temp <= std_logic_vector(unsigned(temp) sll 10);
              rexp <= rexp - "0000001010";
            elsif temp(47 downto 46) = "00" and temp(35) = '1' then
              temp <= std_logic_vector(unsigned(temp) sll 11);
              rexp <= rexp - "0000001011";
            elsif temp(47 downto 46) = "00" and temp(34) = '1' then
              temp <= std_logic_vector(unsigned(temp) sll 12);
              rexp <= rexp - "0000001100";
            elsif temp(47 downto 46) = "00" and temp(33) = '1' then
              temp <= std_logic_vector(unsigned(temp) sll 13);
              rexp <= rexp - "0000001101";
            elsif temp(47 downto 46) = "00" and temp(32) = '1' then
              temp <= std_logic_vector(unsigned(temp) sll 14);
              rexp <= rexp - "0000001110";
            elsif temp(47 downto 46) = "00" and temp(31) = '1' then
              temp <= std_logic_vector(unsigned(temp) sll 15);
              rexp <= rexp - "0000001111";
            elsif temp(47 downto 46) = "00" and temp(30) = '1' then
              temp <= std_logic_vector(unsigned(temp) sll 16);
              rexp <= rexp - "0000010000";
            elsif temp(47 downto 46) = "00" and temp(29) = '1' then
              temp <= std_logic_vector(unsigned(temp) sll 17);
              rexp <= rexp - "0000010001";
            elsif temp(47 downto 46) = "00" and temp(28) = '1' then
              temp <= std_logic_vector(unsigned(temp) sll 18);
              rexp <= rexp - "0000010010";
            elsif temp(47 downto 46) = "00" and temp(27) = '1' then
              temp <= std_logic_vector(unsigned(temp) sll 19);
              rexp <= rexp - "0000010011";
            elsif temp(47 downto 46) = "00" and temp(26) = '1' then
              temp <= std_logic_vector(unsigned(temp) sll 20);
              rexp <= rexp - "0000010100";
            elsif temp(47 downto 46) = "00" and temp(25) = '1' then
              temp <= std_logic_vector(unsigned(temp) sll 21);
              rexp <= rexp - "0000010101";
            elsif temp(47 downto 46) = "00" and temp(24) = '1' then
              temp <= std_logic_vector(unsigned(temp) sll 22);
              rexp <= rexp - "0000010110";
            elsif temp(47 downto 46) = "00" and temp(23) = '1' then
              temp <= std_logic_vector(unsigned(temp) sll 23);
              rexp <= rexp - "0000010111";
            end if;
            i <= i + "1";

          when x"7" =>
            if rexp(9 downto 8) = "01" then
              isover <= '1';
              rresult <= '0' & "01111111" & "000" & x"00000";
            elsif rexp(9 downto 8) = "11" then
              isunder <= '1';
              rresult <= '0' & "01111111" & "000" & x"00000";
            elsif temp(46 downto 23) = x"000000" then
              iszero <= '1';
              rresult <= '0' & "01111111" & "000" & x"00000";
            elsif temp(22) = '1' then
              rresult <= issign & rexp(7 downto 0) & (temp(45 downto 23) + "1"); 
            else
              rresult <= issign & rexp(7 downto 0) & temp(45 downto 23);
            end if ;
            i <= i + "1";
          when x"8" =>
            isdone <= '1';
            i <= i + "1";
          when x"9" =>
            isdone <= '0';
            i <= x"0";
          when others => null;
        end case;

      end if;
    end if;
  end process;

  done_sig <= isover & isunder & iszero & isdone;
  result <= rresult;
  sq_ra <= ra;
  sq_rb <= rb;
  sq_temp <= temp;
  sq_tempa <= tempa;
  sq_tempb <= tempb;
  sq_rexp <= rexp;
  sq_rexpdiff <= rexpdiff;
  
end architecture;
