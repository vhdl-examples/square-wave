library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity square_wave is
    generic (MAX_PERIOD: integer := 15;
             CLOCK_DIV: integer := 5);

    port (clk: in std_logic;
          on_period:  in integer range 0 to MAX_PERIOD;
          off_period: in integer range 0 to MAX_PERIOD;
          wave: out std_logic);
end square_wave;

architecture arch of square_wave is
    constant TIME_UNIT: time := 100 ns;
begin

    config : process(clk) is
        variable slot_index: integer range 0 to MAX_PERIOD*2+1 := 0;
        variable slot_counter: integer range 0 to CLOCK_DIV := 0;

    begin
        if(rising_edge(clk)) then

            if slot_counter = CLOCK_DIV then
                slot_index := slot_index + 1;
                slot_counter := 1;
            else
                slot_counter := slot_counter + 1;
            end if;

            if slot_index >= on_period then
                wave <= '0';
            else    wave <= '1';
            end if;

            if slot_index >= on_period + off_period then
                wave <= '1';
                slot_index := 0;
            end if;

        end if;
    end process config;

end arch;
