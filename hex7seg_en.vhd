library ieee;
use ieee.std_logic_1164.all;

entity hex7seg_en is
	port (
		x : in std_logic_vector(3 downto 0);
		enable : in std_logic;
		a_to_g : out std_logic_vector(6 downto 0)
	);
end hex7seg_en;

architecture hex7seg_en of hex7seg_en is
begin
	process (x,enable)
	begin
		if enable = '0' then
	        a_to_g <= "1111111"; -- apaga segmentos
	    else
		case x is
			when "0000" => a_to_g <= "1000000";  --"0000001"; -- "1111110" 0
			when "0001" => a_to_g <= "1111001"; -- "1001111"; -- "0110000" 1
			when "0010" => a_to_g <= "0100100"; -- "0010010"; -- "1101101" 2
			when "0011" => a_to_g <= "0110000"; -- "0000110"; -- "1111001" 3
			when "0100" => a_to_g <= "0011001"; -- 4
			when "0101" => a_to_g <= "0010010"; -- 5
			when "0110" => a_to_g <= "0000010"; -- 6
			when "0111" => a_to_g <= "1111000"; -- 7
			when "1000" => a_to_g <= "0000000"; -- 8
			when "1001" => a_to_g <= "0010000"; -- 9
			when "1010" => a_to_g <= "0001000"; -- A
			when "1011" => a_to_g <= "0000011"; -- B
			when "1100" => a_to_g <= "1000110"; -- C
			when "1101" => a_to_g <= "0100001"; -- D
			when "1110" => a_to_g <= "0000110"; -- E
			when others => a_to_g <= "0001110"; -- F
		end case;
		end if;
	end process;
end hex7seg_en;
