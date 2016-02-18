library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;


entity axi_lite_master is
  
  generic (
    C_M_AXI_DATA_WIDTH : integer := 32;  -- data width
    C_M_AXI_ADDR_WIDTH : integer := 32  -- address width
    );
  port (
    M_AXI_ACLK : in std_logic;          -- clk
    M_AXI_ARESETN : in std_logic;       -- reset active low

    M_AXI_AWADDR : out std_logic_vector(C_M_AXI_ADDR_WIDTH-1 downto 0);
    M_AXI_AWVALID : out std_logic;       -- write address valid
    M_AXI_AWREADY : in std_logic;       -- write address ready

    M_AXI_WDATA :out std_logic_vector(C_M_AXI_DATA_WIDTH-1 downto 0);
    M_AXI_WSTRB :out std_logic_vector(C_M_AXI_DATA_WIDTH/8-1 downto 0);
    M_AXI_WVALID:out std_logic;
    M_AXI_WREADY:in std_logic;

    M_AXI_BRESP: in std_logic_vector(1 downto 0);
    M_AXI_BVALID:in std_logic;
    M_AXI_BREADY:out std_logic;

    M_AXI_ARADDR:out std_logic_vector(C_M_AXI_ADDR_WIDTH-1 downto 0);
    M_AXI_ARVALID: out std_logic;
    M_AXI_ARREADY: in std_logic;

    M_AXI_RDATA : in std_logic_vector(C_M_AXI_DATA_WIDTH-1 downto 0);
    M_AXI_RRESP :in std_logic_vector(1 downto 0);
    M_AXI_RVALID:in std_logic;
    M_AXI_RREADY:out std_logic
    );

end axi_lite_master;

architecture behavior of axi_lite_master is

  signal  LP_TARGET_SLAVE_BASE_ADDR :   std_logic_vector(C_M_AXI_ADDR_WIDTH-1 downto 0) := x"40000000";
  signal  LP_TARGET_SLAVE_WRITE_ADDR :  std_logic_vector(C_M_AXI_ADDR_WIDTH-1 downto 0) := x"40000004";
  signal  LP_TARGET_SLAVE_READ_ADDR :   std_logic_vector(C_M_AXI_ADDR_WIDTH-1 downto 0) := x"40000008";
  
  signal  LP_TARGET_MASTER_REG_STATUS :  std_logic_vector(C_M_AXI_ADDR_WIDTH-1 downto 0) := x"4000000c";
  signal  LP_TARGET_MASTER_REG_WADDR :   std_logic_vector(C_M_AXI_ADDR_WIDTH-1 downto 0) := x"40000010";
  signal  LP_TARGET_MASTER_REG_WDATA:    std_logic_vector(C_M_AXI_ADDR_WIDTH-1 downto 0) := x"40000014";
  signal  LP_TARGET_MASTER_REG_RADDR :   std_logic_vector(C_M_AXI_ADDR_WIDTH-1 downto 0) := x"40000018";
  signal  LP_TARGET_MASTER_REG_RDATA :   std_logic_vector(C_M_AXI_ADDR_WIDTH-1 downto 0) := x"4000001c";
  signal  DRAM_ADDR :   std_logic_vector(C_M_AXI_ADDR_WIDTH-1 downto 0) := x"10000008";
  
  
  signal axi_awvalid: std_logic;
  signal axi_wvalid: std_logic;
  signal axi_arvalid: std_logic;
  signal axi_rready: std_logic;
  
  

  signal axi_awaddr: std_logic_vector(C_M_AXI_ADDR_WIDTH-1 downto 0);
  signal axi_wdata: std_logic_vector(C_M_AXI_DATA_WIDTH-1 downto 0);
  signal axi_araddr: std_logic_vector(C_M_AXI_DATA_WIDTH-1 downto 0);
  signal axi_addr_bready: std_logic;
  signal axi_data_bready: std_logic;
  
  signal c_awvalid: std_logic_vector(15 downto 0);
  signal c_wvalid: std_logic_vector(15 downto 0);
  signal c_arvalid: std_logic_vector(15 downto 0);
  signal c_addr: std_logic_vector(1 downto 0);
  signal c_data: std_logic_vector(1 downto 0);

