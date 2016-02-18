library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity tb_axi is
  
  generic (
    period : time := 1ns;          -- frequence
    C_AXI_DATA_WIDTH : integer:=32;
    C_AXI_ADDR_WIDTH : integer:=32
    );
end tb_axi;


architecture test of tb_axi is
  signal AXI_CLK : std_logic := '0';
  signal AXI_ARESETN : std_logic := '0';
  signal AXI_AWADDR : std_logic_vector(C_AXI_ADDR_WIDTH-1 downto 0);
  signal AXI_AWVALID : std_logic;
  signal AXI_AWREADY : std_logic;
  signal AXI_WDATA : std_logic_vector(C_AXI_ADDR_WIDTH-1 downto 0);
  signal AXI_WSTRB : std_logic_vector(C_AXI_DATA_WIDTH/8-1 downto 0);
  signal AXI_WVALID : std_logic;
  signal AXI_WREADY : std_logic;
  signal AXI_BRESP : std_logic_vector(1 downto 0);
  signal AXI_BVALID : std_logic;
  signal AXI_ARVALID : std_logic;
  signal AXI_ARREADY : std_logic;
  signal AXI_BREADY : std_logic;
  signal AXI_ARADDR : std_logic_vector(C_AXI_ADDR_WIDTH-1 downto 0);
  signal AXI_RDATA : std_logic_vector(C_AXI_DATA_WIDTH-1 downto 0);
  signal AXI_RRESP : std_logic_vector(1 downto 0);
  signal AXI_RVALID : std_logic;
  signal AXI_RREADY : std_logic;
  signal SW_IN : std_logic_vector(7 downto 0);
  signal LED_OUT : std_logic_vector(7 downto 0);        
  signal REG_STATUS:  std_logic_vector(C_AXI_DATA_WIDTH-1 downto 0);
  signal REG_WADDR:  std_logic_vector(C_AXI_DATA_WIDTH-1 downto 0);
  signal REG_WDATA:  std_logic_vector(C_AXI_DATA_WIDTH-1 downto 0);
  signal REG_RADDR:  std_logic_vector(C_AXI_DATA_WIDTH-1 downto 0);
  signal REG_RDATA:  std_logic_vector(C_AXI_DATA_WIDTH-1 downto 0);
  
begin  -- test

  -- purpose: create clk
  -- type   : combinational
  -- inputs : 
  -- outputs: clk
  process
  begin  -- process
    AXI_CLK <=not AXI_CLK;
    wait for period;        
  end process;

  -- purpose: provide value
  -- type   : combinational
  -- inputs : 
  -- outputs: din
  process
  begin  -- process
    AXI_ARESETN <= '0';
    wait for 800 * period;
    AXI_ARESETN <= '1';
    wait;
  end process;

 process(AXI_CLK)
  begin
    if(rising_edge(AXI_CLK))then
      if(AXI_ARESETN = '0') then
        SW_IN <= x"00";
      else
        SW_IN <= SW_IN + "1";
      end if;
    end if;
  end process;
  
  axi_lite_master_map: entity work.axi_lite_master(behavior) 
    port map(AXI_CLK, AXI_ARESETN, AXI_AWADDR, AXI_AWVALID, AXI_AWREADY, AXI_WDATA, AXI_WSTRB, AXI_WVALID, AXI_WREADY, AXI_BRESP, AXI_BVALID, AXI_BREADY,AXI_ARADDR, AXI_ARVALID, AXI_ARREADY, AXI_RDATA,  AXI_RRESP, AXI_RVALID, AXI_RREADY);
  axi_lite_slave_map: entity work.axi_lite_slave(behavior) 
    port map(AXI_CLK, AXI_ARESETN, AXI_AWADDR, AXI_AWVALID, AXI_AWREADY, AXI_WDATA, AXI_WSTRB, AXI_WVALID, AXI_WREADY, AXI_BRESP, AXI_BVALID, AXI_BREADY,AXI_ARADDR, AXI_ARVALID, AXI_ARREADY, AXI_RDATA,  AXI_RRESP, AXI_RVALID, AXI_RREADY, SW_IN, LED_OUT, REG_STATUS, REG_WADDR, REG_WDATA, REG_RADDR, REG_RDATA);
  
end test;
