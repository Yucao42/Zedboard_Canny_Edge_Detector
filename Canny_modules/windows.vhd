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

entity windows is
    Port ( 
      clk : IN STD_LOGIC;
      href : IN STD_LOGIC;
        vsync : IN STD_LOGIC;-- frame synchronous 
        addrin : in STD_LOGIC_VECTOR(18 DOWNTO 0); 
        addrout :out STD_LOGIC_VECTOR(18 DOWNTO 0);
        din : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
        en : IN STD_LOGIC;
        wr_data : out STD_LOGIC;
        dout : OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
--        gradient : OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
        rows : OUT STD_LOGIC_VECTOR(9 DOWNTO 0)
);
end windows;

architecture Behavioral of windows is
component buffer_lines is
  Port (  
      clk : IN STD_LOGIC;
rst  : IN STD_LOGIC;-- frame synchronous 

din : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
en : IN STD_LOGIC;

 o1,o2,o3,o4,o5,o6,o7,o8,o9: OUT STD_LOGIC_VECTOR(6 DOWNTO 0));
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
signal dir:std_logic_vector (1 downto 0);
signal y1,x1,x2: std_logic_vector(19 downto 0);
signal x0,y0: std_logic_vector(12 downto 0);
--signal mid: std_logic_vector(10 downto 0);
signal  sx1,sy1,sx,sy,sign_x,sign_y,xy_rd,sign_rd1,sign_rd2,sign_cp1,sign_cp2,sign_cp3,wr_reg:  STD_LOGIC:='0';
signal  r_y,r_x,re_x,re_y,result2,result1,result_y,result_x,o1,o2,o3,o4,o5,o6,o7,o8,o9:  STD_LOGIC_VECTOR(6 DOWNTO 0):=(others=>'0');
--signal full :  STD_LOGIC;
signal cols,row_count ,data_count0,data_count1:  STD_LOGIC_VECTOR(9 DOWNTO 0):=(others=>'0');
signal result,reg_result:STD_LOGIC_VECTOR(11 DOWNTO 0):=(others=>'0');
signal product :std_logic_vector(23 downto 0):=(others=>'0');
signal address,addr0,addr1,addr2,addr3:STD_LOGIC_VECTOR(18 DOWNTO 0):=(others=>'0');
begin
uut: buffer_lines port map (clk,vsync,din,en,o1,o2,o3,o4,o5,o6,o7,o8,o9);
rows<=row_count;

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

if(falling_edge(clk))then 
    if(addr0>642 and en='1') then
        result_x<=o3+o6+o6+o9-o1-o4-o4-o7;--o2+o6-o4-o8
--        result<=(o2+o6-o4-o8);
        result_y<=o7+o8+o8+o9-o1-o2-o2-o3;
    xy_rd<='1';
--    address <= address+"000000000000000001";
    
    else xy_rd<='0';
    end if;
    
--    if sign_rd2='1' then
--    x0<="00000" & result_x;
--    y0<="00000" & result_y;
--    end if;
end if;

if (rising_edge(clk) )then 
if xy_rd='1' then 
if result_x(6)='1' then re_x<=result_x xor "1111111";sign_x<='1';
else sign_x<='0';re_x<=result_x;
end if;
if result_y(6)='1' then re_y<=result_y xor "1111111";sign_y<='1';
else sign_y<='0';re_y<=result_y;
end if; 
sign_rd1<='1';
else sign_rd1<='0';
end if;
end if;

if falling_edge(clk) then 
if  sign_rd1='1' then
sx1<=sign_x;
sy1<=sign_y;
if sign_x='1' then r_x<=re_x +"0000001";
else r_x<=re_x;
--else sign_x<='0';
end if;
if sign_y='1' then r_y<=re_y +"0000001";
--else sign_y<='0';
else r_y<=re_y;
end if; 
sign_rd2<='1';
else sign_rd2<='0';
end if;
end if;

if rising_edge(clk) then 
if  sign_rd2='1' then
sx<=sx1;
sy<=sy1;
x0<="000000"& r_x;
y0<="000000"& r_y;
result2<=r_x+r_y;
sign_cp1<='1';
else sign_cp1<='0';
end if;
end if;

if falling_edge(clk) then 
if  sign_cp1='1' then
x1<= x0* "0001101";  -- 20.566471544173  22.5 23.621362894118 
x2<= x0* "1001101";  --67.22du
y1<= y0* "0100000";
result1<=result2;
--result<=result_x+result_y;
sign_cp2<='1';
else sign_cp2<='0';
end if;
end if;

if rising_edge(clk) then 
if  sign_cp2='1' then
    if y1<x1 then 
        dir<="00";    -- -+22.5Vertical edge. huge gx, small gy
    elsif y1>x2 then
        dir<="10";    -- 67.5 112.5 Horiznonal edge other way round
    else 
        if(sx = sy) then
            dir<="01";  -- 22.5 67.5 Positive Diagonal Edge
        else
            dir<="11";  -- 112.5 157.5 Negative Diagonal Edge
        end if;
    end if;
    result<= dir & "0000"&result1(6 downto 1);
    sign_cp3<='1';
else sign_cp3<='0';
end if;
end if;
--
if falling_edge(clk) then
if sign_cp3='1' then 
wr_reg<='1';
reg_result<=result;

else wr_reg<='0';
end if;
end if;

if rising_edge(clk) then    

    if (wr_reg='1')then
--        if o5(3 downto 0)>7 then
--         if reg_result(3 downto 0)>5 then--
--        dout<="000000001111";
--        else dout<="000000000000";
--        end if;
          dout<=reg_result;


--          dout<=dir & "000" & result ;
    wr_data<='1';
    else wr_data<='0'; 
end if;
end if;
end process;
addrout<=address;

end Behavioral;
