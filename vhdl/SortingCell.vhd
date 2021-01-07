library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

--this is the main module, which contains the pipeline sorting stages
-- and implements all the synchronization features

-- The generic N is the number of bits of the unsigned that we want to sort.
-- The generic M is the number of unsigned that the SortingCell can store.

-- SortingCell entity ---------------------------------------------------------------

entity SortingCell is generic( M: INTEGER := 5; N: INTEGER := 8); --testbench
-- entity SortingCell is generic( M: INTEGER := 10; N: INTEGER := 8); --synthezis

	port(

		write_enable: in std_logic; --when we want to insert a number to sort must be set to 1
		symbol_in: in std_logic_vector(N-1 downto 0);

		read_symbols: in std_logic; --when we want to read all sorted numbers must be set to 1 from one clock cycle

		symbol_out: out std_logic_vector(N-1 downto 0);

		clk: in std_logic;
		rst: in std_logic
	);
end SortingCell;
--------------------------------------------------------------------------------------

--SortingCell architecture -----------------------------------------------------------
architecture bhv of SortingCell is

	-- stage component neeeded
	component sorting_stage 

		generic(N: INTEGER := 8);
		port(
			received_data: in std_logic_vector(N-1 downto 0);
			received_flag: in std_logic;
		
			forwarded_data: out std_logic_vector(N-1 downto 0);
			forward_flag: out std_logic;

			clk: in std_logic;
			rst: in std_logic
		);
	end component;

	-- these arrays are the input/output for each pipeline stage
	type data is array (0 to M-1) of std_logic_vector(N-1 downto 0);
	type flag is array (0 to M-1) of std_logic;

	-- this array is for the reset of each pipeline stage 
	type reset is array (0 to M-1) of std_logic;

	-- Signals
	signal stage_data : data;
	signal stage_flag : flag;
	signal stage_rst : reset := (others => '0');

	signal counter : integer := 0; --number of unsigned stored in sortingCell
	signal actual_output : integer := 0; --useful for identify output to send out 
	signal data_requested: boolean := false; --flag useful when a reading request arrives, but sortingcell can not serve it immediately
	signal serving_data_request: boolean := false; -- state representing sending out sorted unsigned
	signal reading_data : std_logic := '0'; -- state represents the storage of new data

begin 

	-- port mapping -----------------------------------------------------------------------------------------
	sorting_pipeline: for stage in 0 to M-1 generate

		-- first pipeline stage
		first_stage: if stage = 0 generate
			begin frist_stage : sorting_stage port map ( 	clk => clk,
									rst => stage_rst(0),
									received_data => symbol_in,
									received_flag => reading_data,
									forwarded_data => stage_data(stage),
									forward_flag => stage_flag(stage));
		end generate first_stage;

		-- last pipeline stage
		last_stage: if stage = M-1 generate

			begin last_stage : sorting_stage port map ( 	clk => clk,
									rst => stage_rst(stage),
									received_data => stage_data(stage -1),
									received_flag => stage_flag(stage -1),
									forwarded_data => stage_data(stage));
		end generate last_stage;

		-- other pipeline stages
		normal_stage : if (stage /= 0) and (stage /= M-1) generate

            		begin regular_cells : sorting_stage port map (  clk => clk,
                                                            		rst => stage_rst(stage),
                                                            		received_data => stage_data(stage -1),
									received_flag => stage_flag(stage -1),
							    		forwarded_data => stage_data(stage),
						            		forward_flag => stage_flag(stage));
            	end generate normal_stage;
	end generate sorting_pipeline;
	----------------------------------------------------------------------------------------------------------


	-- each time the current value of a stage is sent out as output of the sorting cell, 
	-- the stage is resetted (set state to empty and currrent value equal to 0) putting its rst to 0
	rst_setup: for k in 0 to M-1 generate
		stage_rst(k) <= '0' when( rst = '0' or (serving_data_request and actual_output = k)) else '1';
	end generate rst_setup;

	-- sorting cell accepts data in input if write_enable is set to 1, sorting cell is not full and when
	-- it is not send out data as output
	reading_data <= '1' when ( write_enable = '1' and counter /= M and not serving_data_request) else '0';

	-- if sortingcell is in "serving_data_request" state, it sends out as output a current value of a stage for
	-- each clock cycle
	symbol_out <= stage_data(actual_output) when (serving_data_request) else (others => 'Z');

	--actual output represents the stage index whose value is to be sent out as output. 
	--At each clock, as long as we are in the "serving_data_request" state, its value is increased.
	actual_output_state: process(clk)
	begin
		if rising_edge(clk) then
			if rst = '0' then
				actual_output <= 0;
			elsif serving_data_request then
				actual_output <= actual_output +1;
			else
				actual_output <= 0;
			end if;
		end if;
	end process actual_output_state;


	output_state: process(clk)
	begin
		if rising_edge(clk) then
			if rst = '0' then
				counter <= 0;
				data_requested <= false;
				serving_data_request <= false;
			elsif reading_data = '1' then -- if sortingcell is in "reading_data" state, it is accepting new data
				counter <= counter +1; --so counter is incremented
				if read_symbols = '1' then -- if sortingcell is storing new data and read_symbols is equal to 1
					data_requested <= true; -- data_requested flag is set to 1 -> pending request
				end if;
			--if sortingcell is not storing new data and, read_symbols is equal to 1 or there is a pending request (data_requested is true)
			-- sortingcell passes into the state of "serving_data_request"
			elsif reading_data = '0' and (data_requested or  read_symbols = '1') then 
				serving_data_request <= true;
				data_requested <= false;
			elsif actual_output = M -1 then --when all the M unisgned are sent out, sortingcell exits from the state of "serving_data_request"
				serving_data_request <= false;
				counter <= 0;
			end if;
		end if;
	end process output_state;


end bhv;
---------------------------------------------------------------------------------------------------------------