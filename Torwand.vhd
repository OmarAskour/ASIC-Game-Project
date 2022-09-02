----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/17/2021 10:55:59 AM
-- Design Name: 
-- Module Name: Torwand - Behavioral
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

entity Torwand is


    Port (
        clk25: in std_logic;
        HC:    in integer;
        VC:    in integer;
        FC: in integer;
        strobe: in std_logic;
        resetn:in std_logic;
        mouseypos: in std_logic_vector(9 downto 0);
        TorwandCol: out std_logic_vector(11 downto 0);
        colswitcher: in std_logic;
        poswitch: in std_logic;
        Exist:   out std_logic
    );


end Torwand;

architecture Behavioral of Torwand is


    --    constant StartHo: integer := 280;
    --    constant StartHu: integer := 280;
    --    constant StartVu: integer := 0;

    constant  torwPos: integer := 75;
    constant maxrad : integer := 10;
    constant Black:  std_logic_vector (11 downto 0) := X"000";
    constant Red:  std_logic_vector (11 downto 0) := X"F00";
    constant yellow:  std_logic_vector (11 downto 0) := X"FF0";



begin


    process(clk25, poswitch)

        variable torypos : integer range 50 to 430;

    begin
    
        if poswitch ='1' then

            torypos := 230;


        elsif rising_edge(clk25) then



            -- outside area
                        if to_integer(unsigned(mouseypos)) > 50 and to_integer(unsigned(mouseypos)) < 430 then
                            torypos := to_integer(unsigned(mouseypos));
                        elsif to_integer(unsigned(mouseypos)) > 430 then
                            torypos := 430;
                        elsif to_integer(unsigned(mouseypos)) <50 then
                            torypos := 50;
                        end if;




           -- if vc > 50 and Vc < 430 then
            -- Normal area
            if ((HC - torwPos)**2 + ((VC - torypos)**2 ) <= (maxrad+3)**2 ) then

                Exist <= '1';
                TorwandCol <= Black;


            elsif (((HC - torwPos)*2)**2 + ((VC -torypos)**2) <= (maxrad*3)**2) then
                Exist <= '1';
                if colswitcher='1' then
                    TorwandCol <= red;
                else
                    TorwandCol <= yellow;
                end if;
            else
                Exist <= '0';
            end if;



            --            end if;
        end if;

    end process;

end Behavioral;
