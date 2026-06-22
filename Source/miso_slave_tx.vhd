library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity miso_slave_tx is
    Port (
        clk        : in  std_logic;
        rst        : in  std_logic;
        cs         : in  std_logic;                    -- Acts as your shift_en/activate signal
        sclk       : in  std_logic;                    -- The physical external SPI clock wire
        data_in    : in  std_logic_vector(7 downto 0); -- The byte this slave wants to send
        miso       : out std_logic
    );
end miso_slave_tx;
 
architecture Behavioral of miso_slave_tx is
    signal shift_register : std_logic_vector(7 downto 0) := (others => '0');
    signal sclk_delayed   : std_logic := '0';
    signal sclk_fall      : std_logic;
    signal bit_cnt        : integer range 0 to 7 := 0;
begin

    -- Detect the physical falling edge of the master's SCLK line
    sclk_fall <= (not sclk) and sclk_delayed;

    -- CRITICAL: Disconnect from MISO bus ('Z') if this specific slave is not active
    miso <= shift_register(7) when cs = '0' else 'Z';   

    process(clk, rst)
    begin 
        if rst = '1' then 
            shift_register <= (others => '0');  
            sclk_delayed   <= '0';
            bit_cnt        <= 0;
        elsif rising_edge(clk) then 
            sclk_delayed <= sclk; -- Keep tracking the clock line history

            if cs = '0' then
                -- 1. Load data at the exact beginning before any clock transitions occur
                if bit_cnt = 0 and sclk_delayed = '0' and sclk = '0' then
                    shift_register <= data_in;
                
                -- 2. Shift out data on every falling edge of sclk
                elsif sclk_fall = '1' then
                    if bit_cnt < 7 then
                        shift_register <= shift_register(6 downto 0) & '0';
                        bit_cnt        <= bit_cnt + 1;
                    else
                        bit_cnt <= 0; -- Reset counter automatically after 8 bits are sent
                    end if;
                end if;
            else
                bit_cnt <= 0; -- Reset if the Master abruptly drops CS high
            end if;
        end if;
    end process;
end Behavioral;
