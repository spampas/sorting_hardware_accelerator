library IEEE;
use IEEE.std_logic_1164.all;
use STD.textio.all;
use IEEE.std_logic_textio.all;
use IEEE.numeric_std.all;

-- TestBench

--sortingcell_tb entity ---------------------------------
entity sortingcell_tb is
end sortingcell_tb;
----------------------------------------------------------

--sortingcell_tb architecture -----------------------------

architecture bhv of sortingcell_tb is

--constants
constant N : integer := 8;
constant M : integer := 5;

constant T_CLK : time := 10 ns;
constant T_RESET : time := 50 ns;
--

--signals
signal clk : std_logic := '0';
signal rst : std_logic := '1';

signal write_enable : std_logic := '0';
signal symbol_in : std_logic_vector(N-1 downto 0);

signal read_symbols : std_logic := '0';
signal symbol_out : std_logic_vector(N-1 downto 0);


signal end_sim : std_logic := '1';
--

--component
component SortingCell is generic( M: INTEGER ; N: INTEGER );

	port(

		write_enable: in std_logic;
		symbol_in: in std_logic_vector(N-1 downto 0);

		read_symbols: in std_logic;

		symbol_out: out std_logic_vector(N-1 downto 0);

		clk: in std_logic;
		rst: in std_logic
	);
end component SortingCell;
--

begin

	
	clk <= (not(clk) and end_sim) after T_CLK/2;
	rst <= '1' after T_RESET;
	
--port mapping
	dut: SortingCell generic map( N => N, M => M)

		port map ( write_enable => write_enable,
			symbol_in => symbol_in,
			read_symbols => read_symbols,
			symbol_out => symbol_out,
			clk => clk,
			rst => rst);
--

	d_process : process(clk)
		variable t : integer := 0;
	begin
		if(rst = '0') then
			write_enable <= '0';
			read_symbols <= '0';
			end_sim <= '1';
			symbol_in <= (others => 'X');
			t := 0;
		elsif(rising_edge(clk)) then
			case(t) is
				when 1 => symbol_in <= std_logic_vector(to_unsigned(3,8)); write_enable <= '1';    --Start to write (5 numbers)
				when 2 => symbol_in <= std_logic_vector(to_unsigned(1,8));
				when 3 => symbol_in <= std_logic_vector(to_unsigned(3,8));
				when 4 => symbol_in <= std_logic_vector(to_unsigned(2,8)); 
				when 5 => symbol_in <= std_logic_vector(to_unsigned(0,8));	-- Last element
				when 6 => symbol_in <= std_logic_vector(to_unsigned(9,8));      -- Overflow: 9 is discarded
				when 7 => symbol_in <= (others => 'X'); write_enable <= '0';	-- Stop writing
				when 8 => read_symbols <= '1';	--Read request (starts after one clock and lasts for 5 clocks). Sequence: [0 1 2 3 3]
				when 9 => read_symbols <= '0';  --The read request stay to 1 only for one clock every time
				when 10 => null;
				when 11 => symbol_in <= std_logic_vector(to_unsigned(9,8)); write_enable <= '1'; --Write request during a reading (ignored)
				when 12 => symbol_in <= (others => 'X'); write_enable <= '0';
				when 13 => null;	--End of reading. The vector of numbers is emptied (it contains now 5 zeros)
				when 14 => read_symbols <= '1';	--Read request for a empty vector. Reads this sequence: [0 0 0 0 0]
				when 15 => read_symbols <= '0';
				when 19 => null;	--End of reading. The vector of numbers is emptied (it contains now 5 zeros)
				when 20 => symbol_in <= std_logic_vector(to_unsigned(7,8)); write_enable <= '1'; read_symbols <='1'; --Both writing request and reading request: it writes until write_enable is 1, then it reads
				when 21 => symbol_in <= std_logic_vector(to_unsigned(4,8)); read_symbols <= '0';
				when 22 => symbol_in <= std_logic_vector(to_unsigned(9,8));  
				when 23 => symbol_in <= (others => 'X'); write_enable <= '0'; --Finish to write. The next clock start to read with a non-full vector. Sequence: [4 7 9 0 0]
				when 24 => read_symbols <= '1'; --Reading request when a reading is performed: ignored
 				when 25 => read_symbols <= '0'; 
				
				when 30 => end_sim <= '0';  --End simulation
				when others => null;
			end case;
			t := t+1;
		end if;
	end process;

end bhv;


-----------------------------------------------------------
