library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Std_logic_arith.all;
use ieee.std_logic_unsigned.all;
ENTITY FD_sensor_de_distancia IS
			PORT (
				CLK : IN STD_LOGIC;
				ECHO : IN STD_LOGIC;
				RESET : IN STD_LOGIC;
				MEDIDA : OUT STD_LOGIC_VECTOR(15 downto 0);
				A7SEG3 : OUT STD_LOGIC_VECTOR(6 downto 0);
				A7SEG2 : OUT STD_LOGIC_VECTOR(6 downto 0);
				A7SEG1 : OUT STD_LOGIC_VECTOR(6 downto 0);
				A7SEG0 : OUT STD_LOGIC_VECTOR(6 downto 0);
				FD_DEBUG_SERIAL0 : OUT STD_LOGIC;
				FD_DEBUG_SERIAL1 : OUT STD_LOGIC;
				FD_DEBUG_SERIAL2 : OUT STD_LOGIC;
				FD_DEBUG_SERIAL3 : OUT STD_LOGIC;
				SAIDA_SERIAL : OUT STD_LOGIC
			);
END ENTITY;
ARCHITECTURE arch_FD_sensor_de_distancia OF FD_sensor_de_distancia IS
SIGNAL sMEDIDA : STD_LOGIC_VECTOR(15 downto 0);
SIGNAL PRONTO_cont : STD_LOGIC;
SIGNAL RESP : STD_LOGIC_VECTOR(15 downto 0);
SIGNAL ENABLE : STD_LOGIC := '1';
COMPONENT contador
PORT (
		clk, reset, echo : in std_logic;
		MEDIDA : out std_logic_vector (15 downto 0);
		PRONTO : OUT STD_LOGIC
	);
END COMPONENT;
COMPONENT divisor
port
	(
	TEMPO	: in std_logic_vector(15 downto 0);
	DIVIDIR : in std_logic;
	RESP    : out std_logic_vector(15 downto 0) -- cont_echo max = 24 000
	);
end COMPONENT;

COMPONENT hex7seg_en 
	port (
		x : in std_logic_vector(3 downto 0);
		enable : in std_logic;
		a_to_g : out std_logic_vector(6 downto 0)
	);
end COMPONENT;

COMPONENT binary_bcd
    generic(N: positive := 16);
    port(
        clk, reset: in std_logic;
        binary_in: in std_logic_vector(N-1 downto 0);
        bcd0, bcd1, bcd2, bcd3, bcd4: out std_logic_vector(3 downto 0)
    );
end COMPONENT;

 COMPONENT serial
 PORT (
		 DIN : in std_logic_vector (7 downto 0); -- input register
		 MODE : in std_logic_vector (1 downto 0); -- mode selection
		 CLK, RESET : in std_logic; -- clock and reset
		 SDOUT : out std_logic; -- output data
		 DONE : OUT STD_LOGIC
		 ); 
 END COMPONENT;

	SIGNAL BCD0, BCD1, BCD2, BCD3, BCD4: STD_LOGIC_VECTOR(3 downto 0);
	SIGNAL ASCII0, ASCII1, ASCII2, ASCII3, ASCII4: STD_LOGIC_VECTOR(7 downto 0);
	SIGNAL ASCII_HASHTAG: STD_LOGIC_VECTOR(7 downto 0);
	SIGNAL DONE0, DONE1, DONE2, DONE3, DONE4: STD_LOGIC := '0';
	SIGNAL MODE0, MODE1, MODE2, MODE3, MODE4: STD_LOGIC_VECTOR(1 downto 0) := "00"; 
	SIGNAL SERIAL0, SERIAL1, SERIAL2, SERIAL3, SERIAL4: STD_LOGIC := '0';
BEGIN
	FD_DEBUG_SERIAL0 <= SERIAL0;
	FD_DEBUG_SERIAL1 <= SERIAL1;
	FD_DEBUG_SERIAL2 <= SERIAL2;
	FD_DEBUG_SERIAL3 <= SERIAL3;
	CONT : contador PORT MAP 
							(
							CLK, RESET, ECHO,
							sMEDIDA,
							PRONTO_cont
							);
							
	DIVI : divisor PORT MAP
							(
							sMEDIDA,
							PRONTO_cont,
							RESP						
							);
	
	BIN_TO_BCD: binary_bcd 	GENERIC MAP(16)
							PORT MAP (
									CLK, RESET,
									RESP,
									BCD0, BCD1, BCD2, BCD3, BCD4
									);
	ASCII0 <= "0011"&BCD0;
	ASCII1 <= "0011"&BCD1;
	ASCII2 <= "0011"&BCD2;
	ASCII3 <= "0011"&BCD3;
	ASCII_HASHTAG <= "00100011";
	
	SAIDA_SERIAL <= SERIAL0 OR SERIAL1 OR SERIAL2 OR SERIAL3;
	
	SERIE0: serial PORT MAP(
		ASCII0,
		MODE0,
		CLK, RESET,
		SERIAL0,
		DONE0
	);						
	SERIE1: serial PORT MAP(
		ASCII1,
		MODE1,
		CLK, RESET,
		SERIAL1,
		DONE1
	);
	SERIE2: serial PORT MAP(
		ASCII2,
		MODE2,
		CLK, RESET,
		SERIAL2,
		DONE2
	);
	SERIE3: serial PORT MAP(
		ASCII3,
		MODE3,
		CLK, RESET,
		SERIAL3,
		DONE3
	);
	
	
	PROCESS(ECHO, DONE0, DONE1, DONE2)
	BEGIN
		IF(ECHO'EVENT AND ECHO = '0') THEN
			MODE0 <= "01";
		END IF;
		IF(DONE0 = '1') THEN
			MODE0 <= "00";
			MODE1 <= "01";
		END IF;
				
		IF (DONE1 = '1') THEN
			MODE1 <= "00";
			MODE2 <= "01";
		END IF ;
		IF (DONE2 = '1') THEN
			MODE2 <= "00";
			MODE3 <= "01";
		END IF;
	END PROCESS;


	SEG0: hex7seg_en PORT MAP(
							BCD0, 		
							PRONTO_cont,
							A7SEG0 
	);
	SEG1: hex7seg_en PORT MAP(
							BCD1, 		
							PRONTO_cont,
							A7SEG1 
	);
	SEG2: hex7seg_en PORT MAP(
							BCD2, 		
							PRONTO_cont,
							A7SEG2 
	);	
	SEG3: hex7seg_en PORT MAP(
							BCD3, 		
							PRONTO_cont,
							A7SEG3 
	);
	MEDIDA <= sMEDIDA;

	
END ARCHITECTURE;