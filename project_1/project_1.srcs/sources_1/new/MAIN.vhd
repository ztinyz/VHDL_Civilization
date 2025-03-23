----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/12/2020 06:54:35 PM
-- Design Name: 
-- Module Name: vga - Behavioral
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


library ieee;
  use ieee.std_logic_1164.all;

  use ieee.std_logic_unsigned.all;
  use ieee.numeric_std.all;

entity vga is
    Port ( 
           clk : in STD_LOGIC;
           btn : in STD_LOGIC_VECTOR (4 downto 0);
           sw : in STD_LOGIC_VECTOR (1 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0);
           led : out STD_LOGIC_VECTOR (15 downto 0);
           vgaRed : out STD_LOGIC_VECTOR (3 downto 0);
           vgaBlue : out STD_LOGIC_VECTOR (3 downto 0);
           vgaGreen : out STD_LOGIC_VECTOR (3 downto 0);
           Hsync : out STD_LOGIC;
           Vsync : out STD_LOGIC);
end vga;

architecture Behavioral of vga is

component clkdiv is
    Port(
       clk_out1 : out std_logic;
       reset : in std_logic;
       clk_in1 : in std_logic;
       clockfall : out std_logic);
end component;

component mono is
  port (
    clk : in  std_logic;
    btn : in  std_logic_vector(4  downto 0);
    enable : out std_logic_vector(4 downto 0)
  );
end component;

component SSD is
  port (
    clk : in std_logic;
    digits  : in  std_logic_vector(15 downto 0);
    an  : out std_logic_vector(3  downto 0);
    cat : out std_logic_vector(6  downto 0)
  );
end component;

signal Color: std_logic_vector(11 downto 0);
signal MPG_out: std_logic_vector(4 downto 0);
signal reset: std_logic;
signal clk25MHz : std_logic;
signal clock : std_logic := '0';
signal s_digits: std_logic_vector(15 downto 0) := x"1234";

signal TCH : std_logic;
signal Hcount : integer range 0 to 1687;
signal Vcount : integer range 0 to 1065;

signal CoordX : integer range 0 to 3;
signal CoordY : integer range 0 to 3;

signal Select_CoordX : std_logic_vector(1 downto 0) := "00";
signal Select_CoordY : std_logic_vector(1 downto 0) := "00";

type matrix is array(3 downto 0, 3 downto 0) of integer;

signal Squares : matrix :=((0,1,2,3),
                           (4,5,6,7),
                           (8,9,10,11),
                           (1,1,2,3));
-- end declaration space
begin

clkdiv_instance: clkdiv port map(clk_out1=>clk25MHz,clk_in1=>clk,reset=>MPG_out(0),clockfall => clock);
MPG_instance: mono port map (clk => clk, btn => btn, enable => MPG_out);
SSD_instance: SSD port map (clk => clk, digits => s_digits, an => an, cat => cat);

reset <= MPG_out(0);

process(clk25MHz)
begin
if(reset = '1') then
    Hcount <= 0;
    TCH <= '0';
else if rising_edge(clk25MHz) then
    if(Hcount = 800) then --800
        Hcount <= 0;
        TCH <= '1';
    else
        Hcount <= Hcount + 1;
        TCH <= '0';
    end if;   
end if;
end if;
end process;

process(clk25MHz)
begin
if(reset = '1') then
   Vcount <= 0;
else if rising_edge(clk25MHz) then

    if (TCH = '1') then
        if(Vcount = 525) then --525
            Vcount <= 0;
        else
            Vcount <= Vcount + 1;
        end if;  
    end if; 
end if;
end if;
end process;

process(clk25MHz)
begin
if rising_edge(clk25MHz) then
    if(Vcount < 490 or Vcount > 492) then --Vcount < 490 or Vcount > 492
        Vsync <= '1';
    else
        Vsync <= '0';
    end if;
end if;
end process;

process(clk25MHz)
begin
if rising_edge(clk25MHz) then
    if(Hcount < 656 or Hcount > 752) then  --Hcount < 656 or Hcount > 752
        Hsync <= '1';
    else
        Hsync <= '0';
    end if;
end if;
end process;

process(clk25MHz)
begin
    if rising_edge(clk25MHz) then
        if MPG_out(2) = '1' then
            Select_CoordX <= Select_CoordX - '1';
        end if;
        
        if MPG_out(3) = '1' then
            Select_CoordX <= Select_CoordX + '1';
        end if;
        
        if MPG_out(1) = '1' then
            Select_CoordY <= Select_CoordY - '1';
        end if;
        
        if MPG_out(4) = '1' then
            Select_CoordY <= Select_CoordY + '1';
        end if;
        
        s_digits <= "000000" & Select_CoordX & "000000" & Select_CoordY;
        
        Squares(to_integer(unsigned(Select_CoordX)), to_integer(unsigned(Select_CoordY))) <= 0;
    end if;
end process;

led <= "000000" & Select_CoordX & "000000" & Select_CoordY;

process(clk25MHz)
variable R,G,B : std_logic_vector(3 downto 0);
begin
    if rising_edge(clk25MHz)then
        if(Hcount < 640) then  
            if(Vcount < 480) then  
                if (Hcount mod 160 = 0) or (Vcount mod 120 = 0) then
                     R:= "0000";
                     B:= "0000";
                     G:= "0000";
                 else
                    CoordX <= (Hcount/160) - 1;
                    CoordY <= (Vcount/120) - 1;
                    case Squares(CoordX,CoordY) is
                        when 0 => R:= "1111";
                                  B:= "1111";
                                  G:= "1111";
                        when 1 => R:= "0000";
                                  B:= "0000";
                                  G:= "1111";
                        when others =>R:= "1111";
                                      B:= "0000";
                                      G:= "0000";
                     end case;
                 end if;
            end if;
        else
             R:= "0000";
             B:= "0000";
             G:= "0000";
        end if;
        vgaRed <= R;
        vgaBlue <= B;
        vgaGreen <= G;
    end if;
end process;

end Behavioral;
