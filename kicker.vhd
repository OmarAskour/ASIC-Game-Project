----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/14/2021 03:07:51 PM
-- Design Name: 
-- Module Name: Object1 - Behavioral
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

entity kicker is
    Port (
        clk25: in std_logic;
        HC:    in integer;
        VC:    in integer;
        resetn:in std_logic;
        FC: in integer;
        strobe: in std_logic;
        btnU: in std_logic;
        btnD: in std_logic;
        kkCol: out std_logic_vector(11 downto 0);
        posout: out integer;
        colswitcher: in std_logic;
        Exist:   out std_logic
    );
end kicker;

architecture Behavioral of kicker is


    constant Black:  std_logic_vector (11 downto 0) := X"000";
    constant Red:  std_logic_vector (11 downto 0) := X"F00";
    constant yellow:  std_logic_vector (11 downto 0) := X"FF0";
    constant white:  std_logic_vector (11 downto 0) := X"FFF";
    --signalPosition
    constant StartH: integer :=600;
    constant StartV: integer := 0;
    constant maxrad : integer := 10;

    
begin



    process(clk25, resetn)

        variable rad: integer range 0 to maxrad;
        variable  newPos: integer range 50 to 430;

    begin


        if resetn ='0' then
            newPos := 230;


        elsif rising_edge(clk25) then

            if strobe ='1' then
                if FC mod 1 = 0 then

                    if btnU ='1' and newPos > 90 then
                        newPos :=newPos-3 ;
                    elsif newPos < 90 then
                        newPos := 93;
                    end if;

                    if btnD = '1' and newPos <390 then
                        newPos :=newPos+3 ;
                    elsif newPos >390 then
                        newPos := 387;
                    end if;
                end if;
            end if;
            
            
            
--              if ((HC - (StartH+90))**2 + (VC-StartV- newPos)**2) <= (maxrad/3)**2 then
--                Exist <= '1';
--                kkCol<= white;
--            end if;


            if ((HC - StartH)**2 + (VC-StartV- newPos)**2) <= (maxrad+3)**2  then
                Exist <= '1';
                kkCol<= Black;
            elsif (((HC -StartH)*2)**2 + ((VC-newPos)**2) <= (maxrad*3)**2) then
                Exist <= '1';
                if colswitcher='1' then
                    kkCol<= yellow;

                else
                    kkCol<= red;
                end if;

            else
                Exist <= '0';
            end if;


            posout <= newPos;


        end if;

    end process;

   
end Behavioral;
