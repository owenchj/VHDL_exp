library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
entity task_checkhbit is
  port (
    exp_in         : in  std_logic_vector(9 downto 0);
    temp_in        : in  std_logic_vector(48 downto 0);
    exp_out        : out std_logic_vector(9 downto 0);
    temp_out       : out std_logic_vector(48 downto 0)
    );
end entity;



architecture behavior of task_checkhbit is

  signal is1, is2, is3, is4, is5, is6, is7, is8, is9, is10, is11, is12, is13, is14, is15, is16, is17, is18, is19, is20, is21, is22, is23, is24, is25, is26 :    std_logic;
  signal temp1, temp2, temp3, temp4, temp5, temp6, temp7, temp8, temp9, temp10, temp11, temp12, temp13, temp14, temp15, temp16, temp17, temp18, temp19, temp20, temp21, temp22, temp23, temp24, temp25, temp26   :     std_logic_vector(48 downto 0);
  signal two_zero  : std_logic;
  signal exp1, exp2, exp3, exp4, exp5, exp6, exp7, exp8, exp9, exp10, exp11, exp12, exp13, exp14, exp15, exp16, exp17, exp18, exp19, exp20, exp21, exp22, exp23, exp24, exp25, exp26 : std_logic_vector(9 downto 0);
  signal temp : std_logic_vector(48 downto 0);
  signal exp  : std_logic_vector(9 downto 0);

