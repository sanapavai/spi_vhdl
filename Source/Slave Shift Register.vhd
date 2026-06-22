----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 13.06.2026 17:46:19
-- Design Name: 
-- Module Name: mosi_rx - Behavioral
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

entity mosi_rx is
Port (clk,rst : in std_logic;
cs: in std_logic;
sclk : in std_logic;
mosi: in std_logic;
data_out: out std_logic_vector(7 downto 0);
rx_done: out std_logic );
end mosi_rx;
 
architecture Behavioral of mosi_rx is
signal sclk_rising : std_logic;
signal sclk_failing: std_logic;
signal bit_count : integer  range 0 to 7 :=0;
signal shift_reg : std_logic_vector(7 downto 0);
begin
sclk_rising<=sclk and not (sclk_failing);
process(clk,rst)
begin
if rst='1' then 
shift_reg<=(others=>'0');
sclk_failing<='0';
rx_done<='0';
data_out<= (others=>'0');
elsif rising_edge(clk) then 
sclk_failing<=sclk;
if cs='0' then 
if sclk_rising ='1' then 
shift_reg<=shift_reg(6 downto 0) & mosi;
if bit_count=7 then 
rx_done<='1';
data_out<=shift_reg(6 downto 0)& mosi ;
bit_count<=0;
else
bit_count<=bit_count+1;
end if ;
end if ;
else
bit_count<=0;
rx_done<='0';
end if ;
end if ;
end process;
end Behavioral;
