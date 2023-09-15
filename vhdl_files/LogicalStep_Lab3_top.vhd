library ieee;
use ieee.std_logic_1164.all;


entity LogicalStep_Lab3_top is port (
	clkin_50		: in 	std_logic;
	pb_n			: in	std_logic_vector(3 downto 0);
 	sw   			: in  std_logic_vector(7 downto 0); 	
	
	----------------------------------------------------
--	HVAC_temp : out std_logic_vector(3 downto 0); -- used for simulations only. Comment out for FPGA download compiles.
	----------------------------------------------------
	
   leds			: out std_logic_vector(7 downto 0);
   seg7_data 	: out std_logic_vector(6 downto 0); -- 7-bit outputs to a 7-segment
	seg7_char1  : out	std_logic;				    		-- seg7 digit1 selector
	seg7_char2  : out	std_logic				    		-- seg7 digit2 selector
	
); 
end LogicalStep_Lab3_top;

architecture design of LogicalStep_Lab3_top is
--
-- Provided Project Components Used
------------------------------------------------------------------- 

component SevenSegment  port (
   hex	   :  in  std_logic_vector(3 downto 0);   -- The 4 bit data to be displayed
   sevenseg :  out std_logic_vector(6 downto 0)    -- 7-bit outputs to a 7-segment
); 
end component SevenSegment;

component segment7_mux port (
          clk        : in  std_logic := '0';
			 DIN2 		: in  std_logic_vector(6 downto 0);	
			 DIN1 		: in  std_logic_vector(6 downto 0);
			 DOUT			: out	std_logic_vector(6 downto 0);
			 DIG2			: out	std_logic;
			 DIG1			: out	std_logic
        );
end component segment7_mux;

component Compx4 port (
	in_A, in_B			: in std_logic_vector(3 downto 0);
	agtb_out				: out std_logic;
	aeqb_out				: out std_logic;
	altb_out				: out std_logic
	);

end component Compx4;
	

component Bidir_shift_reg  port (
		CLK					: in std_logic := '0';
		RESET					: in std_logic := '0';
		CLK_EN				: in std_logic := '0';
		LEFT0_RIGHT1		: in std_logic := '0';
		REG_BITS				: out std_logic_vector(7 downto 0)
		);
end component;


component U_D_Bin_Counter8bit port (
			CLK				: in std_logic;
			RESET				: in std_logic;
			CLK_EN			: in std_logic;
			UP1_DOWN0		: in std_logic;
			COUNTER_BITS	: out std_logic_vector(7 downto 0)
			);
end component;


component PB_Inverters PORT
		(
			pb_n					:	IN std_logic_vector(3 downto 0);
			vc_mode				:	OUT std_logic;
			MC_test_mode		:	OUT std_logic;
			window_open			:	OUT std_logic;
			door_open			:	OUT std_logic
		);
END component;
	
	
component Tester port (
 MC_TESTMODE				: in  std_logic;
 I1EQI2,I1GTI2,I1LTI2	: in	std_logic;
	input1					: in  std_logic_vector(3 downto 0);
	input2					: in  std_logic_vector(3 downto 0);
	TEST_PASS  				: out	std_logic							 
	); 
	end component;
--	

component HVAC 	port (
	HVAC_SIM						: in boolean;
	clk							: in std_logic; 
	h_run		   				: in std_logic;
	h_increase, h_decrease	: in std_logic;
	temp							: out std_logic_vector (3 downto 0)
	);
end component;


component Energy_Monitor port (
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
end component;


component two_to_one_mux port (
		input_A										: in std_logic_vector(3 downto 0);
		input_B										: in std_logic_vector(3 downto 0);
		mux_select									: in std_logic;
		output										: out std_logic_vector(3 downto 0)
);
end component;


------------------------------------------------------------------	
-- Create any additional internal signals to be used
------------------------------------------------------------------	
constant HVAC_SIM : boolean := FALSE; -- set to FALSE when compiling for FPGA download to LogicalStep board 
                                      -- or TRUE for doing simulations with the HVAC Component
------------------------------------------------------------------	

-- global clock
signal clk_in					: std_logic;
signal hex_A, hex_B 			: std_logic_vector(3 downto 0);
signal hexA_7seg, hexB_7seg: std_logic_vector(6 downto 0);

signal h_run				: std_logic;
signal h_increase			: std_logic;
signal h_decrease			: std_logic;

signal agtb_out			: std_logic;
signal aeqb_out			: std_logic;
signal altb_out			: std_logic;

signal vacation_mode		: std_logic;
signal MC_test_mode		: std_logic;

signal h_window_open		: std_logic;
signal h_door_open		: std_logic;

signal mux_temp			: std_logic_vector(3 downto 0);
signal current_temp		: std_logic_vector(3 downto 0);

signal muxtemp_7seg		: std_logic_vector(6 downto 0);
signal curtemp_7seg		: std_logic_vector(6 downto 0);

------------------------------------------------------------------- 
begin -- Here the circuit begins

clk_in <= clkin_50;	--hook up the clock input

-- temp inputs hook-up to internal busses.
hex_A <= sw(3 downto 0);
hex_B <= sw(7 downto 4);

inst1: sevensegment port map (mux_temp, muxtemp_7seg);
inst2: sevensegment port map (current_temp, curtemp_7seg);
inst3: segment7_mux port map (clk_in, muxtemp_7seg, curtemp_7seg, seg7_data, seg7_char2, seg7_char1);

inst4: Compx4 port map (mux_temp, current_temp, agtb_out, aeqb_out, altb_out);
INST5: PB_Inverters port map (pb_n(3 downto 0), vacation_mode, MC_test_mode, h_window_open, h_door_open);
inst6: two_to_one_mux port map (hex_A, hex_B, vacation_mode, mux_temp);
inst7: Tester port map (MC_test_mode, aeqb_out, agtb_out, altb_out, hex_A, current_temp, leds(6));
inst8: HVAC port map (HVAC_SIM, clk_in, h_run, h_increase, h_decrease, current_temp);
inst9: Energy_Monitor port map (agtb_out, aeqb_out, altb_out, vacation_mode, MC_test_mode, h_window_open, h_door_open, leds(0), leds(1), leds(2), leds(3), leds(4), leds(5), leds(7), h_decrease, h_increase, h_run);
		
		
-- inst5: Bidir_shift_reg port map (clk_in, NOT(pb_n(0)), sw(0), sw(1), leds(7 downto 0));
-- inst6: U_D_Bin_Counter8bit port map (clk_in, NOT(pb_n(0)), sw(0), sw(1), leds(7 downto 0));
		
		
end design;