begin

  two_zero <= '1' when  temp_in(47 downto 46) = "00" else '0';
  
  is1 <= '1' when temp_in(47 downto 46) = "10" or temp_in(47 downto 46) = "11" else '0';
  is2 <= two_zero and temp_in(45);
  is3 <= two_zero and temp_in(44);
  is4 <= two_zero and temp_in(43);
  is5 <= two_zero and temp_in(42);
  is6 <= two_zero and temp_in(41);
  is7 <= two_zero and temp_in(40);
  is8 <= two_zero and temp_in(39);
  is9 <= two_zero and temp_in(38);
  is10 <= two_zero and temp_in(37);
  is11 <= two_zero and temp_in(36);
  is12 <= two_zero and temp_in(35);
  is13 <= two_zero and temp_in(34);
  is14 <= two_zero and temp_in(33);
  is15 <= two_zero and temp_in(32);
  is16 <= two_zero and temp_in(31);
  is17 <= two_zero and temp_in(30);
  is18 <= two_zero and temp_in(29);
  is19 <= two_zero and temp_in(28);
  is20 <= two_zero and temp_in(27);
  is21 <= two_zero and temp_in(26);
  is22 <= two_zero and temp_in(25);
  is23 <= two_zero and temp_in(24);
  is24 <= two_zero and temp_in(23);
  is25 <= '1' when temp_in(47 downto 46) = "01" else '0';
  is26 <= '1' when two_zero = '1' and temp_in(45 downto 23) = x"00000" & "000" else '0';

  temp1 <= std_logic_vector(unsigned(temp_in) srl 1);
  temp2 <= std_logic_vector(unsigned(temp_in) sll 1);
  temp3 <= std_logic_vector(unsigned(temp_in) sll 2);
  temp4 <= std_logic_vector(unsigned(temp_in) sll 3);
  temp5 <= std_logic_vector(unsigned(temp_in) sll 4);
  temp6 <= std_logic_vector(unsigned(temp_in) sll 5);
  temp7 <= std_logic_vector(unsigned(temp_in) sll 6);
  temp8 <= std_logic_vector(unsigned(temp_in) sll 7);
  temp9 <= std_logic_vector(unsigned(temp_in) sll 8);
  temp10 <= std_logic_vector(unsigned(temp_in) sll 9);
  temp11 <= std_logic_vector(unsigned(temp_in) sll 10);
  temp12 <= std_logic_vector(unsigned(temp_in) sll 11);
  temp13 <= std_logic_vector(unsigned(temp_in) sll 12);
  temp14 <= std_logic_vector(unsigned(temp_in) sll 13);
  temp15 <= std_logic_vector(unsigned(temp_in) sll 14);
  temp16 <= std_logic_vector(unsigned(temp_in) sll 15);
  temp17 <= std_logic_vector(unsigned(temp_in) sll 16);
  temp18 <= std_logic_vector(unsigned(temp_in) sll 17);
  temp19 <= std_logic_vector(unsigned(temp_in) sll 18);
  temp20 <= std_logic_vector(unsigned(temp_in) sll 19);
  temp21 <= std_logic_vector(unsigned(temp_in) sll 20);
  temp22 <= std_logic_vector(unsigned(temp_in) sll 21);
  temp23 <= std_logic_vector(unsigned(temp_in) sll 22);
  temp24 <= std_logic_vector(unsigned(temp_in) sll 23);
  temp25 <= temp_in;
  temp26 <= temp_in;

  exp1   <= exp_in + "1";
  exp2   <= exp_in - "00001";
  exp3   <= exp_in - "00010";
  exp4   <= exp_in - "00011"; 
  exp5   <= exp_in - "00100";
  exp6   <= exp_in - "00101";
  exp7   <= exp_in - "00110";
  exp8   <= exp_in - "00111";
  exp9   <= exp_in - "01000";
  exp10   <= exp_in - "01001";
  exp11   <= exp_in - "01010";
  exp12   <= exp_in - "01011";
  exp13   <= exp_in - "01100";
  exp14   <= exp_in - "01101";
  exp15   <= exp_in - "01110";
  exp16   <= exp_in - "01111";
  exp17   <= exp_in - "10000";
  exp18   <= exp_in - "10001";
  exp19   <= exp_in - "10010";
  exp20   <= exp_in - "10011";
  exp21   <= exp_in - "10100";
  exp22   <= exp_in - "10101";
  exp23   <= exp_in - "10110";
  exp24   <= exp_in - "10111";
  exp25   <= exp_in;
  exp26   <= exp_in;

  process(is1,is2,is3,is4,is5,is6,is7,is8,is9,is10,is11,is12,is13,is14,is15,is16,is17,is18,is19,is20,is21,is22,is23,is24, is25, is26, exp_in, temp_in)
  begin
    if is1 = '1' then
      temp <= temp1; exp <= exp1;
    elsif is2 = '1' then
      temp <= temp2; exp <= exp2;
    elsif is3 = '1' then
      temp <= temp3; exp <= exp3;
    elsif is4 = '1' then
      temp <= temp4; exp <= exp4;
    elsif is5 = '1' then
      temp <= temp5; exp <= exp5;
    elsif is6 = '1' then
      temp <= temp6; exp <= exp6;
    elsif is7 = '1' then
      temp <= temp7; exp <= exp7;
    elsif is8 = '1' then
      temp <= temp8; exp <= exp8;
    elsif is9 = '1' then
      temp <= temp9; exp <= exp9;
    elsif is10 = '1' then
      temp <= temp10; exp <= exp10;
    elsif is11 = '1' then
      temp <= temp11; exp <= exp11;
    elsif is12 = '1' then
      temp <= temp12; exp <= exp12;
    elsif is13 = '1' then
      temp <= temp13; exp <= exp13;
    elsif is14 = '1' then
      temp <= temp14; exp <= exp14;
    elsif is15 = '1' then
      temp <= temp15; exp <= exp15;
    elsif is16 = '1' then
      temp <= temp16; exp <= exp16;
    elsif is17 = '1' then
      temp <= temp17; exp <= exp17;
    elsif is18 = '1' then
      temp <= temp18; exp <= exp18;
    elsif is19 = '1' then
      temp <= temp19; exp <= exp19;
    elsif is20 = '1' then
      temp <= temp20; exp <= exp20;
    elsif is21 = '1' then
      temp <= temp21; exp <= exp21;
    elsif is22 = '1' then
      temp <= temp22; exp <= exp22;
    elsif is23 = '1' then
      temp <= temp23; exp <= exp23;
    elsif is24 = '1' then
      temp <= temp24; exp <= exp24;
    elsif is25 = '1' then
      temp <= temp25; exp <= exp25;
    elsif is26 = '1' then
      temp <= temp26; exp <= exp26;
    else
      temp <= (others => 'X'); exp <= (others => 'X');
    end if;
  end process;

  exp_out <= exp;
  temp_out <= temp;
end architecture;

