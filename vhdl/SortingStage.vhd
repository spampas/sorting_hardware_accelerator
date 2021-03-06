library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

-- This module is a stage of the pipeline that makes the sorting.
-- The generic N is the number of bits of the unsigned that we want to sort.

--------Sorting Stage Entity ---------------------------------------------------------------
entity sorting_stage is generic(N: INTEGER := 8);
	port(
		received_data: in std_logic_vector(N-1 downto 0);
		received_flag: in std_logic; -- '1' when previous stage wants to send data
		
		forwarded_data: out std_logic_vector(N-1 downto 0);
		forward_flag: out std_logic; -- '1' when this stage wants to send data to next stage

		clk: in std_logic;
		rst: in std_logic
	);
end sorting_stage;

----------------------------------------------------------------------------------------------

------- Sorting Stage Architecture -----------------------------------------------------------
architecture bhv of sorting_stage is

	signal empty : boolean := true; -- when empty is true, the stage does not contain any unsigned value
	signal current_data : std_logic_vector (N-1 downto 0) := (others => '0');
begin

	state: process(clk)
	begin
		if rising_edge(clk) then
			if rst = '0' then
				empty <= true;
			elsif received_flag = '1' then -- a new unsigned is arrived from previous stage
				empty <= false;
				end if;
		end if;
	end process state;

	flag: process(clk)
	begin
		if rising_edge(clk) then
			if rst = '0' then
				forward_flag <= '0';
			elsif received_flag = '1' and not empty then --if it receives data and it is not empty
				forward_flag <= '1'; -- it forwards data, so forward flag is set to 1
			else
				forward_flag <= '0'; -- else, it set to 0
			end if;	
		end if;
	end process flag;

	data: process(clk)
	begin
		if rising_edge(clk) then
			if rst = '0' then
				current_data <= (others => '0');
				forwarded_data <= (others =>'0');
			elsif received_flag = '1' then
				case empty is
					when true => --when it receives data and it is empty, current data become the received data
						current_data <= received_data;
					when false => -- when is not empty
						if unsigned(received_data) < unsigned(current_data) then -- if received data is less than current data
							forwarded_data <= current_data; -- stage forwards its current data
							current_data <= received_data; -- and received data become the current data
						else
							forwarded_data <= received_data; --else the received data is forwarded
						end if;
				end case;
			else 
				forwarded_data <= current_data;
			end if;
		end if;
	end process data;
	
end bhv;
----------------------------------------------------------------------------------------------------------
	
