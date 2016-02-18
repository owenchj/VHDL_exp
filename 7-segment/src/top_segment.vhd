library ieee;
use ieee.std_logic_1164.all;

entity top_segment is
  port(
    clk         : in std_logic;
    rstn        : in std_logic;
    date_time_n : in std_logic;
    adjust      : in std_logic;
    increament  : in std_logic;
    seg_5       : out std_logic_vector(6 downto 0);
    seg_4       : out std_logic_vector(6 downto 0);
    seg_3       : out std_logic_vector(6 downto 0);
    seg_2       : out std_logic_vector(6 downto 0);
    seg_1       : out std_logic_vector(6 downto 0);
    seg_0       : out std_logic_vector(6 downto 0)
    );
end entity;


architecture behavior  of top_segment is
  signal seg_h       : std_logic_vector(7 downto 0);
  signal seg_m       : std_logic_vector(7 downto 0);
  signal seg_l       : std_logic_vector(7 downto 0);

  signal year        :  std_logic_vector(7 downto 0);
  signal month       :  std_logic_vector(4 downto 0);
  signal day         :  std_logic_vector(5 downto 0);
  signal hour        :  std_logic_vector(5 downto 0);
  signal minute      :  std_logic_vector(6 downto 0);
  signal second      :  std_logic_vector(6 downto 0);

  signal mode        :  std_logic_vector(3 downto 0); 
  signal add_a_day   :  std_logic;

  signal year_i      :  std_logic_vector(7 downto 0);  -- 2000-2099
  signal month_i     :  std_logic_vector(4 downto 0);
  signal day_i       :  std_logic_vector(5 downto 0);
  signal hour_i      :  std_logic_vector(5 downto 0); 
  signal minute_i    :  std_logic_vector(6 downto 0);
  signal second_i    :  std_logic_vector(6 downto 0);

  component display is
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
  end component;

  
  component mux_date_time is
    port(
      date_time_n : in std_logic;
      mode        : in std_logic_vector(3 downto 0);
      year        : in std_logic_vector(7 downto 0);
      month       : in std_logic_vector(4 downto 0);
      day         : in std_logic_vector(5 downto 0);
      hour        : in std_logic_vector(5 downto 0);
      minute      : in std_logic_vector(6 downto 0);
      second      : in std_logic_vector(6 downto 0);
      seg_h       : out std_logic_vector(7 downto 0);
      seg_m       : out std_logic_vector(7 downto 0);
      seg_l       : out std_logic_vector(7 downto 0)
      );
  end component;


  component year_month_day is
    port(
      clk         : in std_logic;
      rstn        : in std_logic;
      add_a_day   : in std_logic;
      mode        : in std_logic_vector(3 downto 0);
      year_i      : in std_logic_vector(7 downto 0);  -- 2000-2099
      month_i     : in std_logic_vector(4 downto 0);
      day_i       : in std_logic_vector(5 downto 0);
      year        : out std_logic_vector(7 downto 0);  -- 2000-2099
      month       : out std_logic_vector(4 downto 0);
      day         : out std_logic_vector(5 downto 0)
      );
  end component;

  component hour_minute_second is
    port(
      clk            : in std_logic;
      rstn           : in std_logic;
      add_a_day      : out std_logic;
      mode           : in std_logic_vector(3 downto 0);
      hour_i         : in std_logic_vector(5 downto 0); 
      minute_i       : in std_logic_vector(6 downto 0);
      second_i       : in std_logic_vector(6 downto 0);
      hour           : out std_logic_vector(5 downto 0);
      minute         : out std_logic_vector(6 downto 0);
      second         : out std_logic_vector(6 downto 0)
      );
  end component;

  
  component adjust_date_time is
    port(
      clk           : in std_logic;
      rstn          : in std_logic;
      adjust        : in std_logic;
      increament    : in std_logic;
      mode          : out std_logic_vector(3 downto 0);
      year_old      : in std_logic_vector(7 downto 0);  -- 2000-2099
      month_old     : in std_logic_vector(4 downto 0);
      day_old       : in std_logic_vector(5 downto 0);
      hour_old      : in std_logic_vector(5 downto 0);
      minute_old    : in std_logic_vector(6 downto 0);
      second_old    : in std_logic_vector(6 downto 0);
      year          : out std_logic_vector(7 downto 0);  -- 2000-2099
      month         : out std_logic_vector(4 downto 0);
      day           : out std_logic_vector(5 downto 0);
      hour          : out std_logic_vector(5 downto 0);
      minute        : out std_logic_vector(6 downto 0);
      second        : out std_logic_vector(6 downto 0)
      );
  end component;

  
begin
  
  U0: display port map(
    clk => clk,
    rstn => rstn,
    seg_h => seg_h,
    seg_m => seg_m,
    seg_l => seg_l,
    seg_5 => seg_5,
    seg_4 => seg_4,
    seg_3 => seg_3,
    seg_2 => seg_2,
    seg_1 => seg_1,
    seg_0 => seg_0
    ); 

  U1: mux_date_time port map(
    date_time_n => date_time_n,
    mode   => mode,
    year   => year,
    month  => month,
    day    => day,
    hour   => hour,
    minute => minute,
    second => second,     
    seg_h  => seg_h,    
    seg_m  => seg_m,       
    seg_l  => seg_l      

    );

  U2: year_month_day port map(
    clk         =>  clk,        
    rstn        =>  rstn,      
    add_a_day   =>  add_a_day,      
    mode        =>  mode,      
    year_i      =>  year_i,      
    month_i     =>  month_i,      
    day_i       =>  day_i,      
    year        =>  year,      
    month       =>  month,     
    day         =>  day
    );


  U3: hour_minute_second port map (
    clk            => clk,
    rstn           => rstn,
    add_a_day      => add_a_day,
    mode           => mode,
    hour_i         => hour_i,
    minute_i       => minute_i,
    second_i       => second_i,
    hour           => hour,
    minute         => minute,
    second         => second
    );

  U4:  adjust_date_time port map(
    clk           => clk,
    rstn          => rstn,
    adjust        => adjust,
    increament    => increament,
    mode          => mode,
    year_old      => year,
    month_old     => month,
    day_old       => day,
    hour_old      => hour,
    minute_old    => minute,
    second_old    => second,
    year          => year_i,
    month         => month_i,
    day           => day_i,
    hour          => hour_i,
    minute        => minute_i,
    second        => second_i
    );

end architecture;
