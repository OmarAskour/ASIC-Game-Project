----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/15/2021 09:46:43 AM
-- Design Name: 
-- Module Name: Hindernisse - Behavioral
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

entity Hindernisse is

    Port (
        clk25: in std_logic;
        HC:    in integer;
        VC:    in integer;
        FC: in integer;
        strobe: in std_logic;
        resetn:in std_logic;
        AB1Col: out std_logic_vector(11 downto 0);
        colswitcher: in std_logic;
        Exist:   out std_logic
    );

end Hindernisse;

architecture Behavioral of Hindernisse is



    constant StartHo: integer := 280;
    constant StartHu: integer := 280;
    constant StartVu: integer := 0;
    constant  StartVo: integer := 0;
    constant maxrad : integer := 10;


    constant Black:  std_logic_vector (11 downto 0) := X"000";
    constant Red:  std_logic_vector (11 downto 0) := X"F00";
    constant yellow:  std_logic_vector (11 downto 0) := X"FF0";



    signal temp : integer ;


begin


    process(clk25)

        variable switchDirO : integer := 51;
        variable switchDirU : integer := 276;
        variable switchDir : integer := 1;

    begin


        if rising_edge(clk25) then
            if strobe ='1' then
                if FC mod 2 = 0 then
            
                       if switchDirO > 50 and switchDirO < 205 then

                         switchDirO := switchDirO +switchDir;
                       
                       else
                    
                          switchDir := - switchDir ;
                          switchDirO := switchDirO - switchDir;
                        
                       end if;
                    
                       if switchDirU < 430 and switchDirU > 275 then
                       
                       switchDirU := switchDirU +switchDir;
                       
                       else 
                        
                       switchDir := - switchDir;
                       switchDirU := switchDirU +switchDir;
                       
                       end if ;

                end if;
            end if;



            if (((HC - StartHo)**2 + (VC -StartVo -switchDirO)**2 ) <= (maxrad+3)**2 ) or (((HC - StartHu)**2 + ((VC -StartVu+switchDirU)**2) <= (maxrad+3)**2 ))then
                Exist <= '1';
                HindCol <= Black;


            elsif (((HC - StartHo)*2)**2 + ((VC -StartVo -switchDirO)**2) <= (maxrad*3)**2) or ((((HC - StartHu)*2)**2 + ((VC-StartVu+switchDirU)**2) <= (maxrad*3)**2))then
                Exist <= '1';
                if colswitcher='1' then
                    HindCol <= red;
                else
                    HindCol <= yellow;
                end if;
            else
                Exist <= '0';
            end if;









        end if;


    end process;


end Behavioral;
