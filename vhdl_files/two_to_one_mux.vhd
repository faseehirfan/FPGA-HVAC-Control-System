-- Group 22, Section 204
-- Muneeb F, Rawsab S

library ieee;
use ieee.std_logic_1164.all;

entity two_to_one_mux is
port (
	input_A										: in std_logic_vector(3 downto 0); -- desired temp
	input_B										: in std_logic_vector(3 downto 0); -- vacation_temp
	mux_select									: in std_logic; -- "vacation mode"
	output										: out std_logic_vector(3 downto 0) -- the hex output
);

end two_to_one_mux;

architecture mux_logic of two_to_one_mux is

begin

-- "If-then-else" block used to change output based on mux_select.

	process(input_A, input_B, mux_select)
	begin
		if mux_select = '0' then
			output <= input_A;
		else
			output <= input_B;
		end if;
	end process;

					
end mux_logic;