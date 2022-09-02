----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/16/2021 02:26:31 PM
-- Design Name: 
-- Module Name: Random - Behavioral
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

entity lfsr is
    Port (clk,reset : in std_logic;
         seed : in std_logic_vector (9 downto 0);
         random : out std_logic_vector(9 downto 0)
        );
end lfsr;

architecture Behavioral of lfsr is
    signal Currstate, Nextstate: std_logic_vector (9 downto 0);
    signal feedback: std_logic;
begin
    process (clk, reset, seed)
    begin
        if (reset = '0') then
            Currstate <= seed;
        elsif (rising_edge(clk)) then
            Currstate <= Nextstate;
        end if;
    end process;
    
    feedback <= Currstate(8) xor Currstate(4) xor Currstate(0)  ;
    Nextstate <= feedback & currstate (9 downto 1);
    Random <= Currstate;

end Behavioral;
