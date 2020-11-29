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

constant T_CLK : time := 100ns;
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

--port mapping
	dut: SortingCell generic map( N => N, M => M)

		port map ( write_enable => write_enable,
			symbol_in => symbol_in,
			read_symbols => read_symbols,
			symbol_out => symbol_out,
			clk => clk,
			rst => rst);
--

	CLOCK: clk <= (not(clk) and end_sim) after T_CLK/2;

	d_process : process(clk)
		variable t : integer := 0;
	begin
		if(rising_edge(clk)) then
			case(t) is
				when 1 => write_enable <= '0'; symbol_in <= (others => '0'); read_symbols <= '0';
				when 2 => write_enable <= '1'; symbol_in <= std_logic_vector(to_unsigned(3,8)); read_symbols <= '0';
				when 3 => write_enable <= '1'; symbol_in <= std_logic_vector(to_unsigned(1,8)); read_symbols <= '0';
				when 4 => write_enable <= '1'; symbol_in <= std_logic_vector(to_unsigned(4,8)); read_symbols <= '1';
				when 5 => write_enable <= '1'; symbol_in <= std_logic_vector(to_unsigned(2,8)); read_symbols <= '0';
				when 6 => write_enable <= '1'; symbol_in <= std_logic_vector(to_unsigned(5,8)); read_symbols <= '0';
				when 7 => write_enable <= '0'; symbol_in <= (others => '0'); read_symbols <= '0';
				when 8 => write_enable <= '0'; symbol_in <= (others => '0'); read_symbols <= '0';
				when 9 => write_enable <= '1'; symbol_in <= std_logic_vector(to_unsigned(6,8)); read_symbols <= '0';
				when 10 => write_enable <= '1'; symbol_in <= std_logic_vector(to_unsigned(10,8)); read_symbols <= '1';
				when 11 => write_enable <= '1'; symbol_in <= std_logic_vector(to_unsigned(8,8)); read_symbols <= '0';
				when 12 => write_enable <= '1'; symbol_in <= (others => '0'); read_symbols <= '0';
				when 13 => write_enable <= '0'; symbol_in <= (others => '0'); read_symbols <= '0';
				when 14 => write_enable <= '1'; symbol_in <= std_logic_vector(to_unsigned(99,8)); read_symbols <= '0';
				when 15 => write_enable <= '0'; symbol_in <= (others => '0'); read_symbols <= '0';
				when 16 => write_enable <= '0'; symbol_in <= (others => '0'); read_symbols <= '0';
				when 17 => write_enable <= '0'; symbol_in <= (others => '0'); read_symbols <= '0';
				when 18 => write_enable <= '0'; symbol_in <= (others => '0'); read_symbols <= '0';

				when others => null;
			end case;
			t := t+1;
		end if;
	end process;

end bhv;


-----------------------------------------------------------
