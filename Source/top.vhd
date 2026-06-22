library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top is
Port (
    clk        : in  std_logic;
    rst        : in  std_logic;
    data_in    : in  std_logic_vector(7 downto 0);
    done_tx    : out std_logic;
    sclk       : out std_logic;
    start_en   : in  std_logic;
    slave_sel  : in  std_logic_vector(1 downto 0);
    mosi       : out std_logic;
    cs         : out std_logic_vector(2 downto 0);
    
    -- MOSI Receive Ports (From Slaves to External System)
    data_out   : out std_logic_vector(7 downto 0);
    rx_done    : out std_logic;
    
    -- NEW MISO Receive Ports (Exposed for your Testbench)
    master_rx_data : out std_logic_vector(7 downto 0);
    master_rx_done : out std_logic
);
end top;

architecture Behavioral of top is
    signal shift_en : std_logic;
    signal sclk_tick: std_logic;
    signal load: std_logic;
    signal sclk_level: std_logic;
    signal mosi_int: std_logic;
    signal cs_int: std_logic_vector(2 downto 0);
    
    signal rx_done0, rx_done1, rx_done2 : std_logic;
    signal data_out0, data_out1, data_out2 : std_logic_vector(7 downto 0);
    
    signal miso0, miso1, miso2 : std_logic;
    signal miso_mux             : std_logic;
    signal rx_data_from_slave   : std_logic_vector(7 downto 0);
    signal master_miso_done     : std_logic;
begin

    -- Assign internal signals to top-level output ports
    sclk <= sclk_level;
    mosi <= mosi_int;
    cs   <= cs_int;
    
    -- Connect internal master receiver outputs directly to top-level ports
    master_rx_data <= rx_data_from_slave;
    master_rx_done <= master_miso_done;

    -- 1. Clock Generator Instance
    sclk_inst: entity work.sclk_generator
    port map (
        clk       => clk,
        rst       => rst,
        sclk      => sclk_level,
        sclk_tick => sclk_tick
    );

    -- 2. Master FSM Instance
    miso_fsm_inst: entity work.mosi_fsm
    port map(
        clk       => clk,
        rst       => rst,
        cs        => cs_int,
        start_en  => start_en, 
        sclk_tick => sclk_tick,
        done_tx   => done_tx,
        load      => load,
        shift_en  => shift_en,
        slave_sel => slave_sel
    );

    -- 3. Master Transmitter Shift Register Instance
    miso_shift : entity work.mosi_shift 
    port map(
        clk        => clk,
        rst        => rst,
        sclk_tick  => sclk_tick, 
        load       => load,
        shift_en   => shift_en,
        data_in    => data_in,
        mosi       => mosi_int,
        sclk_level => sclk_level
    );

    -- ==================================================================
    -- SLAVE RECEIVER INSTANCES (MOSI Path)
    -- ==================================================================
    slave0 : entity work.mosi_rx
    port map(
        clk => clk, rst => rst, cs => cs_int(0), sclk => sclk_level, mosi => mosi_int,
        data_out => data_out0, rx_done => rx_done0
    );

    slave1 : entity work.mosi_rx
    port map(
        clk => clk, rst => rst, cs => cs_int(1), sclk => sclk_level, mosi => mosi_int,
        data_out => data_out1, rx_done => rx_done1
    );

    slave2 : entity work.mosi_rx
    port map(
        clk => clk, rst => rst, cs => cs_int(2), sclk => sclk_level, mosi => mosi_int,
        data_out => data_out2, rx_done => rx_done2
    );

    -- ==================================================================
    -- SINGLE MASTER RECEIVER INSTANCE (MISO Path)
    -- ==================================================================
    master_rx_inst : entity work.miso_master_rx
    port map(
        clk            => clk,
        rst            => rst,
        shift_en       => shift_en,
        spi_tick       => sclk_tick,
        sclk_level     => sclk_level,
        miso           => miso_mux, 
        master_rx_data => rx_data_from_slave,
        master_rx_done => master_miso_done
    );

    -- ==================================================================
    -- SLAVE TRANSMITTER INSTANCES (MISO Path)
    -- ==================================================================
    slave0_tx_inst : entity work.miso_slave_tx
    port map(
        clk     => clk, rst => rst, cs => cs_int(0), sclk => sclk_level,
        data_in => x"11", miso => miso0
    );

    slave1_tx_inst : entity work.miso_slave_tx
    port map(
        clk     => clk, rst => rst, cs => cs_int(1), sclk => sclk_level,
        data_in => x"22", miso => miso1
    );

    slave2_tx_inst : entity work.miso_slave_tx
    port map(
        clk     => clk, rst => rst, cs => cs_int(2), sclk => sclk_level,
        data_in => x"33", miso => miso2
    );

    -- ==================================================================
    -- ROUTING MULTIPLEXERS & REGISTERS
    -- ==================================================================
    
    -- Dynamic MISO input multiplexer routing
    with slave_sel select
        miso_mux <= miso0 when "00",
                    miso1 when "01",
                    miso2 when "10",
                    '0'   when others;

    -- Registered latching process for MOSI slave destination outputs
    process(clk, rst)
    begin
        if rst = '1' then
            data_out <= (others => '0');
            rx_done  <= '0';
        elsif rising_edge(clk) then
            rx_done <= '0'; -- Default pulse state
            
            if rx_done0 = '1' then
                data_out <= data_out0;
                rx_done  <= '1';
            elsif rx_done1 = '1' then
                data_out <= data_out1;
                rx_done  <= '1';
            elsif rx_done2 = '1' then
                data_out <= data_out2;
                rx_done  <= '1';
            end if;
        end if;
    end process;

end Behavioral;
