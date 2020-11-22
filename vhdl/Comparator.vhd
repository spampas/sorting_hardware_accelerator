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
	signal change_state: boolean := false;
	signal current_data: std_logic_vector(N-1 downto 0) := (others => '0');
begin

	change_state <= (received_data < current_data) or empty;
	forwarded_data <= current_data;
	forward_flag <= '1' when (change_state and not empty) else '0';
	
	sort: process(clk)
		begin
		if(rising_edge(clk)) then
			if(rst = '1') then
				empty <= true;
			else
				if(received_flag = '1') then
					case empty is
						when true =>
							current_data <= received_data;
							empty <= false;
						when false =>
							if(change_state) then
								current_data <= received_data;
								empty <= false;
							end if;
					end case;
				end if;
				
			end if;
		end if;
	end process;
end bhv;
	
