library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std.all;
entity contador is
port(
clk, reset, echo : in std_logic;
MEDIDA : out std_logic_vector (15 downto 0);
PRONTO : out std_logic;
DEBUG_CONT : OUT INTEGER
);
end contador;
architecture Behavioral of contador is
signal cont : integer range 0 to 51 := 0;
signal cont_dist  : integer range 0 to 24000 := 0;

begin
DEBUG_CONT <= cont;
process (clk, reset)

begin -- process bcd_counting

if reset = '1' then -- asynchronous reset (active high)
	cont <= 0;
	cont_dist <= 0;
	PRONTO <= '0';
elsif clk'event and clk = '1' then -- rising clock edge
	if (cont = 50) then
		cont <= 0;
		if echo = '1' then
			cont_dist <= cont_dist + 1;
		end if;	
	elsif echo = '1' then
		cont <= cont + 1;

	elsif echo = '0' then
		if (cont > 1) then
			PRONTO <= '1';
		END IF;	
		cont <= 0;
		MEDIDA <= conv_std_logic_vector(cont_dist, 16);
	end if;
end if;

end process;

end Behavioral;