library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;


entity adjust_date_time is
  port(
    clk           : in std_logic;
    rstn          : in std_logic;
    adjust        : in std_logic;
    increament    : in std_logic;
    mode          : out std_logic_vector(3 downto 0);
    increament_m  : out std_logic
    );
end entity;


architecture behavior of adjust_date_time is

  signal mode_m        : std_logic_vector(3 downto 0);
  signal adjust_n      : std_logic;
  signal increament_n  : std_logic;
  signal adjust_m      : std_logic;

  component no_jiter is
    port(
      clk           : in std_logic;
      rstn          : in std_logic;
      in_sig        : in std_logic;
      out_sig       : out std_logic
      );
  end component;
  
begin

  mode         <= mode_m;
  adjust_n     <= not adjust;
  increament_n <= not increament;
  
  U0: no_jiter port map(
    clk      => clk,
    rstn     => rstn,
    in_sig   => adjust_n,
    out_sig  => adjust_m
    );

  U1: no_jiter port map(
    clk      => clk,
    rstn     => rstn,
    in_sig   => increament_n,
    out_sig  => increament_m
    ); 

-- mode counter to change the mode
  process(clk)
  begin
    if rising_edge(clk) then
      if rstn = '0' then
        mode_m <= x"0";
      else
        if adjust_m = '1' then
          if mode_m = x"6" then
            mode_m <= x"0";
          else
            mode_m <= mode_m + "1";
          end if;
        end if;
        
      end if;
    end if;
  end process;


end architecture;
