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

entity Object1 is
    Port (
        clk25: in std_logic;
        HC:    in integer;
        VC:    in integer;
        resetn:in std_logic;
        FC: in integer;
        strobe: in std_logic;
        btnC: in std_logic;
        btnL: in std_logic;
        btnU: in std_logic;
        btnR: in std_logic;
        btnD: in std_logic;
        posin: in integer;
        collall :in std_logic_vector(6 downto 0);
        BallCol: out std_logic_vector(11 downto 0);
        Exist:   out std_logic
    );
end Object1;

architecture Behavioral of Object1 is

    constant Grey:  std_logic_vector (11 downto 0) := X"777";
    constant white:  std_logic_vector (11 downto 0) := X"FFF";

    --signalPosition
    constant StartH: integer := 550;
    constant StartV: integer := 0;
    constant maxrad : integer := 10;

    signal Schuss : std_logic;


begin

    --    process (clk25, resetn)

    --    begin


    --        if rising_edge(clk25) then
    --            if resetn='1' then
    --                Schuss <= '0';
    --            end if;

    --            if btnC = '1' then
    --                Schuss <= '1';
    --            end if;
    --        end if;

    --    end process;

    process(clk25, resetn)

        variable rad: integer range 0 to maxrad;
        variable  newPosx: integer range -650 to 650;
        variable  newPosy: integer range -440 to 440;
        variable  ButPosy: integer range 0 to 440;
        variable newangle: integer range -50 to 50 ;

        variable newDirx : integer range -8 to 8;
        variable newDiry : integer range -8 to 8;
        variable schussBuf: std_logic ;

    begin


        if resetn ='0' then
            newPosx := 0;
            newPosy := 0;
            ButPosy := 230;
            newangle := 0;
            SchussBuf := '0';

        elsif rising_edge(clk25) then

            if btnC = '1' then
                schussBuf := '1';
            end if;

            if strobe ='1' then
                if FC mod 1 = 0 then

                    --Collision
                    if collall(6)='1' then
                       newDirx := -newDirx; --Kicker
                    elsif collall(5)='1' then
                        newDirx := -newDirx; --Abwehr3
                        newDiry := -newDiry;
                    elsif collall(4) = '1' then
                        newDirx := -newDirx; --Torball
                    elsif collall(3) = '1' then
                        newDirx := -newDirx; --Torwand
                    elsif collall(2) = '1' then
                        newDiry := -newDiry;  --Rand
                    elsif collall(1) = '1' then
                        newDirx := -newDirx;
                        newDiry := -newDiry;  --Abwehr1
                    elsif collall(0) = '1' then
                        newDirx := -newDirx;
                        newDiry := -newDiry;  --Abwehr2
                    elsif NewPosx >= 640 then
                        newPosx := 0;
                        newPosy := 0;
                    else
                        newDiry := newDiry;
                    end if;

                    ---- Schuss Einstellung



                    if schussBuf  = '1' then
                        if newPosx< -100 or newPosx > 640 then
                            schussBuf := '0';
                            newPosx := 0;
                            ButPosy := posin;
                            newPosy := posin-ButPosy;
                            newangle := 0;
                        end if;
                        NewPosx := NewPosx + newDirx;
                        NewPosy := NewPosy + newDiry;
                    else

                        if btnU ='1' and ButPosy > 90 then
                            ButPosy :=ButPosy-3 ;
                        elsif ButPosy < 90 then
                            ButPosy := 93;
                        end if;

                        if btnD = '1' and ButPosy <390 then
                            ButPosy :=ButPosy+3 ;
                        elsif ButPosy > 390 then
                            ButPosy := 387;
                        end if;

                        if btnR ='1' and newangle < 50 and FC mod 4 = 0 then
                            newangle :=newangle+10 ;
                        elsif newangle =50 then
                            newangle := 50;
                        end if;

                        if btnL = '1' and newangle > -50 and FC mod 4 = 0 then
                            newangle :=newangle-10 ;
                        elsif newangle = -50 then
                            newangle := -50;
                        end if;


                        case newangle is
                            when 50 => newDirx := 3; newDiry := 5;
                            when 40 => newDirx := 4; newDiry := 4;
                            when 30 => newDirx := 5; newDiry := 3;
                            when 20 => newDirx := 6; newDiry := 2;
                            when 10 => newDirx := 7; newDiry := 1;
                            when 0 => newDirx := 8; newDiry := 0;
                            when -10 => newDirx := 7; newDiry := -1;
                            when -20 => newDirx := 6; newDiry := -2;
                            when -30 => newDirx := 5; newDiry := -3;
                            when -40 => newDirx := 4; newDiry := -4;
                            when -50 => newDirx := 3; newDiry := -5;
                            when others => newDirx := 8; newDiry := 0;
                        end case;
                    end if;


                end if;

                --                if newPosx < 50 or newPosx > 640 then
                --                    schussBuf := '0';
                --                end if;
            end if;

            --Richtungspunkt
            if (((HC - (StartH-30))**2 + (VC-StartV- newDiry*10 - ButPosy)**2) <= (maxrad/3)**2) and schussBuf  = '0' then
                Exist <= '1';
                BallCol<= white;


            -- Ball
            elsif ((HC - StartH+newPosx)**2 + (VC-StartV- newPosy- ButPosy)**2) <= maxrad**2 then
                BallCol <= Grey;
                Exist <= '1';
            else
                Exist <= '0';
            end if;


        end if;

    end process;

end Behavioral;
