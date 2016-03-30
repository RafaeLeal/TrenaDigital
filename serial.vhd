 library ieee;
 use ieee.std_logic_1164.all;
 ENTITY serial IS
 PORT (
		 DIN0 : in std_logic_vector (7 downto 0); -- input register
		 DIN1 : in std_logic_vector (7 downto 0);
		 DIN2 : in std_logic_vector (7 downto 0);
		 DIN3 : in std_logic_vector (7 downto 0);
		 MODE : in std_logic_vector (1 downto 0); -- mode selection
		 CLK, RESET : in std_logic; -- clock and reset
		 SDOUT : out std_logic; -- output data
		 DONE : OUT STD_LOGIC;
		 serial_DEBUG_IDATA : OUT STD_LOGIC_VECTOR(43 downto 0)
		 ); 
 END ENTITY;

 -- purpose: Implement main architecture of PAR2SER
 ARCHITECTURE BEHAVIOR OF serial IS
 
FUNCTION fparidade (D : STD_LOGIC_VECTOR(7 downto 0)) RETURN STD_LOGIC IS
 BEGIN
	RETURN D(7) XOR D(6) XOR D(5) XOR D(4) XOR D(3) XOR D(2) XOR D(1) XOR D(0);
 END FUNCTION;
 
 
 
 SIGNAL IDATA0, IDATA1, IDATA2, IDATA3 : std_logic_vector(10 downto 0); -- internal data
 SIGNAL IDATA : std_logic_vector(43 downto 0); -- internal data
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
 IDATA <= "00000000000000000000000000000000000000000000";
 -- activities triggered by rising edge of clock
 elsif CLK'event and CLK = '1' then
 case MODE is

 when "00" => -- no operation
 null;
 when "01" => -- load operation
 IDATA0 <= STARTBIT & DIN0 & fparidade(DIN0) & STOPBIT;
 IDATA1 <= STARTBIT & DIN1 & fparidade(DIN1) & STOPBIT;
 IDATA2 <= STARTBIT & DIN2 & fparidade(DIN2) & STOPBIT;
 IDATA3 <= STARTBIT & DIN3 & fparidade(DIN3) & STOPBIT;
 IDATA <= IDATA0 & IDATA1 & IDATA2 & IDATA3;
 
 serial_DEBUG_IDATA <= IDATA;
 SDOUT <= '1';
 COUNT <= 0;
 DONE <= '0';
 when "10" => -- shift left
 SDOUT <= IDATA(43);
 COUNT <= COUNT + 1;
 IF IDATA(10) = '1' AND COUNT > 0 AND COUNT < 9 THEN
	COUNT2 <= COUNT2 + 1;
	IF (COUNT2 mod 2) = 0 THEN
		PARIDADE <= '1';
	ELSE
		PARIDADE <= '0';
	END IF;	
 END IF;
 for mloop in 42 downto 0 loop
 IDATA(mloop+1) <= IDATA(mloop);
 end loop; -- mloop
IF COUNT = 11 THEN
	DONE <= '1';
END IF;

 when others => -- no operation otherwise
 null;
 end case;
 end if;
 end process;
 end BEHAVIOR;