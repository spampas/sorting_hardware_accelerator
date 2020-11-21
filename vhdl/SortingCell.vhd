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
		x1_in: in std_logic_vector(N-1 downto 0);
		x2_in: in std_logic_vector(N-1 downto 0);
		x1_out: out std_logic_vector(N-1 downto 0);
		x2_out: out std_logic_vector(N-1 downto 0);

		write_enable: in std_logic;

		clk: in std_logic;
		rst: in std_logic
	);
end sortingcell_comparator_stage;

	begin
		comb_p : process(symbol_in)
			begin
			if unsigned(symbol_in) <= 10 then
				prova <= '0';
			else
				prova <= '1';
			end if;
		end process;
end Beh;

