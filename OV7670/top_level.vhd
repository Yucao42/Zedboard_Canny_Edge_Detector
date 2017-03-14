----------------------------------------------------------------------------------
-- Engineer: Yu Cao
-- 
-- Module Name: top_level - Behavioral 
-- Description: Top level module of the Zedboard OV7670 Canny Detector design
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top_level is
    Port ( clk100          : in  STD_LOGIC;
           btnl            : in  STD_LOGIC;
           btnc            : in  STD_LOGIC;
           btnr            : in  STD_LOGIC;
           config_finished : out STD_LOGIC;
           
           vga_hsync : out  STD_LOGIC;
           vga_vsync : out  STD_LOGIC;
           vga_r     : out  STD_LOGIC_vector(3 downto 0);
           vga_g     : out  STD_LOGIC_vector(3 downto 0);
           vga_b     : out  STD_LOGIC_vector(3 downto 0);
           
           ov7670_pclk  : in  STD_LOGIC;
           ov7670_xclk  : out STD_LOGIC;
           ov7670_vsync : in  STD_LOGIC;
           ov7670_href  : in  STD_LOGIC;
           ov7670_data  : in  STD_LOGIC_vector(7 downto 0);
           ov7670_sioc  : out STD_LOGIC;
           ov7670_siod  : inout STD_LOGIC;
           ov7670_pwdn  : out STD_LOGIC;
           ov7670_reset : out STD_LOGIC
           );
end top_level;

architecture Behavioral of top_level is

    component ila_0
    port( clk: in std_logic;
        probe0: std_logic_vector (0 downto 0);
        probe1: std_logic_vector (0 downto 0));
    end component;
    
    
	COMPONENT VGA
	PORT(
		CLK25 : IN std_logic;    
      rez_160x120 : IN std_logic;
      rez_320x240 : IN std_logic;
		Hsync : OUT std_logic;   --horizonal
		Vsync : OUT std_logic;   --vertical
		Nblank : OUT std_logic;      
		clkout : OUT std_logic;
		activeArea : OUT std_logic;
		Nsync : OUT std_logic
		);
	END COMPONENT;

	COMPONENT ov7670_controller
	PORT(
		clk : IN std_logic;
		resend : IN std_logic;    
		siod : INOUT std_logic;      
		config_finished : OUT std_logic;
		sioc : OUT std_logic;
		reset : OUT std_logic;
		pwdn : OUT std_logic;
		xclk : OUT std_logic
		);
	END COMPONENT;

	COMPONENT debounce
	PORT(
		clk : IN std_logic;
		i : IN std_logic;          
		o : OUT std_logic
		);
	END COMPONENT;

	COMPONENT frame_buffer
	PORT(
		data : IN std_logic_vector(11 downto 0);
		rdaddress : IN std_logic_vector(18 downto 0);
		rdclock : IN std_logic;
		wraddress : IN std_logic_vector(18 downto 0);
		wrclock : IN std_logic;
		wren : IN std_logic;          
		q : OUT std_logic_vector(11 downto 0)
		);
	END COMPONENT;

	COMPONENT ov7670_capture
	PORT(
      rez_160x120 : IN std_logic;
      rez_320x240 : IN std_logic;
		pclk : IN std_logic;
		vsync : IN std_logic;
		href : IN std_logic;
		d : IN std_logic_vector(7 downto 0);          
		addr : OUT std_logic_vector(18 downto 0);
		dout : OUT std_logic_vector(11 downto 0);
		we : OUT std_logic
		);
	END COMPONENT;

	COMPONENT RGB
	PORT(
		Din : IN std_logic_vector(11 downto 0);
		Nblank : IN std_logic;          
		R : OUT std_logic_vector(3 downto 0);
		G : OUT std_logic_vector(3 downto 0);
		B : OUT std_logic_vector(3 downto 0)
		);
	END COMPONENT;

	component vga_pll_zedboard
	port (
		CLK100       : in  std_logic;
		CLK50_camera : out std_logic;
		CLK25_vga    : out std_logic);
	end component;
	
	component convert is
        Port ( i : in STD_LOGIC;
               o : out STD_LOGIC_VECTOR (0 downto 0));
    end component;
    
	COMPONENT vga_pll
	PORT(
		inclk0 : IN std_logic;          
		c0 : OUT std_logic;
		c1 : OUT std_logic
		);
	END COMPONENT;

	COMPONENT Address_Generator
	PORT(
		CLK25       : IN  std_logic;
      rez_160x120 : IN std_logic;
      rez_320x240 : IN std_logic;
		enable      : IN  std_logic;       
      vsync       : in  STD_LOGIC;
		address     : OUT std_logic_vector(18 downto 0)
		);
	END COMPONENT;

    component windows is
        Port ( 
          clk : IN STD_LOGIC;
          href : IN STD_LOGIC;
    vsync : IN STD_LOGIC;-- frame synchronous 
    addrin : in STD_LOGIC_VECTOR(18 DOWNTO 0); 
    addrout :out STD_LOGIC_VECTOR(18 DOWNTO 0);
    din : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
    en : IN STD_LOGIC;
    wr_data : out STD_LOGIC;
    dout : OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
    rows : OUT STD_LOGIC_VECTOR(9 DOWNTO 0)
    );
    end component;
    
    component NMS_module is
        Port ( 
          clk : IN STD_LOGIC;
          href : IN STD_LOGIC;
            vsync : IN STD_LOGIC;-- frame synchronous 
            addrin : in STD_LOGIC_VECTOR(18 DOWNTO 0); 
            addrout :out STD_LOGIC_VECTOR(18 DOWNTO 0);
            din : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
            en : IN STD_LOGIC;
            wr_data : out STD_LOGIC;
            dout : OUT STD_LOGIC_VECTOR(11 DOWNTO 0)
          
    );
    end component;

   component Hysteresis is
    Port ( 
      clk : IN STD_LOGIC;
      href : IN STD_LOGIC;
        vsync : IN STD_LOGIC;-- frame synchronous 
        addrin : in STD_LOGIC_VECTOR(18 DOWNTO 0); 
        addrout :out STD_LOGIC_VECTOR(18 DOWNTO 0);
        din : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
        en : IN STD_LOGIC;
        wr_data : out STD_LOGIC;
        dout : OUT STD_LOGIC_VECTOR(11 DOWNTO 0)
      
    );
    end component;

   signal clk_camera : std_logic;
   signal clk_vga    : std_logic;
   signal wren,wr_data,wr_en1,wr_en2       : std_logic;
   signal resend     : std_logic;
   signal nBlank     : std_logic;
   signal vSync      : std_logic;
   signal nSync      : std_logic;
   
   signal wraddress,cd_address2,cd_address1,cd_address  : std_logic_vector(18 downto 0);
   signal wrdata     : std_logic_vector(11 downto 0);
   
   signal rdaddress  : std_logic_vector(18 downto 0);
   signal wren1,clk1     : std_logic_vector(0 downto 0);
   signal rddata,dataout,dataout1,dataout2     : std_logic_vector(11 downto 0);
 --  signal red,green,blue : std_logic_vector(7 downto 0);
   signal activeArea : std_logic;
   
   signal rez_160x120 : std_logic;
   signal rez_320x240 : std_logic;
   
