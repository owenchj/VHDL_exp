library ieee;
use ieee.std_logic_1164.all;

entity axi_lite_slave is
  
  generic (
    C_S_AXI_DATA_WIDTH : integer := 32;  -- data width
    C_S_AXI_ADDR_WIDTH : integer := 32;  -- address width
    GPIO_DATA_WIDTH : integer := 8  -- gpio data width
    );
  port (
    S_AXI_ACLK : in std_logic;          -- clk
    S_AXI_ARESETN : in std_logic;       -- reset active low

    S_AXI_AWADDR : in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
    S_AXI_AWVALID : in std_logic;       -- write address valid
    S_AXI_AWREADY : out std_logic;       -- write address ready

    S_AXI_WDATA :in std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
    S_AXI_WSTRB :in std_logic_vector(C_S_AXI_DATA_WIDTH/8-1 downto 0);
    S_AXI_WVALID:in std_logic;
    S_AXI_WREADY:out std_logic;

    S_AXI_BRESP: out std_logic_vector(1 downto 0);
    S_AXI_BVALID:out std_logic;
    S_AXI_BREADY:in std_logic;

    S_AXI_ARADDR:in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
    S_AXI_ARVALID: in std_logic;
    S_AXI_ARREADY: out std_logic;

    S_AXI_RDATA : out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
    S_AXI_RRESP :out std_logic_vector(1 downto 0);
    S_AXI_RVALID:out std_logic;
    S_AXI_RREADY:in std_logic;

    DATA_IN:in std_logic_vector(GPIO_DATA_WIDTH-1 downto 0);
    DATA_OUT:out std_logic_vector(GPIO_DATA_WIDTH-1 downto 0);

    REG_STATUS: out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
    REG_WADDR: out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
    REG_WDATA: out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
    REG_RADDR: out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
    REG_RDATA: in std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0)
    );

end axi_lite_slave;

architecture behavior of axi_lite_slave is

  signal  LP_TARGET_MASTER_BASE_ADDR :   std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0) := x"40000000";
  signal LP_TARGET_MASTER_WRITE_ADDR : std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0) := x"40000004";
  signal  LP_TARGET_MASTER_READ_ADDR :   std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0) := x"40000008";
  
  signal  LP_TARGET_MASTER_REG_STATUS : std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0) := x"4000000c";
  signal LP_TARGET_MASTER_REG_WADDR :   std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0) := x"40000010";
  signal  LP_TARGET_MASTER_REG_WDATA:   std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0) := x"40000014";
  signal LP_TARGET_MASTER_REG_RADDR :   std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0) := x"40000018";
  signal  LP_TARGET_MASTER_REG_RDATA :   std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0) := x"4000001c";
  
  signal status_reg : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
  signal waddr_reg : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
  signal wdata_reg : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
  signal raddr_reg : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);

  signal axi_awaddr: std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
  signal axi_awready: std_logic;
  signal axi_wready: std_logic;
  signal axi_bvalid: std_logic;
  signal axi_bresp: std_logic_vector(1 downto 0);
  

  signal axi_araddr: std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
  signal axi_arready: std_logic;
  signal axi_rdata: std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
  signal axi_rvalid: std_logic;
  signal axi_rresp: std_logic_vector(1 downto 0);
  
  signal out_data: std_logic_vector(GPIO_DATA_WIDTH-1 downto 0);

  signal aw_ack: std_logic;
  signal dw_ack: std_logic;

