library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity square_wave is
    generic (MAX_PERIOD: positive := 15;
             CLOCK_DIV: positive := 5);

    port (clk: in std_logic;
          reset: in std_logic;
          on_period, off_period: in natural range 0 to MAX_PERIOD;
          wave: out std_logic);
end square_wave;

architecture arch of square_wave is
    type state_type is (wave_on, wave_off );
    signal state, next_state: state_type;
    constant TIME_UNIT: time := 100 ns;
    signal slot_index, next_slot_index: natural range 0 to MAX_PERIOD*2+1;
    signal slot_counter, next_slot_counter: natural range 0 to CLOCK_DIV;

    signal on_period_reg, off_period_reg:  natural range 0 to MAX_PERIOD;
    signal next_wave: std_logic;
begin

    sync : process(clk) is
    begin
        if reset = '1' then
            slot_counter <= 1;
            slot_index <= 0;
            on_period_reg <= on_period;
            off_period_reg <= off_period;
            state <= wave_on;
        elsif(rising_edge(clk)) then
            wave <= next_wave;
            slot_index <= next_slot_index;
            slot_counter <= next_slot_counter;
            state <= next_state;
        end if;
    end process sync;

    comb: process(slot_counter, state, slot_index) is
    begin
        next_slot_index <= 0;
        next_slot_counter <= 0;
        next_wave <= '0';
        next_state <= state;

        if slot_counter  = CLOCK_DIV -1 then
            next_slot_index <= slot_index + 1;
            next_slot_counter <= 0;
        else
            next_slot_counter <= slot_counter + 1;
            next_slot_index <=  slot_index;
        end if;

        case state is
            when wave_on =>
                next_wave <= '1';
                if slot_index >= on_period_reg then
                    next_state <= wave_off;
                end if;
            when wave_off =>
                next_wave <= '0';
                if slot_index >= on_period_reg + off_period_reg then
                    next_slot_index <= 0;
                    next_state <= wave_on;
                end if;
        end case;
    end process comb;
end arch;
