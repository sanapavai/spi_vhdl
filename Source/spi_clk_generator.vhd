----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11.06.2026 16:12:10
-- Design Name: 
-- Module Name: sclk_generator - Behavioral
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

entity sclk_generator is
Port (clk,rst : in std_logic;
sclk: out std_logic;
sclk_tick: out std_logic );
end sclk_generator;

architecture Behavioral of sclk_generator is
constant max_count : integer :=49; 
signal count : integer:=0;
signal sclk_reg: std_logic :='0';
signal sclk_tick_reg: std_logic :='0';
begin
sclk<=sclk_reg;
sclk_tick<=sclk_tick_reg;
process(clk,rst)
begin
if rst ='1'then 
count<=0;
sclk_tick_reg<='0';
sclk_reg<='0';
elsif rising_edge(clk)then
sclk_tick_reg<='0';
if count=max_count then  
sclk_reg <=not( sclk_reg);
sclk_tick_reg<='1';
count<=0;
else
count<=count+1;
end if ;
end if ;
end process;
end Behavioral;
