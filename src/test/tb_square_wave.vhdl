library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

library vunit_lib;
context vunit_lib.vunit_context;

entity tb_square_wave is
    generic (runner_cfg : string);
end tb_square_wave;

architecture Behavioral of tb_square_wave is
    component square_wave is
        generic (MAX_PERIOD: integer;
                 CLOCK_DIV: integer);

        port (clk: in std_logic;
              on_period:  in integer;
              off_period: in integer;
              wave: out std_logic);
    end component;

    constant MAX_PERIOD: integer := 15;
    constant CLOCK_DIV: integer := 5;

    signal clk : std_logic;
    signal on_period:  integer range 0 to MAX_PERIOD;
    signal off_period: integer range 0 to MAX_PERIOD;
    signal wave: std_logic;

    constant T : time := 20 ns;
begin

    clock_generation : process
    begin
        clk <= '0';
        wait for T/2;
        clk <= '1';
        wait for T/2;
    end process;

    uut: square_wave
        generic map (
            MAX_PERIOD => MAX_PERIOD,
            CLOCK_DIV => CLOCK_DIV)
        port map (
            clk => clk,
            on_period => on_period,
            off_period => off_period,
            wave => wave);

    tb: process
    begin
        test_runner_setup(runner, runner_cfg);
        on_period  <= 2;
        off_period <= 1;

        wait until falling_edge(clk);
        assert wave = '1' report "wave is not on";
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- 100 ns

        wait until falling_edge(clk);
        assert wave = '1' report "wave is not on";
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- 200 ns

        wait until falling_edge(clk);
        assert wave = '0' report "wave is not off";
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        wait until rising_edge(clk); -- 300 ns

        wait until falling_edge(clk);
        assert wave = '1' report "wave is not on";
        test_runner_cleanup(runner); -- Simulation ends here
    end process;

end Behavioral;
