----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/18/2024 11:34:02 AM
-- Design Name: 
-- Module Name: sim_mul2 - Behavioral
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

use IEEE.numeric_std.ALL;

entity lsfrsim is
--  Port ( );
end lsfrsim;

architecture Behavioral of lsfrsim is
    constant PERIOD: time := 1 ns;
    constant W: integer := 16;
    signal a: std_logic_vector(W-1 downto 0);
    signal b: std_logic;
    signal clk, rst: std_logic;

begin

mylsfr: entity work.mylsfr
    generic map (
        width => W
        )
    port map (
        a => a,
        b => b,
        rst => rst,
        clk => clk
    );    
    
clk_proc: process begin
    clk <= '0';
    wait for PERIOD/2;
    clk <= '1';
    wait for PERIOD/2;
end process;

test_proc: process begin
    a <= "1010110011100001";
    rst <= '1';
    wait until rising_edge(clk);
    rst <= '0';
    wait;
    
end process; 

end Behavioral;

