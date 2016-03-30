library IEEE; 
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY MyMUX IS
PORT (
	in1 : IN STD_LOGIC_VECTOR(7 downto 0); -- mux input1
	in2 : IN STD_LOGIC_VECTOR(7 downto 0); -- mux input2
	in3 : IN STD_LOGIC_VECTOR(7 downto 0); -- mux input3
	in4 : IN STD_LOGIC_VECTOR(7 downto 0); -- mux input4
	sel : in std_logic_vector(1 downto 0); -- selection line
	dataout : OUT STD_LOGIC_VECTOR(7 downto 0)
); 
END ENTITY;

architecture Behavioral of MyMUX is
begin
-- This process for mux logic
process (sel, in1, in2, in3, in4)
begin
	case SEL is 
		when "00" => dataout <= in1; 
		when "01" => dataout <= in2;
		when "10" => dataout <= in3;
		when "11" => dataout <= in4;
		when others => dataout <= "00000000";
	end case;
end process;

end Behavioral;