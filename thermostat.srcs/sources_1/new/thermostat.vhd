library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity thermostat is
    Port ( current_temp : in STD_LOGIC_VECTOR (6 downto 0);
           desired_temp : in STD_LOGIC_VECTOR  (6 downto 0);
           display_select, COOL, HEAT, CLK, Furnace_Hot, AC_Ready : in STD_LOGIC;
           AC_on, Furnace_on,Fan_On        : out STD_LOGIC;
           temp_display : out STD_LOGIC_VECTOR  (6 downto 0));
end thermostat;

architecture Behavioral of thermostat is
  signal  current_temp_reg : STD_LOGIC_VECTOR (6 downto 0);
  signal desired_temp_reg : STD_LOGIC_VECTOR (6 downto 0);
  signal display_select_reg : STD_LOGIC;
  signal heat_reg : STD_LOGIC;
  signal cool_reg : STD_LOGIC;  
  signal Furnace_Hot_reg : STD_LOGIC;
  signal AC_Ready_reg : STD_LOGIC;
  signal Fan_On_reg : STD_LOGIC;
  type StateType is (idle, heaton, furnacenowhot, furnacecool, coolon, acnowready, acdone); 
  signal state, next_state : StateType;
  
begin
process (CLK)
begin
    if (CLK'event and CLK='1') then
    current_temp_reg <= current_temp;
    desired_temp_reg <= desired_temp;
    display_select_reg <= display_select;
    heat_reg <= HEAT;
    cool_reg<= COOL;
    Furnace_Hot_reg <=Furnace_Hot;
    AC_Ready_reg <= AC_Ready;
    end if;
    end process;
process (CLK)
begin
    if (CLK'event and CLK='1') then
        if (display_select_reg = '1') then
        temp_display <= current_temp_reg;
    else
        temp_display <= desired_temp_reg;
    end if;
  end if;
    end process;
    
    
--process (CLK)
--begin
--if (CLK'event and CLK='1') then
--    if (desired_temp_reg < current_temp_reg) and COOL_reg = '1' then
--    AC_on<= '1';
--    else 
--    AC_on <= '0';
--    end if;
--    if (desired_temp_reg > current_temp_reg) and HEAT_reg = '1' then
--    Furnace_on<= '1';
--    else 
--    Furnace_on <= '0';
--    end if;
--    end if;
--end process;

process (CLK)
begin
if (CLK'event and CLK='1') then
    state<= next_state;
    end if;
end process;


process (state,desired_temp_reg,current_temp_reg,COOL_reg, HEAT_reg, AC_Ready_reg,Fan_On_reg,Furnace_Hot_reg) 
begin
case (state) is
    when idle => 
        if (desired_temp_reg > current_temp_reg) and HEAT_reg = '1' then
            next_state <= heaton;
        elsif (desired_temp_reg < current_temp_reg) and COOL_reg = '1' then
            next_state <= coolon;
        else
           next_state <= idle;
        end if;
     when heaton =>
     if furnace_hot_reg = '1' then
        next_state <= furnacenowhot;
     else
        next_state <= heaton;
     end if;        
     when furnacenowhot => 
        if not((desired_temp_reg > current_temp_reg) and HEAT_reg = '1') then
            next_state <= furnacecool;
        else
           next_state <= furnacenowhot;
        end if;
    when furnacecool =>
        if ac_ready_reg ='0' then
        next_state<= idle;
        else 
        next_state <= furnacecool; 
        end if;
     when coolon => 
        if ac_ready_reg = '1' then
        next_state<= acnowready;
      else
      next_state<= coolon;
      end if;
      when acnowready=>
        if not ((desired_temp_reg < current_temp_reg) and COOL_reg = '1') then
        next_state <= acdone;
        else
        next_state<= acnowready;
        end if;
        when acdone => 
        if ac_ready_reg = '0' then
        next_state <= idle;
        else 
        next_state<= acdone;
        end if;
        when others =>
        next_state<= idle; 
        end case;
end process;

process(CLK)
begin
if (CLK'event and CLK='1') then
    if next_state = heaton or next_state = furnacenowhot then
    furnace_on <= '1';
    else 
    furnace_on <= '0';
    end if;
    if next_state = coolon or next_state = acnowready then
    ac_on <= '1';
    else 
    ac_on <= '0';
    end if;
    if next_state = furnacenowhot or next_state = acnowready or next_state = furnacecool or next_state = acdone then
    fan_on <= '1';
    else 
    fan_on <= '0';
    end if;
    end if;
end process;

end Behavioral;


