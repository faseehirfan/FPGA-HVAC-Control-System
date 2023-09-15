library ieee;
use ieee.std_logic_1164.all;


entity Compx1 is port (
	input_A, input_B		: in  std_logic;
	gr_out					: out  std_logic; -- A > B Output
	eq_out					: out  std_logic; -- A = B Output
	le_out					: out  std_logic -- A < B Output
);

end Compx1;

architecture Compx1_logic of Compx1 is

begin

	gr_out <= input_A AND (NOT input_B);
	eq_out <= input_A XNOR input_B;
	le_out <= (NOT input_A) AND input_B;
	
end Compx1_logic;