--      signal probe0: std_logic_vector(18 downto 0);
--   signal probe1: std_logic_vector(18 downto 0);
begin
--   vga_r <= red(7 downto 4);
--   vga_g <= green(7 downto 4);
--   vga_b <= blue(7 downto 4);
   --wren1(0)<=wren;
c1: convert port map (wren,wren1);
c2: convert port map (ov7670_pclk,clk1);
   --clk1(0)<=activeArea;
   rez_160x120 <= btnl;
   rez_320x240 <= btnr;
  
-- For the Nexys2  
--	Inst_vga_pll: vga_pll PORT MAP(
--		inclk0 => clk50,
--		c0 => clk_camera,
--		c1 => clk_vga
--	);
inst_ila : ila_0 port map(clk_camera,clk1,wren1);

inst_vga_pll : vga_pll_zedboard
  port map
   ( CLK100 => CLK100,
     CLK50_camera => CLK_camera,
     CLK25_vga => CLK_vga);

   vga_vsync <= vsync;
   
	Inst_VGA: VGA PORT MAP(
		CLK25      => clk_vga,
      rez_160x120 => rez_160x120,
      rez_320x240 => rez_320x240,
		clkout     => open,
		Hsync      => vga_hsync,
		Vsync      => vsync,
		Nblank     => nBlank,
		Nsync      => nsync,
      activeArea => activeArea  --Nblank
	);

	Inst_debounce: debounce PORT MAP(
		clk => clk_vga,
		i   => btnc,
		o   => resend
	);

	Inst_ov7670_controller: ov7670_controller PORT MAP(
		clk             => clk_camera,
		resend          => resend,
		config_finished => config_finished,
		sioc            => ov7670_sioc,
		siod            => ov7670_siod,
		reset           => ov7670_reset,
		pwdn            => ov7670_pwdn,
		xclk            => ov7670_xclk
	);

	Inst_frame_buffer: frame_buffer PORT MAP(
		rdaddress => rdaddress,
		rdclock   => clk_vga,
		q         => rddata,
      
		wrclock   => ov7670_pclk,
		wraddress => cd_address,
		data      => dataout,
		wren      => wr_data
	);
   
	Inst_ov7670_capture: ov7670_capture PORT MAP(
		pclk  => ov7670_pclk,
      rez_160x120 => rez_160x120,
      rez_320x240 => rez_320x240,
		vsync => ov7670_vsync,    --video synchronization
		href  => ov7670_href,     --horizonatl synchronization
		d     => ov7670_data,
		addr  => wraddress,
		dout  => wrdata,
		we    => wren
	);

--    inst: windows port map(ov7670_pclk,ov7670_href,ov7670_vsync,wraddress,cd_address,wrdata,wren,wr_data,dataout,open);

    inst: windows port map(ov7670_pclk,ov7670_href,ov7670_vsync,wraddress,cd_address1,wrdata,wren,wr_en1,dataout1,open);
    inst1: NMS_module port map(ov7670_pclk,ov7670_href,ov7670_vsync,cd_address1,cd_address2,dataout1,wr_en1,wr_en2,dataout2);
    inst2: Hysteresis port map(ov7670_pclk,ov7670_href,ov7670_vsync,cd_address2,cd_address,dataout2,wr_en2,wr_data,dataout);
	Inst_RGB: RGB PORT MAP(
		Din => rddata,
		Nblank => activeArea,
		R => VGA_R,
		G => VGA_G,
		B => VGA_B
	);

	Inst_Address_Generator: Address_Generator PORT MAP(
		CLK25 => clk_vga,
      rez_160x120 => rez_160x120,
      rez_320x240 => rez_320x240,
		enable => activeArea,
      vsync  => vsync,
		address => rdaddress
	);

end Behavioral;

