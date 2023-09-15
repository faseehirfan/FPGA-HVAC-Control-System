library ieee;
use ieee.std_logic_1164.all;


entity Compx4 is port (
	in_A, in_B			: in std_logic_vector(3 downto 0);
	agtb_out				: out std_logic;
	aeqb_out				: out std_logic;
	altb_out				: out std_logic
);

end Compx4;

architecture Compx4_logic of Compx4 is

	component Compx1 port (
		input_A, input_B		: in  std_logic;
		gr_out					: out  std_logic; -- A > B Output
		eq_out					: out  std_logic; -- A = B Output
		le_out					: out  std_logic -- A < B Output
	);
	end component;

	
	signal AGTB		: std_logic_vector(3 downto 0);
	signal AEQB		: std_logic_vector(3 downto 0);
	signal ALTB		: std_logic_vector(3 downto 0);
	
	
begin

	INST1: Compx1 port map (in_A(0), in_B(0), AGTB(0), AEQB(0), ALTB(0));
	INST2: Compx1 port map (in_A(1), in_B(1), AGTB(1), AEQB(1), ALTB(1));
	INST3: Compx1 port map (in_A(2), in_B(2), AGTB(2), AEQB(2), ALTB(2));
	INST4: Compx1 port map (in_A(3), in_B(3), AGTB(3), AEQB(3), ALTB(3));


	aeqb_out <= (AEQB(0) AND AEQB(1) AND AEQB(2) AND AEQB(3));
	agtb_out <= (AGTB(3)) OR (AEQB(3) AND AGTB(2)) OR (AEQB(3) AND AEQB(2) AND AGTB(1)) OR (AEQB(3) AND AEQB(2) AND AEQB(1) AND AGTB(0));
	altb_out <= (ALTB(3)) OR (AEQB(3) AND ALTB(2)) OR (AEQB(3) AND AEQB(2) AND ALTB(1)) OR (AEQB(3) AND AEQB(2) AND AEQB(1) AND ALTB(0));
	
	
	
end Compx4_logic;