

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity mylsfr is
    generic(width:integer:=16);
    Port ( a : in std_logic_vector(width-1 downto 0);
           b : out std_logic;
           rst: in std_logic;
           clk: in std_logic);
           
end mylsfr;

architecture myimpl of mylsfr is

    signal a_reg: std_logic_vector(WIDTH-1 downto 0) := (others=>'0');

begin
    
myprocess: process(clk)
 
    variable xorres: std_logic;
     
    begin
        if rising_edge(clk) then 
            xorres := a_reg(0) XOR a_reg(2) XOR a_reg(3) XOR a_reg(5);
            a_reg <= xorres & a_reg(width-1 downto 1);
            b <= a_reg(0);
            
            if rst='1' then
                b <= '0'; 
                a_reg <= a;
            end if;  
        end if;
    end process;
end ;
