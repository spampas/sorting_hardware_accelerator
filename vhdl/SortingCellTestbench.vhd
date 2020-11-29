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

constant T_CLK : time := 100 ns;
constant T_RESET : time := 200 ns;
--

--signals
signal clk : std_logic := '0';
signal rst : std_logic := '0';

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
			t := 0;
		elsif(rising_edge(clk)) then
			case(t) is
				when 1 => symbol_in <= (others => 'X');
				when 2 => symbol_in <= std_logic_vector(to_unsigned(3,8)); write_enable <= '1'; 
				when 3 => symbol_in <= std_logic_vector(to_unsigned(1,8));
				when 4 => symbol_in <= std_logic_vector(to_unsigned(4,8)); read_symbols <= '1';
				when 5 => symbol_in <= std_logic_vector(to_unsigned(2,8)); read_symbols <= '0';
				when 6 => symbol_in <= std_logic_vector(to_unsigned(5,8));
				when 7 => symbol_in <= (others => 'X'); write_enable <= '0';
				when 8 => null;
				when 9 => symbol_in <= std_logic_vector(to_unsigned(6,8)); write_enable <= '1';
				when 10 => symbol_in <= std_logic_vector(to_unsigned(10,8)); read_symbols <= '1';
				when 11 => symbol_in <= std_logic_vector(to_unsigned(8,8)); read_symbols <= '0';
				when 12 => symbol_in <= (others => 'X');
				when 13 => write_enable <= '0';
				when 14 => symbol_in <= std_logic_vector(to_unsigned(99,8)); write_enable <= '1';
				when 15 => symbol_in <= (others => 'X'); write_enable <= '0'; 

				when 21 => end_sim <= '0';
				when others => null;
			end case;
			t := t+1;
		end if;
	end process;

end bhv;


-----------------------------------------------------------
