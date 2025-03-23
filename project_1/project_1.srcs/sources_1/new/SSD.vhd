library ieee;
  use ieee.std_logic_1164.all;
  use ieee.std_logic_arith.all;
  use ieee.std_logic_unsigned.all;

entity SSD is
  port (
    clk : in std_logic;
    digits  : in  std_logic_vector(15 downto 0);
    an  : out std_logic_vector(3  downto 0);
    cat : out std_logic_vector(6  downto 0)
  );
end entity SSD;

architecture behavioral of SSD is  

signal s_cnt_out : std_logic_vector(15 downto 0) := (others => '0');
signal s_top_mux : std_logic_vector(3 downto 0) := (others => '0');

begin

    process(clk)
        begin
            if rising_edge(clk) then
                s_cnt_out <= s_cnt_out + 1;
            end if;
    end process;

  process (s_cnt_out(15 downto 13))
  begin
    case s_cnt_out(15 downto 14) is
      when "00"  => an <= b"1110";
      when "01"  => an <= b"1101";
      when "10"  => an <= b"1011";
      when "11"  => an <= b"0111";
    end case;
  end process;

  process (s_cnt_out(15 downto 14))
  begin
    case s_cnt_out(15 downto 14) is
      when "00"  => s_top_mux <= digits(3 downto 0);
      when "01"  => s_top_mux <= digits(7 downto 4);
      when "10"  => s_top_mux <= digits(11 downto 8);
      when "11"  => s_top_mux <= digits(15 downto 12);
    end case;
  end process;

with s_top_mux select
    cat <= "1111001" when "0001",   --1
           "0100100" when "0010",   --2
           "0110000" when "0011",   --3
           "0011001" when "0100",   --4
           "0010010" when "0101",   --5
           "0000010" when "0110",   --6
           "1111000" when "0111",   --7
           "0000000" when "1000",   --8
           "0010000" when "1001",   --9
           "0001000" when "1010",   --A
           "0000011" when "1011",   --b
           "1000110" when "1100",   --C
           "0100001" when "1101",   --d
           "0000110" when "1110",   --E
           "0001110" when "1111",   --F
           "1000000" when others;   --0

end architecture behavioral; 