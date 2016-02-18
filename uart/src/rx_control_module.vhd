library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_1164.all;

entity rx_control_module is
  port(CLK : in std_logic;
       RSTn : in std_logic;
       H2L_Sig : in std_logic;
       RX_Pin_In : in std_logic;
       BPS_CLK : in std_logic;
       RX_En_Sig : in std_logic;
       Count_Sig : out std_logic;
       RX_Data : out std_logic_vector(7 downto 0);
       RX_Done_Sig : out std_logic
       );
end rx_control_module;

architecture control of rx_control_module is
  signal i : std_logic_vector(3 downto 0) :=  x"0";
  signal rData : std_logic_vector(7 downto 0) := x"00";
  signal isCount : std_logic := '0';
  signal isDone : std_logic := '0';

begin
  
  process(CLK)
  begin
    if RSTn = '0' then
      i <= x"0";
      rData <= x"00";
      isCount <= '0';
      isDone <= '0';
    elsif RX_En_Sig = '1' then
      case i is
        when "0000" =>
          if H2L_Sig = '1' then
            i <= i + "1";
            isCount <= '1';
          end if;
        when "0001" =>
          if BPS_CLK = '1' then
            i <= i + "1";
          end if;
        when "0010"|"0011"|"0100"|"0101"|"0110"|"0111"|"1000"|"1001" =>
          if BPS_CLK = '1' then
            i <= i + "1";
            rData( to_integer(unsigned(i) - 2) ) <= RX_Pin_In;
          end if;
        when "1010" =>
          if BPS_CLK = '1' then
            i <= i + "1";
          end if;
        when "1011" =>
          if BPS_CLK = '1' then
            i <= i + "1";
          end if;
        when "1100" =>
          i <= i + "1";
          isDone <= '1';
          isCount <= '0';
        when "1101" =>      
          i <= x"0";
          isDone <= '0';
        when others =>
          i <= x"0";
          isDone <= '0';
      end case;
    end if;
  end process;

  Count_Sig <= isCount;
  RX_Data <= rData;
  RX_Done_Sig <= isDone;
  
end control;
