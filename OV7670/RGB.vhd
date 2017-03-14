
--library IEEE;
--use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.STD_LOGIC_ARITH.ALL;
--use IEEE.STD_LOGIC_UNSIGNED.ALL;


--entity RGB is
--    Port ( Din 	: in	STD_LOGIC_VECTOR (11 downto 0);			-- niveau de gris du pixels sur 8 bits
--			  Nblank : in	STD_LOGIC;										-- signal indique les zone d'affichage, hors la zone d'affichage
--																					-- les trois couleurs prendre 0
--           R,G,B 	: out	STD_LOGIC_VECTOR (3 downto 0));			-- 3 colors in 10 bits les trois couleurs sur 10 bits
--end RGB;

--architecture Behavioral of RGB is

--begin
--		R <= Din(11 downto 8) when Nblank='1' else "0000";
--		G <= Din(7 downto 4)  when Nblank='1' else "0000";
--		B <= Din(3 downto 0)  when Nblank='1' else "0000";

--end Behavioral;


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

entity RGB is
    Port ( Din : in STD_LOGIC_VECTOR (11 downto 0);
           Nblank : in STD_LOGIC;
--           R : out STD_LOGIC_VECTOR (7 downto 0);
--           G : out STD_LOGIC_VECTOR (7 downto 0);
           R,G,B : out STD_LOGIC_VECTOR (3 downto 0));
end RGB;

architecture Behavioral of RGB is
SIGNAL DIV :STD_LOGIC_VECTOR(4 DOWNTO 0);
signal var1 :STD_LOGIC_VECTOR(4 DOWNTO 0);
signal var2 :STD_LOGIC_VECTOR(4 DOWNTO 0);
begin
--var1<='0'& din(11 downto 8);
--var2<='0'& din(7 downto 4);
--DIV<=var1+var2;
--R <= div(4 downto 1) when Nblank='1' else "0000";
--G <= div(4 downto 1)  when Nblank='1' else "0000";
--B <= div(4 downto 1)  when Nblank='1' else "0000";
R <= din(3 downto 0) when Nblank='1' else "0000";
G <= din(3 downto 0)  when Nblank='1' else "0000";
B <= din(3 downto 0)  when Nblank='1' else "0000";

--begin
--R <= "1111"-Din(3 downto 0) when Nblank='1' else "0000";
--G <= "1111"-Din(3 downto 0)  when Nblank='1' else "0000";
--B <= "1111"-Din(3 downto 0)  when Nblank='1' else "0000";


--begin
--		R <= Din(11 downto 8) when Nblank='1' else "0000";
--		G <= Din(7 downto 4)  when Nblank='1' else "0000";
--		B <= Din(3 downto 0)  when Nblank='1' else "0000";


--SIGNAL DIV :STD_LOGIC_VECTOR(4 DOWNTO 0);
--signal var1 :STD_LOGIC_VECTOR(4 DOWNTO 0);
--signal var2 :STD_LOGIC_VECTOR(4 DOWNTO 0);
--begin
--var1<='0'& din(11 downto 8);
--var2<='0'& din(7 downto 4);
--DIV<=var1+var2;
--process(div)
--begin
--if div > "10100" then
--    if din(3 downto 0) < "1010" then
--        if(Nblank='1') then
--            R <= "1111" ;
--            G <= "1111" ;
--            B <= "1111" ;
--        else
--            R <= "0000" ;
--            G <= "0000" ;
--            B <= "0000" ;
            
--        end if; 
--    end if;
--else 
--    R <= "0000";
--    G <= "0000";
--    B <= "0000";
--end if;


--end process;


--begin
--R <= "1111"-Din(3 downto 0) when Nblank='1' else "0000";
--G <= "1111"-Din(3 downto 0)  when Nblank='1' else "0000";
--B <= "1111"-Din(3 downto 0)  when Nblank='1' else "0000";
end Behavioral;

