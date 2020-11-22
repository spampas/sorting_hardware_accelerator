library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity sortingcell_comparator_stage is generic(N: INTEGER := 5);
	port(
		received_data: in std_logic_vector(N-1 downto 0);
		received_flag: in std_logic;
		
		forwarded_data: out std_logic_vector(N-1 downto 0);
		forward_flag: out std_logic;

		clk: in std_logic;
		rst: in std_logic
	);
end sortingcell_comparator_stage;


architecture bhv of sortingcell_comparator_stage is
	
	signal empty : boolean := true;
	signal current_data : std_logic_vector (N-1 downto 0) := (others => '0');
begin
	
	--forward_flag <= '1' when( received_flag = '1' and not empty) else '0';

	state: process(clk)
	begin
		if rising_edge(clk) then
			if rst = '1' then
				empty <= true;
			else
				if received_flag = '1' then
					empty <= false;
				end if;
			end if;
		end if;
	end process state;

	data: process(clk)
	begin
		if rising_edge(clk) then
			if rst = '1' then
				current_data <= (others => '0');
				forwarded_data <= (others =>'0');
			else
				if received_flag = '1' then
					case empty is
						when true =>
							current_data <= received_data;
						when false =>
							if received_data < current_data then
								forwarded_data <= current_data;
								current_data <= received_data;
							else
								forwarded_data <= received_data;
							end if;
					end case;
				else 
					forwarded_data <= current_data;
				end if;
				
				
			end if;

		end if;
	end process data;

	flag: process(clk)
	begin
		if rising_edge(clk) then
			if rst = '1' then
				forward_flag <= '0';
			else
				if received_flag = '1' and not empty then
					forward_flag <= '1';
				else
					forward_flag <= '0';
				end if;	
			end if;

		end if;
	end process flag;
	
end bhv;
	
