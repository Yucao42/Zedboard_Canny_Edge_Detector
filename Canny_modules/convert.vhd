----------------------------------------------------------------------------------
-- Company: Beihang University
-- Engineer: Yu Cao
-- 
-- Create Date: 05/10/2016 07:11:13 PM
-- Design Name: 
-- Module Name: convert - Behavioral
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

entity convert is
    Port ( i : in STD_LOGIC;
           o : out STD_LOGIC_VECTOR (0 downto 0));
end convert;

architecture Behavioral of convert is

begin
o(0)<=i;

end Behavioral;
