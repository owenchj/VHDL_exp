library ieee;
use ieee.std_logic_1164.all;

entity rx_module is
  port(
    CLK : in std_logic;
    RSTn : in std_logic;    
    RX_Pin_In : in std_logic;
    RX_En_Sig : in std_logic;
    RX_Done_Sig : out std_logic;
    RX_Data : out std_logic_vector(7 downto 0)
    
    );
end rx_module;

architecture behavior of rx_module is
  component detect_module 
    Port( CLK : in std_logic;
          RSTn : in std_logic;
          RX_Pin_In : in std_logic;
          H2L_Sig : out std_logic
          );              
  end component;

  component rx_bps_module  
    port(CLK : in std_logic;
         RSTn : in std_logic;
         Count_Sig : in std_logic;
         BPS_CLK : out std_logic
         );
  end component;

  component  rx_control_module 
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
  end component;

  signal  H2L_Sig : std_logic:='0';
  signal  BPS_CLK : std_logic:='0';
  signal  Count_Sig : std_logic:='0';
begin

U0  : detect_module port map (
    CLK => CLK,
    RSTn =>  RSTn,
    RX_Pin_In  => RX_Pin_In,
    H2L_Sig  => H2L_Sig 
    );
  
  

U1  : rx_bps_module port map(
    CLK => CLK,
    RSTn =>  RSTn,
    Count_Sig => Count_Sig,
    BPS_CLK => BPS_CLK 
    );

U2  : rx_control_module port map(
    CLK => CLK,
    RSTn =>  RSTn,
    H2L_Sig => H2L_Sig, -- input - from U1
    RX_En_Sig => RX_En_Sig , -- input - from top
    RX_Pin_In => RX_Pin_In , -- input - from top
    BPS_CLK => BPS_CLK , -- input - from U2
    Count_Sig => Count_Sig , -- output - to U2
    RX_Data => RX_Data,  -- output - to top
    RX_Done_Sig =>  RX_Done_Sig 
    );    

end behavior;
