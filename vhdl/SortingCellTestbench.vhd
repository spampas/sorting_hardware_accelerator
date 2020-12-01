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
constant T_RESET : time := 100 ns;
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
	rst <= '0' after T_RESET;
	
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
				when 2 => symbol_in <= std_logic_vector(to_unsigned(3,8)); write_enable <= '1';    --Inizia la scrittura (max 5 elementi)
				when 3 => symbol_in <= std_logic_vector(to_unsigned(1,8));
				when 4 => symbol_in <= std_logic_vector(to_unsigned(3,8));
				when 5 => symbol_in <= std_logic_vector(to_unsigned(2,8)); 
				when 6 => symbol_in <= std_logic_vector(to_unsigned(4,8));	-- Ultimo elemento
				when 7 => symbol_in <= std_logic_vector(to_unsigned(21,8));      -- Overflow: Viene scartato
				when 8 => symbol_in <= (others => 'X'); write_enable <= '0';	-- Termina la scrittura
				when 9 => read_symbols <= '1';	--Richiesta di lettura (parte subito e impiega 5 clock)
				when 10 => read_symbols <= '0';
				when 11 => symbol_in <= std_logic_vector(to_unsigned(21,8)); write_enable <= '1'; --Richiesta di scrittura durante una lettura (ignorata)
				when 12 => symbol_in <= (others => 'X'); write_enable <= '0';
				when 13 => null;	--Termina la lettura, il vettore viene inizializzato nuovamente a zero
				when 14 => read_symbols <= '1';	--Lettura su insieme vuoto (Ritorna 5 zeri)
				when 19 => symbol_in <= std_logic_vector(to_unsigned(97,8)); write_enable <= '1'; --Inizia la scrittura
				when 20 => symbol_in <= std_logic_vector(to_unsigned(4,8));
				when 21 => symbol_in <= std_logic_vector(to_unsigned(15,8));
				when 22 => symbol_in <= std_logic_vector(to_unsigned(21,8)); read_symbols <= '1'; --Lettura anticipata: verranno letti k valori corretti preceduti da M-K zeri. Scrittura ignorata
				when 23 => symbol_in <= (others => 'X'); read_symbols <= '0'; write_enable <= '0';
				when 26 => null; --Termina la lettura
				when 30 => end_sim <= '0';
				when others => null;
			end case;
			t := t+1;
		end if;
	end process;

end bhv;


-----------------------------------------------------------
