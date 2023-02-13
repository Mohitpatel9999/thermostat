library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity T_THERMO is
--  Port ( );
end T_THERMO;

architecture Behavioral of T_THERMO is
component thermostat
 Port ( current_temp : in STD_LOGIC_VECTOR (6 downto 0);
           desired_temp : in STD_LOGIC_VECTOR  (6 downto 0);
           display_select, COOL, HEAT, CLK, Furnace_Hot, AC_Ready : in STD_LOGIC;
           AC_on, Furnace_on,Fan_On        : out STD_LOGIC;
           temp_display : out STD_LOGIC_VECTOR  (6 downto 0));
  end component;
  signal current_temp, desired_temp,temp_display : STD_LOGIC_VECTOR (6 downto 0);
  signal display_select, COOL, HEAT, AC_on, Furnace_on,Furnace_Hot, AC_Ready,Fan_On :  STD_LOGIC;
  signal CLK : STD_LOGIC := '0'; 
begin
CLK <= not CLK after 5 ns;
UUT: thermostat port map ( 
          CLK => CLK,
          current_temp => current_temp,
          desired_temp => desired_temp,
          display_select => display_select,
          COOL => COOL,
          HEAT => HEAT,
          AC_on => AC_on,
          Furnace_on  => Furnace_on,
          temp_display => temp_display,
          furnace_hot => furnace_hot,
          AC_Ready=>AC_Ready,
          Fan_On=> Fan_On );
process
begin
current_temp<= "0000000";
desired_temp<= "1111111";
display_select <= '0';
furnace_hot <= '0';
ac_ready <= '0';
heat <= '0';
cool<= '0';
wait for 50 ns;
display_select <= '1';
wait for 50ns;
HEAT<= '1';
wait until furnace_on = '1';
furnace_hot <= '1';
wait until fan_on='1';
heat <='0';
wait until furnace_on = '0';
furnace_hot <= '0';
wait for 50ns;
HEAT<= '0';
wait for 50ns;
current_temp<= "1000000";
desired_temp <= "0100000";
wait for 50ns;
COOL<= '1';
wait until  ac_on ='1';
ac_ready<='1';
wait until fan_on = '1';
cool<='0';
ac_ready<='0'; 
wait for 50ns;
COOL<= '0';
wait for 50ns;
wait;
end process;
end Behavioral;
