library ieee;
  use ieee.std_logic_1164.all;
  use ieee.std_logic_arith.all;
  use ieee.std_logic_unsigned.all;

entity mono is
  port (
    clk : in  std_logic;
    btn : in  std_logic_vector(4  downto 0);
    enable : out std_logic_vector(4 downto 0)
  );
end entity mono;

architecture behavioral of mono is
  signal s_en_in  : std_logic                      := '0';
  signal s_cnt_out : std_logic_vector(15 downto 0) := (others => '0');
  signal s_dff1_out : std_logic_vector(4 downto 0) := (others => '0');
  signal s_dff2_out : std_logic_vector(4 downto 0)  := (others => '0');
  signal s_dff3_out : std_logic_vector(4 downto 0) := (others => '0');
begin

process(clk)
    begin
        if rising_edge(clk) then
            s_cnt_out <= s_cnt_out + 1;
        end if;
end process;

s_en_in <= '1' when s_cnt_out = x"000F" else '0';

process(clk)
    begin
        if rising_edge(clk) then
            if s_en_in = '1' then
                s_dff1_out <= btn;
            end if;
        end if;
end process;

process(clk)
    begin
        if rising_edge(clk) then
            s_dff2_out <= s_dff1_out;
        end if;
end process;

process(clk)
    begin
        if rising_edge(clk) then
            s_dff3_out <= s_dff2_out;
        end if;
end process;

enable <= not(s_dff3_out) and s_dff2_out;

end behavioral; 