begin  -- behavior
  M_AXI_AWADDR  <= LP_TARGET_SLAVE_BASE_ADDR or axi_awaddr;

  M_AXI_WDATA   <= axi_wdata;
  M_AXI_AWVALID <= axi_awvalid;
  
  M_AXI_WVALID <= axi_wvalid;

  M_AXI_WSTRB  <= "1111";
  
  
  M_AXI_ARADDR <= LP_TARGET_SLAVE_BASE_ADDR or axi_araddr;
  M_AXI_ARVALID <= axi_arvalid;
  
  M_AXI_BREADY <= axi_addr_bready and axi_data_bready;
  M_AXI_RREADY <= axi_rready;

  
  process(M_AXI_ACLK)
  begin
    if(rising_edge(M_AXI_ACLK))then
      if(M_AXI_ARESETN = '0') then
        axi_awvalid <= '0';
        axi_awaddr <= x"00000000";
        axi_addr_bready <= '0';
        c_awvalid <= x"0000";
        c_addr  <= "01";
      else
        if (M_AXI_AWREADY = '1' and axi_awvalid = '1') then
          axi_awvalid <= '0'; 
        else
          if(unsigned(c_awvalid) mod 45 = 0 and axi_addr_bready = '0' and axi_data_bready = '0') then
            axi_awvalid <= '1';
            axi_addr_bready <= '1';
            axi_awaddr <=LP_TARGET_MASTER_REG_STATUS + std_logic_vector(4 * unsigned(c_addr));
            c_addr  <= c_addr + "1";
          end if;
        end if;
        
        if (axi_addr_bready ='1' and axi_data_bready ='1'   and M_AXI_BVALID='1')then
          axi_addr_bready <= '0';
        end if;

        c_awvalid <= c_awvalid + "1";
      end if;
    end if;
  end process;


  process(M_AXI_ACLK)
  begin
    if(rising_edge(M_AXI_ACLK))then
      if(M_AXI_ARESETN = '0') then
        axi_wvalid <= '0';
        axi_wdata <= x"00000000";
        axi_data_bready <= '0';
        c_wvalid <= x"0001";
        c_data   <= "00";
      else
        if (M_AXI_WREADY = '1' and axi_wvalid = '1') then
          axi_wvalid <= '0'; 
        else
          if (M_AXI_AWREADY = '1' and axi_awvalid = '1') then
            axi_wvalid <= '1';
            axi_data_bready <= '1';
            if(axi_awaddr = LP_TARGET_MASTER_REG_STATUS) then
              if(c_data = 3)then 
                axi_wdata <=  "1";
              elsif(c_data = 2) then 
                axi_wdata <=  "0";
              else
                axi_wdata <=  x"00000002";
              end if;
            end if;

            if(axi_awaddr = LP_TARGET_MASTER_REG_WADDR )then
              axi_wdata <= std_logic_vector(unsigned(dram_addr) + 4 * unsigned(c_data));
              c_data   <= c_data + "1";
            end if;
            
            if(axi_awaddr = LP_TARGET_MASTER_REG_WDATA )then	
              axi_wdata <=  c_wvalid;
            end if;
            
            if(axi_awaddr = LP_TARGET_MASTER_REG_RADDR )then
              axi_wdata <=  dram_addr;
            end if;
            
          end if;
        end if;
        
        if (axi_data_bready ='1'and axi_addr_bready ='1'and M_AXI_BVALID='1')then
          axi_data_bready <= '0';
        end if;

        c_wvalid <= c_wvalid + "1";
      end if;
    end if;
  end process;
  

  process(M_AXI_ACLK)
  begin
    if(rising_edge(M_AXI_ACLK))then
      if(M_AXI_ARESETN = '0') then
        axi_arvalid <= '0';
        axi_araddr <= x"00000000";
        c_arvalid <= x"0002";
      else
        if(axi_arvalid = '1' and M_AXI_ARREADY ='1') then
          axi_arvalid <= '0';
        else
          if(unsigned(c_arvalid) mod 26 = 0) then
            axi_arvalid <= '1';
            axi_araddr <=  LP_TARGET_SLAVE_READ_ADDR;
          end if;
        end if;
        c_arvalid <= c_arvalid + "1";
      end if;
    end if;
  end process;


  
  process(M_AXI_ACLK)
  begin
    if(rising_edge(M_AXI_ACLK))then
      if(M_AXI_ARESETN = '0') then
        axi_rready <= '0';
      else
        if (M_AXI_RVALID = '1' and axi_rready ='0') then
          axi_rready <= '1';
        end if;

        if (M_AXI_RVALID = '1' and axi_rready ='1') then
          axi_rready <= '0';
        end if;

      end if;
    end if;
  end process;

end behavior;

