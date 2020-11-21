library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity sortingcell_comparator_stage is generic(N: INTEGER := 5);
	port(
		received_data: in std_logic_vector(N-1 downto 0);
		received_flag: in std_logic;
		
		forwarded_data: out std_logic_vector(N-1 downto 0);
		forward_flag: in std_logic;

		clk: in std_logic;
		rst: in std_logic
	);
end sortingcell_comparator_stage;


architecture bhv of sortingcell_comparator_stage is

	signal empty : boolean := true;
	signal current_data: std_logic_vector(N-1 down to 0) := (others => '0');
begin
	
	sort: process(clk)
		begin
		if(rising_edge(clk)) then
			if(rst = '1') then
				forwarded_data <= (others => '0');
				forward_flag <= '0';
				empty <= true;
			else
				if( receive_flag = '1') then
					case empty is
						when false =>
							if unsigned(received_data) <= unsigned(current_data) then
				
							else
								forward_flag <= '1';
								forwarded_data <= received_data;
					
							end if;
						when true =>
							current_data <= received_data;
							empty <= false;
					end case;
				end if;
			end if;
		end if;
	end process;
end bhv;
	
