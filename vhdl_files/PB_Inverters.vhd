-- Group 22, Section 204
-- Muneeb F, Rawsab S

LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY PB_Inverters IS
	PORT
		(
			pb_n	:	IN std_logic_vector(3 downto 0);
			vc_mode, MC_test_mode, window_open, door_open		:	OUT std_logic
		);
END PB_Inverters;

ARCHITECTURE gates OF PB_Inverters IS

BEGIN

-- Inverts pb input.
vc_mode <= not(pb_n(3));
MC_test_mode <= not(pb_n(2));
window_open <= not(pb_n(1));
door_open <= not(pb_n(0));

END gates;