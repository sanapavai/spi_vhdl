
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

entity mosi_shift is
Port (clk,rst: in std_logic;
sclk_tick: in std_logic;
load: in std_logic;
shift_en : in std_logic;
data_in: in std_logic_vector( 7 downto 0);
mosi : out std_logic;
sclk_level : in std_logic
 );
end mosi_shift;
 
architecture Behavioral of mosi_shift is
signal shift_register : std_logic_vector(7 downto 0):=(others=>'0');
begin
mosi<=shift_register(7);   
process(clk,rst)
begin 
if rst='1' then 
shift_register<=(others=>'0');  
elsif rising_edge(clk) then 
if load ='1' then 
shift_register<=data_in;
elsif shift_en='1'and sclk_tick ='1'and sclk_level='0'then  
shift_register<=shift_register(6 downto 0) & '0';
end if ;
end if ;
end process;
end Behavioral;
