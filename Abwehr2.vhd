----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/16/2021 01:10:56 PM
-- Design Name: 
-- Module Name: Abwehr1 - Behavioral
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

entity Abwehr2 is

    Port (
        clk25: in std_logic;
        HC:    in integer;
        VC:    in integer;
        FC: in integer;
        strobe: in std_logic;
        resetn:in std_logic;
        AB2Col: out std_logic_vector(11 downto 0);
        colswitcher: in std_logic;
        Exist:   out std_logic
    );

end Abwehr2;

architecture Behavioral of Abwehr2 is

    constant StartH: integer := 280;
    constant StartV: integer := 0;
    constant maxrad : integer := 10;


    constant Black:  std_logic_vector (11 downto 0) := X"000";
    constant Red:  std_logic_vector (11 downto 0) := X"F00";
    constant yellow:  std_logic_vector (11 downto 0) := X"FF0";


begin



    process(clk25, resetn)

        variable NewPos : integer range 275 to 430;

        variable switchDir : integer range -1 to 1;

    begin

        if resetn ='0' then

            NewPos := 428;
            switchDir := 1;

        elsif rising_edge(clk25) then
            if strobe ='1' then
                if FC mod 2 = 0 then

                    if NewPos = 276 or  NewPos = 429 then

                        switchDir := - switchDir ;

                    end if;
                    NewPos:= NewPos - switchDir;

                end if;
            end if;



            if (((HC - StartH)**2 + (VC -StartV -NewPos)**2 ) <= (maxrad+3)**2 ) then
                Exist <= '1';
                AB2Col<= Black;


            elsif (((HC - StartH)*2)**2 + ((VC -StartV -NewPos)**2) <= (maxrad*3)**2) then
                Exist <= '1';
                if colswitcher='1' then
                    AB2Col<= red;
                else
                    AB2Col <= yellow;
                end if;
            else
                Exist <= '0';
            end if;


        end if;


    end process;



end Behavioral;