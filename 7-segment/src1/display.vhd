--module dislpay{
--                    input clk;
--                    input rstn;
--                    input [7:0] seg_h;
--                    input [6:0] seg_m;
--                    input [6:0] seg_l;
--                    output [6:0] seg_5;
--                    output [6:0] seg_4;
--                    output [6:0] seg_3;
--                    output [6:0] seg_2;
--                    output [6:0] seg_1;
--                    output [6:0] seg_1 
--                  };   
library ieee;
use ieee.std_logic_1164.all;

entity display is
  port(
    clk         : in std_logic;
    rstn        : in std_logic;
    seg_h       : in std_logic_vector(7 downto 0);
    seg_m       : in std_logic_vector(7 downto 0);
    seg_l       : in std_logic_vector(7 downto 0);
    seg_5       : out std_logic_vector(6 downto 0);
    seg_4       : out std_logic_vector(6 downto 0);
    seg_3       : out std_logic_vector(6 downto 0);
    seg_2       : out std_logic_vector(6 downto 0);
    seg_1       : out std_logic_vector(6 downto 0);
    seg_0       : out std_logic_vector(6 downto 0)
    );
end entity;


architecture behavior  of display is
  component assign_seg 
    Port(
      clk          : in std_logic;
      rstn         : in std_logic;
      seg_in       : in std_logic_vector(3 downto 0);
      seg_out      : out std_logic_vector(6 downto 0)
      );              
  end component;

begin  -- behavior 

  U0: assign_seg port map (
    clk => clk,
    rstn => rstn,
    seg_in => seg_h(7 downto 4),
    seg_out => seg_5
    );    
  
  U1: assign_seg port map (
    clk => clk,
    rstn => rstn,
    seg_in => seg_h(3 downto 0),
    seg_out => seg_4
    );    

  U2: assign_seg port map (
    clk => clk,
    rstn => rstn,
    seg_in => seg_m(7 downto 4),
    seg_out => seg_3
    );    

  U3: assign_seg port map (
    clk => clk,
    rstn => rstn,
    seg_in => seg_m(3 downto 0),
    seg_out => seg_2
    );    

  U4: assign_seg port map (
    clk => clk,
    rstn => rstn,
    seg_in => seg_l(7 downto 4),
    seg_out => seg_1
    );    
  
  U5: assign_seg port map (
    clk => clk,
    rstn => rstn,
    seg_in => seg_l(3 downto 0),
    seg_out => seg_0
    );    
  
end behavior ;