begin  -- behavior
  --Write Address Ready (AWREADY)
  S_AXI_AWREADY <= axi_awready;

  --Write Data Ready(WREADY)
  S_AXI_WREADY  <= axi_wready;
  --Write Data
  DATA_OUT <= out_data;

  --Write Response (BResp)and response valid (BVALID)
  S_AXI_BRESP  <= axi_bresp;
  S_AXI_BVALID <= axi_bvalid;

  --Read Address Ready(AREADY)
  S_AXI_ARREADY <= axi_arready;
  
  --Read and Read Data (RDATA), Read Valid (RVALID) and Response (RRESP)
  S_AXI_RDATA  <= axi_rdata;
  S_AXI_RVALID <= axi_rvalid;
  S_AXI_RRESP  <= axi_rresp;
  
  REG_STATUS <= status_reg;
  REG_WADDR <= waddr_reg;
  REG_WDATA <= wdata_reg;
  REG_RADDR <= raddr_reg;
  
  awready_create:
  process(S_AXI_ACLK)
  begin
    if(rising_edge(S_AXI_ACLK))then
      if(S_AXI_ARESETN = '0') then
        aw_ack <= '0';
        axi_awready <= '1';
      else
        if (S_AXI_AWVALID = '1') then
          axi_awready <= '1';
        end if;

        if (axi_awready = '1' and S_AXI_AWVALID = '1') then
          aw_ack <= '1';
          axi_awready <= '0'; 
        end if;

        if(axi_awready='1' and S_AXI_AWVALID='1' and axi_wready='1' and S_AXI_WVALID='1') then
          aw_ack <= '0';
        end if;
        if (axi_awready='1' and S_AXI_AWVALID='1'  and dw_ack='1' )then
          aw_ack <= '0';
        end if;
        if (axi_wready='1' and S_AXI_WVALID='1'  and aw_ack='1' ) then
          aw_ack <= '0';
        end if;
        
        if(axi_bvalid = '1') then
          axi_awready <= '1';
        end if;
      end if;
    end if;
  end process;


  wready_create:
  process(S_AXI_ACLK)
  begin
    if(rising_edge(S_AXI_ACLK))then
      if(S_AXI_ARESETN = '0') then
        dw_ack <= '0';
        axi_wready <= '1';
      else
        if (S_AXI_WVALID = '1') then
          axi_wready <= '1';
        end if;

        if (axi_wready = '1' and S_AXI_WVALID = '1') then
          dw_ack <= '1';
          axi_wready <= '0'; 
        end if;

        if(axi_awready='1' and S_AXI_AWVALID='1' and axi_wready='1' and S_AXI_WVALID='1') then
          dw_ack <= '0';
        end if;
        if (axi_awready='1' and S_AXI_AWVALID='1'  and dw_ack='1' )then
          dw_ack <= '0';
        end if;
        if (axi_wready='1' and S_AXI_WVALID='1'  and aw_ack='1' ) then
          dw_ack <= '0';
        end if;
        
        if(axi_bvalid = '1') then
          axi_wready <= '1';
        end if;
      end if;
    end if;
  end process;


  bvalid_create:
  process(S_AXI_ACLK)
  begin
    if(rising_edge(S_AXI_ACLK))then
      if(S_AXI_ARESETN = '0') then
        axi_bvalid <= '0';
        axi_bresp <= "00";
      else
        
        if((axi_awready='1' and S_AXI_AWVALID='1' and axi_wready='1' and S_AXI_WVALID='1') or (axi_awready='1' and S_AXI_AWVALID='1'  and dw_ack='1' ) or  (axi_wready='1' and S_AXI_WVALID='1'  and aw_ack='1' )) then
          axi_bvalid <= '1';
          axi_bresp <= "00";
          if(S_AXI_AWADDR = (LP_TARGET_MASTER_BASE_ADDR or LP_TARGET_MASTER_WRITE_ADDR)) then
            if(S_AXI_WSTRB(0)='1') then
              out_data(GPIO_DATA_WIDTH-1 downto 0)   <= S_AXI_WDATA(GPIO_DATA_WIDTH-1 downto 0);
            end if;
          end if;
          
          if(S_AXI_AWADDR = (LP_TARGET_MASTER_BASE_ADDR or LP_TARGET_MASTER_REG_STATUS)) then
            if(S_AXI_WSTRB(0)='1')then
              status_reg(1 downto 0)  <= S_AXI_WDATA(1 downto 0);
            end if;
          end if;
          
          if(S_AXI_AWADDR = (LP_TARGET_MASTER_BASE_ADDR or LP_TARGET_MASTER_REG_WADDR))then
            if(S_AXI_WSTRB(0) = '1')then
              waddr_reg(7 downto 0)  <= S_AXI_WDATA(7 downto 0);
            end if;
            if(S_AXI_WSTRB(1) = '1')then
              waddr_reg(15 downto 8)  <= S_AXI_WDATA(15 downto 8);
            end if;
            if(S_AXI_WSTRB(2) = '1')then
              waddr_reg(23 downto 16)  <= S_AXI_WDATA(23 downto 16);
            end if;
            if(S_AXI_WSTRB(3) = '1')then
              waddr_reg(31 downto 24)  <= S_AXI_WDATA(31 downto 24);
            end if;
          end if;

          if(S_AXI_AWADDR = (LP_TARGET_MASTER_BASE_ADDR or LP_TARGET_MASTER_REG_WDATA))then
            if(S_AXI_WSTRB(0) = '1')then
              wdata_reg(7 downto 0)  <= S_AXI_WDATA(7 downto 0);
            end if;
            if(S_AXI_WSTRB(1) = '1')then
              wdata_reg(15 downto 8)  <= S_AXI_WDATA(15 downto 8);
            end if;
            if(S_AXI_WSTRB(2) = '1')then
              wdata_reg(23 downto 16)  <= S_AXI_WDATA(23 downto 16);
            end if;
            if(S_AXI_WSTRB(3) = '1')then
              wdata_reg(31 downto 24)  <= S_AXI_WDATA(31 downto 24);
            end if;
          end if;  

          if(S_AXI_AWADDR = (LP_TARGET_MASTER_BASE_ADDR or LP_TARGET_MASTER_REG_RADDR))then
            if(S_AXI_WSTRB(0) = '1')then
              raddr_reg(7 downto 0)  <= S_AXI_WDATA(7 downto 0);
            end if;
            if(S_AXI_WSTRB(1) = '1')then
              raddr_reg(15 downto 8)  <= S_AXI_WDATA(15 downto 8);
            end if;
            if(S_AXI_WSTRB(2) = '1')then
              raddr_reg(23 downto 16)  <= S_AXI_WDATA(23 downto 16);
            end if;
            if(S_AXI_WSTRB(3) = '1')then
              raddr_reg(31 downto 24)  <= S_AXI_WDATA(31 downto 24);
            end if;
          end if;
        end if;

        if(axi_bvalid = '1') then
          axi_bvalid <='0';
        end if;
        
      end if;
    end if;
  end process;

  arready_create:
  process(S_AXI_ACLK)
  begin
    if(rising_edge(S_AXI_ACLK))then
      if(S_AXI_ARESETN = '0') then
        axi_arready <= '1';
      else
        if (S_AXI_ARVALID = '1')then
          if (axi_arready ='0') then
            axi_arready <= '1';
          else
            axi_arready <= '0';
          end if;
        end if;

        if (S_AXI_RREADY = '1' and axi_rvalid ='1') then
          axi_arready <= '0';
        end if;
      end if;
    end if;
  end process;


  
  rvalid_create:
  process(S_AXI_ACLK)
  begin
    if(rising_edge(S_AXI_ACLK))then
      if(S_AXI_ARESETN = '0') then
        axi_rvalid <= '0';
      else
        if (S_AXI_ARVALID = '1' and axi_arready ='1') then
          axi_rvalid <= '1';
        end if;

        if (S_AXI_RREADY = '1' and axi_rvalid ='1') then
          axi_rvalid <= '0';
        end if;
      end if;
    end if;
  end process;


  read_data:
  process(S_AXI_ACLK)
  begin
    if(rising_edge(S_AXI_ACLK))then
      if(S_AXI_ARESETN = '0') then
        axi_rdata <= x"00000000";
        axi_rresp <= "00";
      else
        if (S_AXI_ARVALID = '1' and axi_arready ='1') then
          if(S_AXI_ARADDR = (LP_TARGET_MASTER_BASE_ADDR or LP_TARGET_MASTER_READ_ADDR)) then
            axi_rdata(GPIO_DATA_WIDTH-1 downto 0) <= DATA_IN;
            axi_rresp <= "00";
          end if;
          
          if( S_AXI_ARADDR = (LP_TARGET_MASTER_BASE_ADDR or LP_TARGET_MASTER_REG_RDATA))   then
            axi_rdata(C_S_AXI_DATA_WIDTH-1 downto 0) <= REG_RDATA(C_S_AXI_DATA_WIDTH-1 downto 0);
            axi_rresp <= "00";
          end if;
        end if;
      end if;
    end if;
  end process;

end behavior;

