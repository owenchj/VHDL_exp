library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
entity shifter is
  
  generic (
    n : natural := 3                  -- n bits shifter,n > 2
    );
  port (
    clk : in std_logic;                 -- clk, 1 bit
    reset : in std_logic;               -- reset, 1 bit
    din : in std_logic;                 -- data_in, 1 bit
    dout : out std_logic                -- data out, 1 bit
    );
end shifter;


architecture basic of shifter is
  signal reg : std_logic_vector(n-1 downto 0);        -- reg
  
begin  -- basic

  -- purpose: shift
  -- type   : combinational
  -- inputs : din
  -- outputs: dout
  process (clk)
    variable count : natural := 1;            -- count
  begin  -- process
    if(rising_edge(clk)) then
      if reset = '1' then
        dout <= '0';
      else
        reg(0)<= din;
        while count < n loop
          reg(count)<=reg(count-1);
          count := count + 1;  
        end loop;
 	count := 1;    
        dout <= reg(n-1);   
      end if;
    end if;
  end process;

end basic;
