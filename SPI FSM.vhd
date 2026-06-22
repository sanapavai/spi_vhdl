----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 13.06.2026 13:03:31
-- Design Name: 
-- Module Name: miso_fsm - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------
 

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity mosi_fsm is
Port (clk,rst : in std_logic;
cs : out std_logic_vector(2 downto 0);
slave_sel : in std_logic_vector(1 downto 0);
sclk_tick: in std_logic;
start_en : in std_logic;
done_tx: out std_logic;
load: out std_logic;
shift_en: out std_logic
 );
end mosi_fsm;

architecture Behavioral of mosi_fsm is
signal bit_count : integer range 0 to 15:=0; 
type state_type is (IDLE,START, TRANSFER,DONE);
signal state: state_type:=IDLE;
begin
process(clk,rst)
begin
if rst='1' then 
load<='0';
done_tx<='0';
bit_count<=0;
cs<="111";
state<=IDLE;
shift_en<='0';
elsif falling_edge(clk) then 
case(STATE) is
when IDLE=> 
done_tx <= '0';
bit_count <= 0;
shift_en <= '0';
load <= '0';
if start_en='1'then
state<=START;
cs<="111";
else
state<=IDLE;
end if ;
when START=>
load<='1';
case slave_sel is
    when "00" => cs <= "110";  -- Slave0 selected
    when "01" => cs <= "101";  -- Slave1 selected
    when "10" => cs <= "011";  -- Slave2 selected
    when others => cs <= "111";
end case;
state<=TRANSFER;
when TRANSFER =>
case slave_sel is
    when "00" => cs <= "110";  -- Slave0 selected
    when "01" => cs <= "101";  -- Slave1 selected
    when "10" => cs <= "011";  -- Slave2 selected
    when others => cs <= "111";
end case;
shift_en<='1';
load<='0';
if sclk_tick='1' then 
if bit_count= 15 then 
shift_en <='0';
state<=DONE;
else
bit_count<=bit_count+1;
state<=TRANSFER;
end if ;
end if ;
when DONE=>
done_tx<='1';
cs<="111";
state<=IDLE;
shift_en <= '0';
when others =>
                    state <= IDLE;
end case;
end if ;
end process;
end Behavioral;
