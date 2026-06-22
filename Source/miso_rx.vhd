library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity miso_master_rx is
    Port (
        clk            : in  std_logic;
        rst            : in  std_logic;
        shift_en       : in  std_logic;                    -- From Master FSM
        spi_tick       : in  std_logic;                    -- From Clock Generator
        sclk_level     : in  std_logic;                    -- Master SCLK internal level
        miso           : in  std_logic;                    -- Multiplexed MISO input wire
        master_rx_data : out std_logic_vector(7 downto 0); -- Final byte received from active slave
        master_rx_done : out std_logic                     -- Data valid verification pulse
    );
end miso_master_rx;

architecture Behavioral of miso_master_rx is
    signal rx_shift_reg : std_logic_vector(7 downto 0) := (others => '0');
    signal bit_cnt      : integer range 0 to 7 := 0;
begin

    process(clk, rst)
    begin
        if rst = '1' then
            rx_shift_reg   <= (others => '0');
            master_rx_data <= (others => '0');
            master_rx_done <= '0';
            bit_cnt        <= 0;
        elsif rising_edge(clk) then
            master_rx_done <= '0'; -- Stays high for exactly one clock cycle pulse

            if shift_en = '1' then
                -- SPI Mode 0: Sample MISO line on the RISING edge phase of SCLK
                if spi_tick = '1' and sclk_level = '1' then
                    rx_shift_reg <= rx_shift_reg(6 downto 0) & miso;

                    if bit_cnt = 7 then
                        master_rx_data <= rx_shift_reg(6 downto 0) & miso; -- Latch the completed byte
                        master_rx_done <= '1';                             -- Trigger done strobe
                        bit_cnt        <= 0;
                    else
                        bit_cnt <= bit_cnt + 1;
                    end if;
                end if;
            else
                bit_cnt <= 0;
            end if;
        end if;
    end process;
end Behavioral;
