----------------------------------------------------------------------------------
-- Company: Beihang University
-- Engineer: Yu Cao
-- 
-- Create Date: 05/09/2016 01:29:18 PM
-- Design Name: 
-- Module Name: windows - Behavioral
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity NMS_module is
    Port ( 
      clk : IN STD_LOGIC;
      href : IN STD_LOGIC;
        vsync : IN STD_LOGIC;-- frame synchronous 
        addrin : in STD_LOGIC_VECTOR(18 DOWNTO 0); 
        addrout :out STD_LOGIC_VECTOR(18 DOWNTO 0);
        din : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
        en : IN STD_LOGIC;
        wr_data : out STD_LOGIC;
        dout : OUT STD_LOGIC_VECTOR(11 DOWNTO 0)
      
);
end NMS_module;

architecture Behavioral of NMS_module is
component buffer_lines1 is
  Port (  
      clk : IN STD_LOGIC;
rst  : IN STD_LOGIC;-- frame synchronous 

din : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
en : IN STD_LOGIC;
--wr_data : out STD_LOGIC;
--dout : OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
 o1,o2,o3,o4,o5,o6,o7,o8,o9: OUT STD_LOGIC_VECTOR(11 DOWNTO 0));
end component;
--signal w_1_1 :  STD_LOGIC_VECTOR (11 downto 0);
--signal           w_10 :  STD_LOGIC_VECTOR (11 downto 0);
--      signal     w_11 :  STD_LOGIC_VECTOR (11 downto 0);
-- signal          w0_1 :  STD_LOGIC_VECTOR (11 downto 0);
--  signal         w00 :  STD_LOGIC_VECTOR (11 downto 0);
-- signal          w01 :  STD_LOGIC_VECTOR (11 downto 0);
--   signal        w1_1 :  STD_LOGIC_VECTOR (11 downto 0);
--  signal         w10 :  STD_LOGIC_VECTOR (11 downto 0);
--  signal         w11 :  STD_LOGIC_VECTOR (11 downto 0);
--signal      clk :  STD_LOGIC;
--signal rst : STD_LOGIC:='0';-- frame synchronous 
--signal din : STD_LOGIC_VECTOR(11 DOWNTO 0):=(others=>'0');
--signal en,rd_en0 :  STD_LOGIC:='0';
--signal wr_data :  STD_LOGIC;
signal  wr_reg:  STD_LOGIC:='0';
signal  result,o1,o2,o3,o4,o5,o6,o7,o8,o9:  STD_LOGIC_VECTOR(11 DOWNTO 0);
--signal full :  STD_LOGIC;
signal cols,row_count ,data_count0,data_count1:  STD_LOGIC_VECTOR(9 DOWNTO 0):=(others=>'0');
signal reg00,reg01,reg02:STD_LOGIC_VECTOR(11 DOWNTO 0):=(others=>'0');
signal product :std_logic_vector(23 downto 0):=(others=>'0');
signal address,addr0,addr1,addr2,addr3:STD_LOGIC_VECTOR(18 DOWNTO 0):=(others=>'0');
begin
uut: buffer_lines1 port map (clk,vsync,din,en,o1,o2,o3,o4,o5,o6,o7,o8,o9);

--clock11:process(href,vsync)
--begin

--if(rising_edge(href)) then
--row_count<=row_count+"0000000001";
--elsif (vsync='1') then 
--row_count<="0000000000";
--end if;
--end process;


clock21:process(clk)
begin
if(href='1') then
cols<="0000000000";
elsif(rising_edge(clk) and en='1') then
 cols<=cols+"0000000001";
end if;

if rising_edge(clk) then
         if( wr_reg = '1'and vsync='0' )then
            address <= address+"0000000000000000001";
         elsif vsync='1' then
            address <= "0000000000000000000";
         end if;
         end if;
end process;

calculation: process(clk)
begin
if(vsync='1')then
    addr0<="0000000000000000000";
    elsif (rising_edge(clk) and en='1')then
    addr0<=addr0+"0000000000000000001";
end if;

--Here is where algorithm lays
--Non-Maximum Suppression
--
--	  G_x          Window          G_y
---1    0    1  o1   o2   o3   -1   -2   -1
--   \ | /        \ | /           \ | /
--    \|/          \|/             \|/
---2----0----2  o4---o5---o6    0----0----0
--    /|\          /|\             /|\ 
--   / | \        / | \           / | \ 
---1    0    1  o7   o8   o9    1    2    1  
if(falling_edge(clk))then 
    if(addr0>642 and en='1') then
        if(din(11 downto 10)="00") then
            if (o5(6 downto 0)<o4(6 downto 0) or  o5(6 downto 0)<o6(6 downto 0)) then
                result<="000000000000";-- 28
            else result<=o5;
            end if;
        elsif (din(11 downto 10)="01") then
            if (o5(6 downto 0)<o1(6 downto 0) or  o5(6 downto 0)<o9(6 downto 0)) then
                        result<="000000000000";
                    else result<=o5;--37
                    end if;
        elsif (din(11 downto 10)="10") then
            if (o5(6 downto 0)<o2(6 downto 0) or  o5(6 downto 0)<o8(6 downto 0)) then
                        result<="000000000000";--46
                    else result<=o5;
                    end if;    
        else 
            if (o5(6 downto 0)<o3(6 downto 0) or  o5(6 downto 0)<o7(6 downto 0)) then
                        result<="000000000000";--19
                    else result<=o5;
                    end if;    
        end if;    
--        result<=o1+o4+o7-o3-o6-o9;--o2+o6-o4-o8
--        result<=(o2+o6-o4-o8);
    wr_reg<='1';
--    address <= address+"000000000000000001";
    
    else wr_reg<='0';
    end if;
end if;
if rising_edge(clk) then    

    if (wr_reg='1')then
--        if result(3 downto 0)>9 then
--        dout<="000000001111";
--        else dout<="000000000000";
--        end if;
        dout<=result;
    wr_data<='1';
    else wr_data<='0'; 
end if;
end if;
end process;
addrout<=address;

end Behavioral;