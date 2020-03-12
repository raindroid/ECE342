	component processor is
		port (
			clk_clk                : in  std_logic                    := 'X';             -- clk
			lda_vga_b_export       : out std_logic_vector(7 downto 0);                    -- export
			lda_vga_blank_n_export : out std_logic;                                       -- export
			lda_vga_clk_export     : out std_logic;                                       -- export
			lda_vga_g_export       : out std_logic_vector(7 downto 0);                    -- export
			lda_vga_hs_export      : out std_logic;                                       -- export
			lda_vga_r_export       : out std_logic_vector(7 downto 0);                    -- export
			lda_vga_sync_n_export  : out std_logic;                                       -- export
			lda_vga_vs_export      : out std_logic;                                       -- export
			led_o_export           : out std_logic_vector(9 downto 0);                    -- export
			quad_hex0_export       : out std_logic_vector(6 downto 0);                    -- export
			quad_hex1_export       : out std_logic_vector(6 downto 0);                    -- export
			quad_hex2_export       : out std_logic_vector(6 downto 0);                    -- export
			quad_hex3_export       : out std_logic_vector(6 downto 0);                    -- export
			reset_reset_n          : in  std_logic                    := 'X';             -- reset_n
			sw_i_export            : in  std_logic_vector(9 downto 0) := (others => 'X')  -- export
		);
	end component processor;

	u0 : component processor
		port map (
			clk_clk                => CONNECTED_TO_clk_clk,                --             clk.clk
			lda_vga_b_export       => CONNECTED_TO_lda_vga_b_export,       --       lda_vga_b.export
			lda_vga_blank_n_export => CONNECTED_TO_lda_vga_blank_n_export, -- lda_vga_blank_n.export
			lda_vga_clk_export     => CONNECTED_TO_lda_vga_clk_export,     --     lda_vga_clk.export
			lda_vga_g_export       => CONNECTED_TO_lda_vga_g_export,       --       lda_vga_g.export
			lda_vga_hs_export      => CONNECTED_TO_lda_vga_hs_export,      --      lda_vga_hs.export
			lda_vga_r_export       => CONNECTED_TO_lda_vga_r_export,       --       lda_vga_r.export
			lda_vga_sync_n_export  => CONNECTED_TO_lda_vga_sync_n_export,  --  lda_vga_sync_n.export
			lda_vga_vs_export      => CONNECTED_TO_lda_vga_vs_export,      --      lda_vga_vs.export
			led_o_export           => CONNECTED_TO_led_o_export,           --           led_o.export
			quad_hex0_export       => CONNECTED_TO_quad_hex0_export,       --       quad_hex0.export
			quad_hex1_export       => CONNECTED_TO_quad_hex1_export,       --       quad_hex1.export
			quad_hex2_export       => CONNECTED_TO_quad_hex2_export,       --       quad_hex2.export
			quad_hex3_export       => CONNECTED_TO_quad_hex3_export,       --       quad_hex3.export
			reset_reset_n          => CONNECTED_TO_reset_reset_n,          --           reset.reset_n
			sw_i_export            => CONNECTED_TO_sw_i_export             --            sw_i.export
		);

