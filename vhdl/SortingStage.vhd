library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

-- This module is a stage of the pipeline that makes the sorting.
-- The generic N is the number of bits of the unsigned that we want to sort.

--------Sorting Stage Entity ---------------------------------------------------------------
entity sortingcell_sorting_stage is generic(N: INTEGER := 5);
	port(
		received_data: in std_logic_vector(N-1 downto 0);
		received_flag: in std_logic;
		
		forwarded_data: out std_logic_vector(N-1 downto 0);
		forward_flag: out std_logic;

		clk: in std_logic;
		rst: in std_logic
	);
end sortingcell_sorting_stage;

----------------------------------------------------------------------------------------------

------- Sorting Stage Architecture -----------------------------------------------------------
architecture bhv of sortingcell_sorting_stage is

	signal empty : boolean := true; -- when empty is true, the stage does not contain any unsigned value
	signal current_data : std_logic_vector (N-1 downto 0) := (others => '0');
begin

	state: process(clk)
	begin
		if rising_edge(clk) then
			if rst = '1' then
				empty <= true;
			else
				if received_flag = '1' then -- a new unsigned is arrived from previous stage
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
							if unsigned(received_data) < unsigned(current_data) then
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
----------------------------------------------------------------------------------------------------------
	
