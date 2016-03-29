library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
entity divisor is
port
	(
	TEMPO	: in std_logic_vector(15 downto 0);
	DIVIDIR : in std_logic;
	RESP    : out std_logic_vector(15 downto 0) -- cont_echo max = 24 000
	);
end divisor;
architecture comportamento_divisor of divisor is
begin
	process(DIVIDIR)
		variable parcela1 : std_logic_vector(15 downto 0) := (others => '0');
		variable parcela2 : std_logic_vector(15 downto 0) := (others => '0');
		variable parcela3 : std_logic_vector(15 downto 0) := (others => '0');
		variable zero6   : std_logic_vector(5  downto 0)  := (others => '0'); -- 6 zeros
		variable zero10  : std_logic_vector(9  downto 0)  := (others => '0'); -- 10 zeros
		variable zero11  : std_logic_vector(10 downto 0)  := (others => '0'); -- 11 zeros
--  = 5 000
		begin
		if (DIVIDIR'event and DIVIDIR = '1') then
		
			-- exemplo : tempo / 58,82 = 5 000 / 58,82
			-- resposta esperada = 85,0051
			-- x/58,84 = x/64 + x/1 024 + x/2 048
			-- x/58,84 = x/2^6 + x/2^10 + x/2^11
			
			parcela1 := zero6  & TEMPO(15 downto 6);
			parcela2 := zero10 & TEMPO(15 downto 10);
			parcela3 := zero11 & TEMPO(15 downto 11);
			RESP <= parcela1 + parcela2 + parcela3;
		end if;
	end process;
end comportamento_divisor;