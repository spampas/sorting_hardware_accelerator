create_clock -period 8.000 -name PL_clock -waveform {0.000 4.000} -add [get_ports clk]




set_property IOSTANDARD LVCMOS33 [get_ports {symbol_in[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {symbol_in[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {symbol_in[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {symbol_in[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {symbol_in[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {symbol_in[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {symbol_in[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {symbol_in[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {symbol_out[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {symbol_out[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {symbol_out[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {symbol_out[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {symbol_out[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {symbol_out[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {symbol_out[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {symbol_out[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports read_symbols]
set_property IOSTANDARD LVCMOS33 [get_ports rst]
set_property IOSTANDARD LVCMOS33 [get_ports write_enable]
set_property PACKAGE_PIN V18 [get_ports {symbol_in[7]}]
set_property PACKAGE_PIN W18 [get_ports {symbol_in[6]}]
set_property PACKAGE_PIN W19 [get_ports {symbol_in[5]}]
set_property PACKAGE_PIN N17 [get_ports {symbol_in[4]}]
set_property PACKAGE_PIN P18 [get_ports {symbol_in[3]}]
set_property PACKAGE_PIN P15 [get_ports {symbol_in[2]}]
set_property PACKAGE_PIN P16 [get_ports {symbol_in[1]}]
set_property PACKAGE_PIN T19 [get_ports {symbol_in[0]}]
set_property PACKAGE_PIN V20 [get_ports {symbol_out[7]}]
set_property PACKAGE_PIN W20 [get_ports {symbol_out[6]}]
set_property PACKAGE_PIN Y18 [get_ports {symbol_out[5]}]
set_property PACKAGE_PIN Y19 [get_ports {symbol_out[4]}]
set_property PACKAGE_PIN V16 [get_ports {symbol_out[3]}]
set_property PACKAGE_PIN W16 [get_ports {symbol_out[2]}]
set_property PACKAGE_PIN R16 [get_ports {symbol_out[1]}]
set_property PACKAGE_PIN R17 [get_ports {symbol_out[0]}]
set_property PACKAGE_PIN U14 [get_ports clk]
set_property PACKAGE_PIN V17 [get_ports read_symbols]
set_property PACKAGE_PIN R18 [get_ports rst]
set_property PACKAGE_PIN T17 [get_ports write_enable]




