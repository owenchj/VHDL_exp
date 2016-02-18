library IEEE;
use IEEE.std_logic_1164.all;

entity RS is
  port(
    R: in std_logic;
    S: in std_logic;
    Q: out std_logic
    );
end  entity RS;

architecture RTL of RS is
begin
  if(R==1 && S==0) then
    Q<=1;
  elsif(R==0 && S==1) then
    Q<=0;
  elsif(R==0 && S==0) then
    Q<=Q;  
  end if;         
end architecture ;  
