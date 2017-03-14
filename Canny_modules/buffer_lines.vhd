----------------------------------------------------------------------------------
-- Company: Beihang University
-- Engineer: 
-- 
-- Create Date: 05/11/2016 12:39:39 PM
-- Design Name: 
-- Module Name: tb_fifo - Behavioral
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

entity buffer_lines is
  Port (  
      clk : IN STD_LOGIC;
  rst : IN STD_LOGIC;-- frame synchronous 
  din : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
  en : IN STD_LOGIC;
--  wr_data : out STD_LOGIC;
--  dout : OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
 
--  column_count : OUT STD_LOGIC_VECTOR(9 DOWNTO 0);
--   data_count0 : OUT STD_LOGIC_VECTOR(9 DOWNTO 0);
--    data_count1 : OUT STD_LOGIC_VECTOR(9 DOWNTO 0);
--      addrin : In std_LOGIC_VECTOR(18 DOWNTO 0);
--        addrout : out std_LOGIC_VECTOR(18 DOWNTO 0);
  o1,o2,o3,o4,o5,o6,o7,o8,o9: OUT STD_LOGIC_VECTOR(6 DOWNTO 0));
end buffer_lines;

architecture Behavioral of buffer_lines is
component fifo_generator_0 IS
  PORT (
    clk : IN STD_LOGIC;
    rst : IN STD_LOGIC;
    din : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
    wr_en : IN STD_LOGIC;
    rd_en : IN STD_LOGIC;
    dout : OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
    full : OUT STD_LOGIC;
    empty : OUT STD_LOGIC;
    data_count : OUT STD_LOGIC_VECTOR(9 DOWNTO 0);
    prog_full : OUT STD_LOGIC
  );
END component;
signal flag0,flag1,rd_en0,rd_en1: std_logic:='0';
--signal rst0,rst1: std_logic:='1';
signal wr_en0,full0,empty0,prog_full0,wr_en1,full1,empty1,prog_full1: std_logic;
signal din0,dout0,din1,dout1:STD_LOGIC_VECTOR(11 DOWNTO 0):="000000001010";
signal cols,number,data_count0,data_count1 :STD_LOGIC_VECTOR(9 DOWNTO 0):=(others=>'0');
--constant period: time :=10 ns;
signal reg00,reg01,reg02,reg03,reg04,reg10,reg11,reg12,reg13,reg20,reg21,reg22:STD_LOGIC_VECTOR(11 DOWNTO 0):=(others=>'0');
begin


---outputs with regs

--column_count<=cols;

regpro0: process(clk) 
begin
if (rising_edge(clk) and en='1') then
if(rst='0') then
reg00<=din;
reg01<=reg00;
reg02<=reg01;
reg03<=reg02;
reg04<=reg03;
else 
reg00<="000000000000";
reg01<="000000000000";
reg02<="000000000000";
reg03<="000000000000";
reg04<="000000000000";
end if;
if number<640 then 
number<=number+"0000000001";
else number<="0000000000";
cols<=cols+"0000000001";
end if;
end if;
end process;
--wr_en0<='1';
----rd_en<='1';

--prorst:process(rst)
--begin
--if rst='1' then
--reg00<="000000000000";
--reg01<="000000000000";
--reg02<="000000000000";
--end if;
--end process;

uut0: fifo_generator_0 port map(clk,rst,din,en,rd_en0,dout0,full0,empty0,data_count0,prog_full0);
uut1: fifo_generator_0 port map(clk,rst,dout0,rd_en0,rd_en1,dout1,full1,empty1,data_count1,prog_full1);
regpro:process(clk)
begin
if(rising_edge(clk) and en='1')  then
--    if(flag0='1')then 
--    rd_en0<='1';
--    end if;
    
--    if(flag1='1')then 
--    rd_en1<='1';
--    end if;
--    if rst='0' then 
        reg10<=dout0;
    reg11<=reg10;
    reg12<=reg11;
      reg13<=reg12;
--    else 
--    reg00<="000000000000";
--    reg01<="000000000000";
--    reg02<="000000000000";
--    end if;
reg20<=dout1;
reg21<=reg20;
reg22<=reg21;
    



end if;

if rising_edge(clk) then
    if(rst='0') then
        if(prog_full0='1') then
        rd_en0<=en;
        flag0<='1';
        else rd_en0<='0';
        end if;
    else rd_en0<='0';
end if;
end if;

if rising_edge(clk) then
if(rst='0') then
    if(prog_full1='1') then
    rd_en1<=en;
    flag1<='1';
    else rd_en1<='0';
    end if;
else rd_en1<='0';
end if;
end if;
end process;

o7<="000" & reg04(3 downto 0);-- row 3 col 1   1,1
o8<="000" & reg03(3 downto 0);-- row 3 col 2   1,2
o9<="000" & reg02(3 downto 0);-- row 3 col 3   1,3
o4<="000" & reg13(3 downto 0);-- row 2 col 1   2,1
o5<="000" & reg12(3 downto 0);-- row 2 col 2   2,2
o6<="000" & reg11(3 downto 0);-- row 2 col 3   2,3
o1<="000" & reg22(3 downto 0);-- row 1 col 1   3,1
o2<="000" & reg21(3 downto 0);-- row 1 col 2   3,2
o3<="000" & reg20(3 downto 0);-- row 1 col 3   3,3

end Behavioral;
