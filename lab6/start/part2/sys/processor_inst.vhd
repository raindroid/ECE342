	component processor is
		port (
			clk_clk          : in  std_logic                    := 'X';             -- clk
			led_o_export     : out std_logic_vector(9 downto 0);                    -- export
			quad_hex0_export : out std_logic_vector(6 downto 0);                    -- export
			quad_hex1_export : out std_logic_vector(6 downto 0);                    -- export
			quad_hex2_export : out std_logic_vector(6 downto 0);                    -- export
			quad_hex3_export : out std_logic_vector(6 downto 0);                    -- export
			reset_reset_n    : in  std_logic                    := 'X';             -- reset_n
			sw_i_export      : in  std_logic_vector(9 downto 0) := (others => 'X')  -- export
		);
	end component processor;

	u0 : component processor
		port map (
			clk_clk          => CONNECTED_TO_clk_clk,          --       clk.clk
			led_o_export     => CONNECTED_TO_led_o_export,     --     led_o.export
			quad_hex0_export => CONNECTED_TO_quad_hex0_export, -- quad_hex0.export
			quad_hex1_export => CONNECTED_TO_quad_hex1_export, -- quad_hex1.export
			quad_hex2_export => CONNECTED_TO_quad_hex2_export, -- quad_hex2.export
			quad_hex3_export => CONNECTED_TO_quad_hex3_export, -- quad_hex3.export
			reset_reset_n    => CONNECTED_TO_reset_reset_n,    --     reset.reset_n
			sw_i_export      => CONNECTED_TO_sw_i_export       --      sw_i.export
		);

