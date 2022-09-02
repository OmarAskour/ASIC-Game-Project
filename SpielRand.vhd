----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/15/2021 09:18:36 AM
-- Design Name: 
-- Module Name: SpielRand - Behavioral
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

entity SpielRand is
Port (
    clk25: in std_logic;
    HC:    in integer;
    VC:    in integer;
    resetn:in std_logic;
    RandCol: out std_logic_vector(11 downto 0);
    Exist:   out std_logic
 );
end SpielRand;

architecture Behavioral of SpielRand is


constant Bluesky:  std_logic_vector (11 downto 0) := X"44F";
constant RBreite: integer := 640;
constant Rdicke: integer := 15;


begin

RandCol <= Bluesky;

process(clk25)

begin 

if rising_edge(clk25) then

-- intialPos
  if (VC<15 or VC>464) and HC< 640  then
    Exist <= '1';
  else 
    Exist <= '0';
  end if; 
end if;


end process;



end Behavioral;
