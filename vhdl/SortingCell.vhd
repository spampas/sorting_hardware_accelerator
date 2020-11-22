library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity SortingCell is generic( M: INTEGER := 3; N: INTEGER := 5);

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

	component sortingcell_comparator_stage 

		generic(N: INTEGER := 5);
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


	signal stage_data : data;
	signal stage_flag : flag;

begin 
	sorting_pipeline: for stage in 0 to M-1 generate

		first_stage: if stage = 0 generate
			begin frist_stage : sortingcell_comparator_stage port map ( clk => clk,
									    	rst => rst,
									    	received_data => symbol_in,
									    	received_flag => write_enable,
									    	forwarded_data => stage_data(stage),
									    	forward_flag => stage_flag(stage));
		end generate first_stage;

		last_stage: if stage = M-1 generate

			begin last_stage : sortingcell_comparator_stage port map ( clk => clk,
									    	rst => rst,
									    	received_data => stage_data(stage -1),
									    	received_flag => stage_flag(stage -1),
									    	forwarded_data => stage_data(stage));
		end generate last_stage;

		normal_stage : if (stage /= 0) and (stage /= M-1) generate

            		begin regular_cells : sortingcell_comparator_stage port map (   clk => clk,
                                                            				rst => rst,
                                                            				received_data => stage_data(stage -1),
						           	 			received_flag => stage_flag(stage -1),
							    				forwarded_data => stage_data(stage),
						            				forward_flag => stage_flag(stage));
            	end generate normal_stage;
	end generate sorting_pipeline;
end bhv;