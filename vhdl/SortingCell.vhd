library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity SortingCell is generic( M: INTEGER := 5; N: INTEGER := 8);

	port(

		write_enable: in std_logic;
		symbol_in: in std_logic_vector(N-1 downto 0);

		read_symbols: in std_logic;

		symbol_out: out std_logic_vector(N-1 downto 0);

		clk: in std_logic;
		rst: in std_logic
	);
end SortingCell;


architecture bhv of SortingCell is

	component sortingcell_sorting_stage 

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

	type data is array (0 to M-1) of std_logic_vector(N-1 downto 0);
	type flag is array (0 to M-1) of std_logic;
	type reset is array (0 to M-1) of std_logic;


	signal stage_write_enable : std_logic := '0';
	signal stage_data : data;
	signal stage_flag : flag;
	signal stage_rst : reset := (others => '0');

	signal counter : integer := 0;
	signal actual_output : integer := 0;
	signal data_requested: boolean := false;
	signal serving_data_request: boolean := false;

begin 
	sorting_pipeline: for stage in 0 to M-1 generate

		first_stage: if stage = 0 generate
			begin frist_stage : sortingcell_sorting_stage port map ( clk => clk,
									    	rst => stage_rst(0),
									    	received_data => symbol_in,
									    	received_flag => stage_write_enable,
									    	forwarded_data => stage_data(stage),
									    	forward_flag => stage_flag(stage));
		end generate first_stage;

		last_stage: if stage = M-1 generate

			begin last_stage : sortingcell_sorting_stage port map ( clk => clk,
									    	rst => stage_rst(stage),
									    	received_data => stage_data(stage -1),
									    	received_flag => stage_flag(stage -1),
									    	forwarded_data => stage_data(stage));
		end generate last_stage;

		normal_stage : if (stage /= 0) and (stage /= M-1) generate

            		begin regular_cells : sortingcell_sorting_stage port map (   clk => clk,
                                                            				rst => stage_rst(stage),
                                                            				received_data => stage_data(stage -1),
						           	 			received_flag => stage_flag(stage -1),
							    				forwarded_data => stage_data(stage),
						            				forward_flag => stage_flag(stage));
            	end generate normal_stage;
	end generate sorting_pipeline;



	rst_setup: for k in 0 to M-1 generate
		stage_rst(k) <= '1' when( rst = '1' or (serving_data_request and actual_output = k)) else '0';
	end generate rst_setup;


	stage_write_enable <= '1' when ( write_enable = '1' and counter /= M) else '0';



	
	counter_state: process(clk)
	begin
		if rising_edge(clk) then
			if rst = '1' then
				counter <= 0;
			else
				if write_enable = '1' and counter < M then
					counter <= counter +1;
				end if;
				if serving_data_request then
					counter <= counter -1;
					actual_output <= actual_output +1;
				else
					actual_output <= 0;
				end if;
			end if;
		end if;
	end process counter_state;

	output_state: process(clk)
	begin
		if rising_edge(clk) then
			if rst = '1' then
				data_requested <= false;
				serving_data_request <= false;
			else
				if read_symbols = '1' and counter >0 and write_enable = '1' then
					data_requested <= true;
				end if;
				if read_symbols = '1' and counter >0 and write_enable = '0' then
					serving_data_request <= true;
				end if;
				if data_requested and write_enable = '0' then
					serving_data_request <= true;
					data_requested <= false;
				end if;
				if counter = 0 then
					serving_data_request <= false;
				end if;
			end if;
		end if;
	end process output_state;


	output: process(clk)
		begin
			if rising_edge(clk) then
				if rst = '1' then
				else
					if serving_data_request and counter >0 and write_enable = '0' then
						symbol_out <= stage_data(actual_output);
					end if;
				end if;
			end if;
	end process output;




end bhv;