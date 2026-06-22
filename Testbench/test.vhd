library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_spi_top is
end tb_spi_top;

architecture Behavioral of tb_spi_top is

    signal clk        : std_logic := '0';
    signal rst        : std_logic := '1';
    signal start_en   : std_logic := '0';

    signal data_in    : std_logic_vector(7 downto 0) := (others => '0');

    signal mosi       : std_logic;
    signal sclk       : std_logic;
    signal done_tx    : std_logic;

    signal cs         : std_logic_vector(2 downto 0);
    signal slave_sel  : std_logic_vector(1 downto 0) := "00";

    signal rx_done    : std_logic;
    signal data_out   : std_logic_vector(7 downto 0);

    -- NEW SIGNALS: Monitor master receiving MISO data from slaves
    signal master_rx_data : std_logic_vector(7 downto 0);
    signal master_rx_done : std_logic;

begin

    uut : entity work.top
    port map(
        clk            => clk,
        rst            => rst,
        data_in        => data_in,
        done_tx        => done_tx,
        sclk           => sclk,
        start_en       => start_en,
        rx_done        => rx_done,
        data_out       => data_out,
        cs             => cs,
        mosi           => mosi,
        slave_sel      => slave_sel,
        -- NEW PORTS MAPPED HERE:
        master_rx_data => master_rx_data,
        master_rx_done => master_rx_done
    );

    ------------------------------------------------------------------
    -- 100 MHz Clock
    ------------------------------------------------------------------
    clk_process : process
    begin
        while true loop
            clk <= '0';
            wait for 5 ns;
            clk <= '1';
            wait for 5 ns;
        end loop;
    end process;

    ------------------------------------------------------------------
    -- Stimulus
    ------------------------------------------------------------------
    stim_proc : process
    begin

        --------------------------------------------------------------
        -- Reset
        --------------------------------------------------------------
        wait for 20 ns;
        rst <= '0';
        wait for 20 ns;

        --------------------------------------------------------------
        -- Transaction 1: Slave 0 (Sends out A5, Reads back 11)
        --------------------------------------------------------------
        slave_sel <= "00";
        data_in   <= x"A5";

        start_en <= '1';
        wait for 10 ns;
        start_en <= '0';

        wait until done_tx = '1';
        wait for 100 ns;

        --------------------------------------------------------------
        -- Transaction 2: Slave 1 (Sends out 55, Reads back 22)
        --------------------------------------------------------------
        slave_sel <= "01";
        data_in   <= x"55";

        start_en <= '1';
        wait for 100 ns; -- Let selection switch clear completely
        start_en <= '0';

        wait until done_tx = '1';
        wait for 100 ns;

        --------------------------------------------------------------
        -- Transaction 3: Slave 2 (Sends out F0, Reads back 33)
        --------------------------------------------------------------
        slave_sel <= "10";
        data_in   <= x"F0";

        start_en <= '1';
        wait for 100 ns;
        start_en <= '0';

        wait until done_tx = '1';
        wait for 100 ns;

        --------------------------------------------------------------
        -- Finish
        --------------------------------------------------------------
        wait;

    end process;

end Behavioral;