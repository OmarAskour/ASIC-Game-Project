----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/14/2021 10:15:37 AM
-- Design Name: 
-- Module Name: TopModule - Behavioral
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
use ieee.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity TopModule is


    Port (
        clk :in std_logic;
        btnCpuReset: in std_logic;
        btnC: in std_logic;
        btnL: in std_logic;
        btnU: in std_logic;
        btnR: in std_logic;
        btnD: in std_logic;
        sw : in std_logic_vector (15 downto 0);
        PS2Clk : inout std_logic;
        PS2Data : inout std_logic;
        Hsync: out std_logic;
        Vsync: out std_logic;

        vgaRed: out std_logic_vector(3 downto 0);
        vgaGreen: out std_logic_vector(3 downto 0);
        vgaBlue: out std_logic_vector(3 downto 0)

    );
end TopModule;

architecture Behavioral of TopModule is

    --Constants :
    constant H_PMax : integer := 800;
    constant V_PMax : integer := 525;
    constant black:  std_logic_vector (11 downto 0) := X"000";
    constant red:  std_logic_vector (11 downto 0) := X"F25";
    constant blue:  std_logic_vector (11 downto 0) := X"00F";
    constant Green:  std_logic_vector (11 downto 0) := X"0F0";



    --Signals:

    signal clk25 : std_logic;
    signal resetn : std_logic;
    signal Farbe: std_logic_vector (11 downto 0);
    signal FC : integer range 0 to 1023;
    signal HC : integer range 1 to 800;
    signal VC : integer range 1 to 525;
    signal strobe : std_logic := '0' ;
    signal tempfarbe: std_logic_vector (11 downto 0); --Mux signal Farbe
    signal extemp : std_logic_vector (8 downto 0); --select signal
    signal colsw : std_logic;
    signal possw : std_logic;
    signal collab3 : std_logic_vector(2 downto 0);  --collabwehr3
      signal collbal : std_logic_vector(6 downto 0);  --collball

    --Object1:
    signal Ballcol :  std_logic_vector(11 downto 0);
    signal ExBall : std_logic;

    --Spielrand
    signal Randcol :  std_logic_vector(11 downto 0);
    signal ExRand : std_logic;

    --Abwehr1
    signal AB1col :  std_logic_vector(11 downto 0);
    signal Ex1Abw : std_logic;

    --Abwehr2
    signal AB2col :  std_logic_vector(11 downto 0);
    signal Ex2Abw : std_logic;

    --Abwehr3
    signal AB3col :  std_logic_vector(11 downto 0);
    signal Ex3Abw : std_logic;

    --Torwand
    signal Torwcol :  std_logic_vector(11 downto 0);
    signal ExTorw : std_logic;


    --Kicker
    signal kkwcol :  std_logic_vector(11 downto 0);
    signal Exkk : std_logic;
    signal kickposout: integer;

    --Torball
    signal Torcol :  std_logic_vector(11 downto 0);
    signal Extor : std_logic;
    signal ExNetz : std_logic;

    --Zufall
    signal seed :  std_logic_vector(9 downto 0);
    signal random : std_logic_vector(9 downto 0);

    --Mouse
    signal mouseleft : std_logic;
    signal mousemiddle : std_logic;
    signal mousenew_event : std_logic;
    signal mouseright : std_logic;
    signal mousexpos : std_logic_vector (9 downto 0);
    signal mouseypos : std_logic_vector (9 downto 0);
    signal mousezpos : std_logic_vector (3 downto 0);




    -- Components 

    component clk_wiz_0 --IPclk
        port(
            clk_out1: out std_logic ;
            resetn: in std_logic ;
            clk_in1 : in std_logic);
    end component;

    component Object1 --BaLL
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
            Exist:   out std_logic);
    end component;

    component SpielRand --Rand
        Port (
            clk25: in std_logic;
            HC:    in integer;
            VC:    in integer;
            resetn:in std_logic;
            RandCol: out std_logic_vector(11 downto 0);
            Exist:   out std_logic
        );
    end component;

    component Abwehr1 --Abwehr Spieler 1

        Port (
            clk25: in std_logic;
            HC:    in integer;
            VC:    in integer;
            FC:    in integer;
            strobe:in std_logic;
            resetn:in std_logic;
            Ab1Col: out std_logic_vector(11 downto 0);
            colswitcher: in std_logic;
            Exist:   out std_logic
        );
    end component;

    component Abwehr2 --Abwehr Spieler 2

        Port (
            clk25: in std_logic;
            HC:    in integer;
            VC:    in integer;
            FC:    in integer;
            strobe:in std_logic;
            resetn:in std_logic;
            Ab2Col: out std_logic_vector(11 downto 0);
            colswitcher: in std_logic;
            Exist:   out std_logic
        );
    end component;



    component Abwehr3 --Abwehr Spieler 3

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
    end component;


    component Torball -- Tor
        Port (
            clk25: in std_logic;
            HC:    in integer;
            VC:    in integer;
            resetn:in std_logic;
            TorCol: out std_logic_vector(11 downto 0);
            ExistTor:   out std_logic;
            ExistNetz:   out std_logic
        );
    end component;

    component lfsr
        Port (
            clk,reset : in std_logic;
            seed : in std_logic_vector (9 downto 0);
            random : out std_logic_vector(9 downto 0)
        );
    end component;

    component MouseRefComp   -- Mouse
        port ( CLK        : in    std_logic;
             RESOLUTION : in    std_logic;
             RST        : in    std_logic;
             SWITCH     : in    std_logic;
             LEFT       : out   std_logic;
             MIDDLE     : out   std_logic;
             NEW_EVENT  : out   std_logic;
             RIGHT      : out   std_logic;
             XPOS       : out   std_logic_vector (9 downto 0);
             YPOS       : out   std_logic_vector (9 downto 0);
             ZPOS       : out   std_logic_vector (3 downto 0);
             PS2_CLK    : inout std_logic;
             PS2_DATA   : inout std_logic);

    end component;

    component Torwand   -- Torwand
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
            poswitch : in std_logic;
            Exist:   out std_logic
        );


    end component;


    component  kicker  --Kicker
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
    end component;




