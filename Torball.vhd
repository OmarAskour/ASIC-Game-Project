----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/15/2021 10:45:55 AM
-- Design Name: 
-- Module Name: Torball - Behavioral
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

entity Torball is
Port (
   clk25: in std_logic;
    HC:    in integer;
    VC:    in integer;
    resetn:in std_logic;
    TorCol: out std_logic_vector(11 downto 0);
    ExistTor:   out std_logic;
    ExistNetz:   out std_logic


 );
end Torball;

architecture Behavioral of Torball is


constant white:  std_logic_vector (11 downto 0) := X"FFF";
constant lightgrey: std_logic_vector (11 downto 0) := X"AAA";
constant blue: std_logic_vector (11 downto 0) := X"44F";

begin



process(clk25)

begin 

if rising_edge(clk25) then

-- intialPos
  if ((VC<440 and VC>40) and (HC>5 and HC < 15)) then--Latte
    ExistTor <= '1';
    TorCol <= white;
  elsif ((VC<40 and VC>=15) or  (VC<465 and VC>440)) and (HC>50 and HC<=60) then--Ecke
    ExistTor <= '1';
    TorCol <= white;
  elsif ((VC<50 and VC>40) or  (VC<440 and VC>430)) and (HC>=15 and HC<=60) then--Pfosten
    ExistTor <= '1';
    TorCol <= white;
    
  --Netz 
  elsif ((VC>40 and VC<430) and (HC >15 and HC<50) and (VC mod 8 = 0)) or 
        ((HC>15 and HC<50) and (VC >40 and VC<430) and (HC mod 8 = 0)) then 
        ExistNetz <= '1';
        TorCol <= lightgrey; 
        
--  elsif (HC>15 and HC<50) and (VC >40 and VC<430) and (HC mod 8 = 0)then--Netz  
--        Exist <= '1';
--        TorCol <= lightgrey;
 

  else 
    ExistTor <= '0';
    ExistNetz <= '0';
  end if; 
end if;

end process;




end Behavioral;
