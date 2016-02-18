library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity immediate_float_add_module is
  port (
    a              : in  std_logic_vector(31 downto 0);
    b              : in  std_logic_vector(31 downto 0);
    sq_a_out_t0, sq_b_out_t0           : out std_logic_vector(56 downto 0);
    sq_exp_out_t1, sq_expdiff_out_t1   : out std_logic_vector(9 downto 0);
    sq_a_out_t2, sq_b_out_t2           : out std_logic_vector(56 downto 0);
    sq_tempa_out_t3, sq_tempb_out_t3   : out std_logic_vector(48 downto 0);
    sq_issign_out_t4  : out std_logic;
    sq_exp_out_t4     : out std_logic_vector(9 downto 0);
    sq_temp_out_t4    : out std_logic_vector(48 downto 0);
    sq_exp_out_t5     : out std_logic_vector(9 downto 0);
    sq_temp_out_t5    : out std_logic_vector(48 downto 0);
    
    error_out         : out std_logic_vector(2 downto 0);
    result            : out std_logic_vector(31 downto 0)
    );
end entity;



architecture behavior of immediate_float_add_module is
  signal a_out_t0, b_out_t0          :  std_logic_vector(56 downto 0);
  signal exp_out_t1, expdiff_out_t1  :  std_logic_vector(9 downto 0);
  signal a_out_t2, b_out_t2          :  std_logic_vector(56 downto 0);
  signal tempa_out_t3, tempb_out_t3  :  std_logic_vector(48 downto 0);
  signal issign_out_t4 :  std_logic;
  signal exp_out_t4    :  std_logic_vector(9 downto 0);
  signal temp_out_t4   :  std_logic_vector(48 downto 0);
  signal exp_out_t5    :  std_logic_vector(9 downto 0);
  signal temp_out_t5   :  std_logic_vector(48 downto 0);
  signal error_out_t6  :  std_logic_vector(2 downto 0);
  signal result_t6     :  std_logic_vector(31 downto 0);

  component task_preconfig is
    port (
      a_in   : in  std_logic_vector(31 downto 0);
      b_in   : in  std_logic_vector(31 downto 0);
      a_out  : out std_logic_vector(56 downto 0);
      b_out  : out std_logic_vector(56 downto 0)
      );
  end component;

  component task_expact1 is
    port (
      a_in           : in  std_logic_vector(56 downto 0);
      b_in           : in  std_logic_vector(56 downto 0);
      exp_out        : out std_logic_vector(9 downto 0);
      expdiff_out    : out std_logic_vector(9 downto 0)
      );
  end component;

  component task_expact2 is
  port (
    a_in           : in  std_logic_vector(56 downto 0);
    b_in           : in  std_logic_vector(56 downto 0);
    exp_in         : in  std_logic_vector(9 downto 0);
    expdiff_in     : in  std_logic_vector(9 downto 0);
    a_out          : out std_logic_vector(56 downto 0);
    b_out          : out std_logic_vector(56 downto 0)
    );
  end component;

  component task_2ndlmp is
    port (
      a_in           : in  std_logic_vector(56 downto 0);
      b_in           : in  std_logic_vector(56 downto 0);
      temp_a         : out std_logic_vector(48 downto 0);
      temp_b         : out std_logic_vector(48 downto 0)
      );
  end component;

  component task_resultmodify is
    port (
      a_exp_in       : in  std_logic_vector(7 downto 0);
      tempa_in       : in  std_logic_vector(48 downto 0);
      tempb_in       : in  std_logic_vector(48 downto 0);
      issign_out     : out std_logic;
      exp_out        : out std_logic_vector(9 downto 0);
      temp_out       : out std_logic_vector(48 downto 0)
      );
  end component;

  component task_checkhbit is
    port (
      exp_in         : in  std_logic_vector(9 downto 0);
      temp_in        : in  std_logic_vector(48 downto 0);
      exp_out        : out std_logic_vector(9 downto 0);
      temp_out       : out std_logic_vector(48 downto 0)
      );
  end component;

  component task_resulterror is
    port (
      issign_in      : in  std_logic;
      exp_in         : in  std_logic_vector(9 downto 0);
      temp_in        : in  std_logic_vector(48 downto 0);
      error_out      : out std_logic_vector(2 downto 0);
      result         : out std_logic_vector(31 downto 0)
      );
  end component;


begin

  U0: task_preconfig port map
    (
      a_in   => a,
      b_in   => b,
      a_out  => a_out_t0,
      b_out  => b_out_t0
      );
  

  U1: task_expact1 port map
    (
      a_in           => a_out_t0,
      b_in           => b_out_t0,
      exp_out        => exp_out_t1,
      expdiff_out    => expdiff_out_t1
      );
  

  U2: task_expact2 port map
    (
      a_in           => a_out_t0,  
      b_in           => b_out_t0,
      exp_in         => exp_out_t1,
      expdiff_in     => expdiff_out_t1,
      a_out          => a_out_t2,
      b_out          => b_out_t2
      );
  

  U3: task_2ndlmp port map
    (
      a_in           => a_out_t2,
      b_in           => b_out_t2,
      temp_a         => tempa_out_t3,
      temp_b         => tempb_out_t3
      );
  

  U4: task_resultmodify port map
    (
      a_exp_in       => a_out_t2(55 downto 48),
      tempa_in       => tempa_out_t3,
      tempb_in       => tempb_out_t3,
      issign_out     => issign_out_t4,
      exp_out        => exp_out_t4,
      temp_out       => temp_out_t4
      );
  

  U5: task_checkhbit port map
    (
      exp_in         => exp_out_t4,
      temp_in        => temp_out_t4,
      exp_out        => exp_out_t5,
      temp_out       => temp_out_t5
      );
  

  U6: task_resulterror port map
    (
      issign_in      => issign_out_t4,
      exp_in         => exp_out_t5,
      temp_in        => temp_out_t5,
      error_out      => error_out_t6,
      result         => result_t6
      );
  

  
  error_out <= error_out_t6;
  result    <= result_t6;
  
  sq_a_out_t0 <= a_out_t0;
  sq_b_out_t0 <= b_out_t0;
  sq_exp_out_t1 <= exp_out_t1;
  sq_expdiff_out_t1 <= expdiff_out_t1;
  sq_a_out_t2 <= a_out_t2;
  sq_b_out_t2 <= b_out_t2;
  sq_tempa_out_t3 <= tempa_out_t3;
  sq_tempb_out_t3 <= tempb_out_t3;
  sq_issign_out_t4 <= issign_out_t4;
  sq_exp_out_t4 <= exp_out_t4;
  sq_temp_out_t4 <= temp_out_t4;
  sq_exp_out_t5 <= exp_out_t5;
  sq_temp_out_t5 <= temp_out_t5;
end architecture;