begin

    -- Para
    colsw <= sw(0); --switsch0
    possw  <= sw(1); --switch1

    resetn <= btnCpuReset;
    vgaRed <= farbe (11 downto 8);
    vgagreen <= farbe (7 downto 4);
    vgablue <= farbe (3 downto 0);
    seed <= "0110011001";

    -- component map

    CLkPix:clk_wiz_0
        port map ( clk_out1 => clk25,
                 resetn => resetn,
                 clk_in1 => clk  );


    ball: Object1
        port map (
            clk25=> clk25,
            HC => HC,
            VC => VC,
            resetn => resetn,
            FC => FC,
            strobe => strobe,
            btnC => btnC,
            btnL => btnL,
            btnU => btnU,
            btnR => btnR,
            btnD => btnD,
            posin => kickposout,
            collall => collbal,
            BallCol => Ballcol,
            Exist => ExBall);

    Rand: SpielRand
        Port map (
            clk25 =>clk25,
            HC => HC,
            VC =>Vc ,
            resetn =>resetn,
            RandCol => Randcol,
            Exist => ExRand
        );

    AbwehrS1: Abwehr1

        Port map (
            clk25 =>clk25,
            HC => HC,
            VC =>Vc ,
            FC => FC,
            strobe => strobe,
            resetn => resetn,
            Ab1Col => AB1col,
            colswitcher => colsw ,
            Exist => Ex1Abw
        );

    AbwehrS2: Abwehr2

        Port map (
            clk25 =>clk25,
            HC => HC,
            VC =>Vc ,
            FC => FC,
            strobe => strobe,
            resetn => resetn,
            Ab2Col => AB2col,
            colswitcher => colsw ,
            Exist => Ex2Abw
        );




    AbwehrS3: Abwehr3

        Port map (
            clk25 =>clk25,
            HC => HC,
            VC =>Vc ,
            FC => FC,
            strobe => strobe,
            resetn => resetn,
            rand => random,
            Ab3Col => AB3col,
            collall => collab3,
            colswitcher => colsw ,
            poswitch => possw ,
            Exist => Ex3Abw
        );

    TorBal: Torball
        Port map (
            clk25 =>clk25,
            HC => HC,
            VC =>Vc ,
            resetn =>resetn,
            TorCol => Torcol,
            ExistTor => Extor,
            ExistNetz=> ExNetz
        );

    Zufall: lfsr
        Port map(clk => clk25,
                 reset => resetn,
                 seed => seed,
                 random => random
                );

    Maus: MouseRefComp
        port map( CLK       =>clk,
                 RESOLUTION => '0',
                 RST        => possw,--evtl anderen Button
                 SWITCH     => '0',
                 LEFT       => mouseleft,
                 MIDDLE     => mousemiddle,
                 NEW_EVENT  => mousenew_event,
                 RIGHT      => mouseright,
                 XPOS       => mousexpos,
                 YPOS       => mouseypos,
                 ZPOS       => mousezpos,
                 PS2_CLK   => PS2Clk ,
                 PS2_DATA  => PS2Data);


    TorwandM : Torwand
        Port map (
            clk25 =>clk25,
            HC => HC,
            VC =>Vc ,
            FC => FC,
            strobe => strobe,
            resetn => resetn,
            mouseypos => mouseypos,
            TorwandCol =>  Torwcol,
            colswitcher => colsw,
            poswitch => possw ,
            Exist => ExTorw
        );



    Kickermann : kicker
        Port map (
            clk25 =>clk25,
            HC => HC,
            VC =>Vc ,
            FC => FC,
            strobe => strobe,
            resetn => resetn,
            btnU => btnU,
            btnD => btnD,
            kkCol => kkwcol,
            posout => kickposout,
            colswitcher => colsw,
            Exist => Exkk
        );



    Counters: process(clk25,resetn)
    begin

        if (resetn = '0') then
            FC <= 0;
            HC <= 1;
            VC <= 1;
            strobe <= '0';

        elsif rising_edge(clk25) then
            strobe <= '0';

            if HC < H_PMax  then
                HC <= HC +1;
            else
                HC <= 1;
                if VC < V_PMax then
                    VC <= VC + 1;
                else
                    VC <= 1;
                    strobe <= '1';
                    if FC < 1023 then
                        FC <= FC + 1;
                    else
                        FC <= 0;
                    end if;
                end if;
            end if  ;
        end if;
    end process Counters;

    extemp <= (ExBall, ExRand, Ex1Abw, Ex2Abw, Ex3Abw, Extor, ExTorw,Exkk, ExNetz) ; -- noch Abwehr3 


    Display: process(HC, VC, strobe, extemp, Ballcol,Randcol,AB1col,AB2col,AB3col,Torwcol,Torcol,kkwcol, tempfarbe)


    begin


        -- Hsync
        if (HC <= 656 or HC > 751) then
            Hsync <= '1';
        else
            Hsync <= '0';
        end if;


        -- Vsync
        if (VC <= 490 or VC > 492) then
            Vsync <= '1';
        else
            Vsync <= '0';
        end if;

        -- Blanking
        If HC > 640 or VC > 480 then
            Farbe <= black;
        else
            Farbe <= tempFarbe;
        end if;


        --Displaying
        case extemp is

            when "100000000" => tempfarbe <= Ballcol;
            when "010000000" => tempfarbe <= Randcol;
            when "001000000" => tempfarbe <= AB1col;
            when "000100000" => tempfarbe <= AB2col;
            when "000010000" => tempfarbe <= AB3col;
            when "000000100" => tempfarbe <= Torwcol;
            when "000001000" => tempfarbe <= Torcol;
            when "000000001" => tempfarbe <= Torcol;
            when "000000000"  => tempfarbe <= Green;
            when "000000010"  => tempfarbe <= kkwcol;
            when others =>  tempfarbe <= red;

        end case ;


    end process Display;

    Kollision: process(clk25, strobe, collab3)
    begin


        if rising_edge(clk25) then
            --coll Abwehr3
            if extemp(7)='1' and  extemp(4)='1'then
                collab3(2) <= '1'; --Rand
            elsif extemp(6)='1' and  extemp(4)='1'then
                collab3(1) <= '1';  --Abwehr1
            elsif extemp(5)='1' and  extemp(4)='1'then
                collab3(0) <= '1' ; --Abwehr2
              end if;

            --CollBall
            if extemp(1)='1' and  extemp(8)='1'then
                collbal(6) <= '1' ; --Kicker
            elsif extemp(4)='1' and  extemp(8)='1'then
                collbal(5) <= '1' ; --Abwehr3
            elsif extemp(3)='1' and  extemp(8)='1'then
                collbal(4) <= '1' ; --Torball
            elsif extemp(2)='1' and  extemp(8)='1'then
                collbal(3) <= '1' ; --Torwand
            elsif extemp(7)='1' and  extemp(8)='1'then
                collbal(2) <= '1'; --Rand
            elsif extemp(6)='1' and  extemp(8)='1'then
                collbal(1) <= '1';  --Abwehr1
            elsif extemp(5)='1' and  extemp(8)='1'then
                collbal(0) <= '1' ; --Abwehr2
            end if;

            if strobe = '1' then

                collab3 <= "000";
                collbal <= "0000000";

            end if;

        end if;
    end process Kollision;

end Behavioral;
