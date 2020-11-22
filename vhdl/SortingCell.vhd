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


architecture Beh of SortingCell is
	component sortingcell_comparator_stage is generic(N: INTEGER := 5);
		port(
			received_data: in std_logic_vector(N-1 downto 0);
			received_flag: in std_logic;
		
			forwarded_data: out std_logic_vector(N-1 downto 0);
			forward_flag: out std_logic;

			clk: in std_logic;
			rst: in std_logic
		);
end sortingcell_comparator_stage;

begin

end Beh;

