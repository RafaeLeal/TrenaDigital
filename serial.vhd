 library ieee;
 use ieee.std_logic_1164.all;
 ENTITY serial IS
 PORT (
		 DIN : in std_logic_vector (7 downto 0); -- input register
		 MODE : in std_logic_vector (1 downto 0); -- mode selection
		 CLK, RESET : in std_logic; -- clock and reset
		 SDOUT : out std_logic; -- output data
		 DONE : OUT STD_LOGIC
		 ); 
 END ENTITY;
 
 -- purpose: Implement main architecture of PAR2SER
 ARCHITECTURE BEHAVIOR OF serial IS
 SIGNAL IDATA : std_logic_vector(9 downto 0); -- internal data
 SIGNAL COUNT : integer range 0 to 24000;
 SIGNAL COUNT2 : integer range 0 to 15 := 0;
 SIGNAL PARIDADE : std_logic;
 SIGNAL STARTBIT : std_logic := '0';
 SIGNAL STOPBIT : std_logic := '1';
 
 begin -- BEHAVIOR
 -- purpose: Main process
 process (CLK, RESET)

 begin -- process

 -- activities triggered by asynchronous reset (active high)
 if RESET = '1' then

 SDOUT <= '1';
 IDATA <= "0000000000";
 -- activities triggered by rising edge of clock
 elsif CLK'event and CLK = '1' then
 case MODE is

 when "00" => -- no operation
 null;
 when "01" => -- load operation
 IDATA <= STARTBIT & DIN & STOPBIT;
 SDOUT <= '1';
 COUNT <= 0;
 when "10" => -- shift left
 SDOUT <= STARTBIT;
 SDOUT <= IDATA(9);
 COUNT <= COUNT + 1;
 IF IDATA(9) = '1' AND COUNT > 0 AND COUNT < 9 THEN
	COUNT2 <= COUNT2 + 1;
	IF (COUNT2 mod 2) = 0 THEN
		PARIDADE <= '1';
	ELSE
		PARIDADE <= '0';
	END IF;	
 END IF;
 for mloop in 8 downto 0 loop
 IDATA(mloop+1) <= IDATA(mloop);
 end loop; -- mloop
 IF COUNT = 9 THEN
	SDOUT <= PARIDADE;
	END IF;
IF COUNT = 11 THEN
	DONE <= '1';
END IF;

 when others => -- no operation otherwise
 null;
 end case;
 end if;
 end process;
 end BEHAVIOR;