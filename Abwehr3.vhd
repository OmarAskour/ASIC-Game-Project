---------------------------------------------------------------------------------
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
USE ieee.numeric_std.ALL;


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Abwehr3 is

    Port (
        clk25: in std_logic;
        HC:    in integer;
        VC:    in integer;
        FC: in integer;
        strobe: in std_logic;
        resetn:in std_logic;
        rand: in std_logic_vector (9 downto 0);
        AB3Col: out std_logic_vector(11 downto 0);
        collall :in std_logic_vector(2 downto 0);
        colswitcher: in std_logic;
        poswitch : in std_logic;
        Exist:   out std_logic
    );

end Abwehr3;

architecture Behavioral of Abwehr3 is

    constant maxrad : integer := 10;


    constant Black:  std_logic_vector (11 downto 0) := X"000";
    constant Red:  std_logic_vector (11 downto 0) := X"F00";
    constant yellow:  std_logic_vector (11 downto 0) := X"FF0";

    --Startposition random
    signal randcov : integer range 200 to 400;

    --Richtung random
    signal xdir : integer range 0 to 3;
    signal ydir : integer range 0 to 3;

begin
    randcov <= to_integer(unsigned(rand(4 downto 0)));
    xdir <= to_integer(unsigned(rand(1 downto 0)));
    ydir <= to_integer(unsigned(rand(3 downto 2)));


    process(randcov)


    begin

        if randcov> 400 then
            randcov <= randcov - 112;
        elsif randcov < 200 then

            randcov <= randcov + 200;
        end if;

    end process;




    process(clk25, poswitch, randcov, xdir, ydir)

        variable NewPosx : integer range 0 to 640;
        variable NewPosy : integer range 0 to 480;

        variable newDirx : integer range -3 to 3;
        variable newDiry : integer range -3 to 3;

    begin



        if poswitch ='1' then

            NewPosx := 320;
            NewPosy := 240;
            newDirx := xdir;
            newDiry := ydir;

        elsif rising_edge(clk25) then
            if strobe ='1' then
                if FC mod 1 = 0 then
                    --                    if newPosx < 200 or newPosx > 400 then
                    --                       -- newDirx := -newDirx;
                    --                    else


                    if collall(2)='1' then
                        newDiry := -newDiry ;--Rand
                    elsif collall(1) = '1' then
                        newDirx := -newDirx;
                        newDiry := -newDiry; --AB3Col
                    elsif collall="001" then
                        newDirx := -newDirx;
                        newDiry := -newDiry; --Abwehr2
                    elsif NewPosx <=150 or Newposx >= 500 then
                        newDirx := -newDirx;
                    else
                        newDiry := newDiry;
                    end if;


                    --                    end if;


                    NewPosx := NewPosx + newDirx;
                    NewPosy := NewPosy + newDiry;

                end if;
            end if;


            if (((HC-NewPosx)**2 + (VC -NewPosy)**2 ) <= (maxrad+3)**2 ) then
                Exist <= '1';
                AB3Col<= Black;


            elsif (((HC -NewPosx)*2)**2 + ((VC-NewPosy)**2) <= (maxrad*3)**2) then
                Exist <= '1';
                if colswitcher='1' then
                    AB3Col<= red;
                else
                    AB3Col <= yellow;
                end if;
            else
                Exist <= '0';
            end if;


        end if;


    end process;



end Behavioral;