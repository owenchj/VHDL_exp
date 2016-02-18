library ieee;
use ieee.std_logic_1164.all;


entity assign_seg is
  generic (
    s0 : std_logic_vector(6 downto 0) := "1000000";  --64
    s1 : std_logic_vector(6 downto 0) := "1111001";  --121
    s2 : std_logic_vector(6 downto 0) := "0100100";  --36
    s3 : std_logic_vector(6 downto 0) := "0110000";  --48
    s4 : std_logic_vector(6 downto 0) := "0011001";  --25
    s5 : std_logic_vector(6 downto 0) := "0010010";  --18
    s6 : std_logic_vector(6 downto 0) := "0000010";  --2
    s7 : std_logic_vector(6 downto 0) := "1111000";  --120
    s8 : std_logic_vector(6 downto 0) := "0000000";  --0
    s9 : std_logic_vector(6 downto 0) := "0010000"   --16
    );

  port(
    clk          : in std_logic;
    rstn         : in std_logic;
    seg_in       : in std_logic_vector(3 downto 0);
    seg_out      : out std_logic_vector(6 downto 0)
    );
end entity;


architecture behavior  of assign_seg is

begin  -- behavior 

  process(clk)
  begin
    if rising_edge(clk) then
      if rstn = '0' then
        seg_out <= "1111111";
      else
        case seg_in is
          when x"0" => seg_out <= s0;
          when x"1" => seg_out <= s1;
          when x"2" => seg_out <= s2;
          when x"3" => seg_out <= s3;
          when x"4" => seg_out <= s4;
          when x"5" => seg_out <= s5;
          when x"6" => seg_out <= s6;
          when x"7" => seg_out <= s7;
          when x"8" => seg_out <= s8;
          when x"9" => seg_out <= s9;
          when others => null;
        end case;
      end if;
    end if;
  end process;

end behavior ;
