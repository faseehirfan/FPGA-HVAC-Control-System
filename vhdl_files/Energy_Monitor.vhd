library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Energy_Monitor is

	port
	(
 	agtb						: in  std_logic;
	aeqb						: in  std_logic;
	altb						: in  std_logic;
   vacation_mode			: in	std_logic;
	MC_test_mode			: in  std_logic;
	window_open				: in  std_logic;
	door_open  				: in	std_logic;
	furnace					: out std_logic;
	at_temp					: out std_logic;
	AC							: out std_logic;
	blower					: out std_logic;
	window					: out std_logic;
	door						: out std_logic;
	vacation					: out std_logic;
	decrease					: out std_logic;
	increase					: out std_logic;
	run						: out std_logic
	);

end entity;


architecture Energy_Monitor_logic of Energy_Monitor is
begin

run <= NOT(aeqb) AND NOT(window_open) AND NOT(door_open) AND NOT(MC_test_mode);
decrease <= altb;
increase <= agtb;

AC <= altb;
furnace <= agtb;
at_temp <= aeqb;
blower <= NOT(aeqb) AND NOT(MC_test_mode) AND NOT(window_open) AND NOT(door_open);

door <= door_open;
window <= window_open;
vacation <= vacation_mode;


end Energy_Monitor_logic;


