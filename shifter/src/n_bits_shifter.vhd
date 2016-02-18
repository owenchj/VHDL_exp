library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;


entity n_shifter is
    generic (
        REGSIZE  : integer := 8);
    port(
        clk      : in  std_logic;
        Data_in  : in  std_logic;
        Data_out : out std_logic_vector(REGSIZE-1 downto 0)
          );
end n_shifter;

architecture bhv of n_shifter is
    signal shift_reg : std_logic_vector(REGSIZE-1 downto 0) := (others => '0');
begin
    process (clk) begin
        if rising_edge(clk) then
            shift_reg <= shift_reg(REGSIZE-2 downto 0) & Data_in;
        end if;
    end process;
    Data_out <= shift_reg;
end bhv;

