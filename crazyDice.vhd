library IEEE;
use IEEE.numeric_bit.all;

entity crazyDice is
 port (
 d1, d2, d3: in bit_vector(2 downto 0);
 nullifier: in bit_vector(1 downto 0);
 SumAll: out bit_vector(4 downto 0);
 SumEnul: out bit_vector(4 downto 0);
 Max: out bit_vector(2 downto 0);
 ThreeEq, TwoEq, AllDiff: out bit;
 AnySix: out bit);
end entity crazyDice;

architecture Dice of crazyDice is
    signal d1_expanded, d2_expanded, d3_expanded, max_value: bit_vector(4 downto 0);
    signal d1_nullfier, d2_nullfier, d3_nullfier: bit_vector(4 downto 0);
begin
    d1_expanded <= "00" & d1;
    d2_expanded <= "00" & d2;
    d3_expanded <= "00" & d3;
    SumAll <= bit_vector(unsigned(d1_expanded) + unsigned(d2_expanded) + unsigned(d3_expanded));
    d1_nullfier <= "00000" when nullifier = "01" else d1_expanded;
    d2_nullfier <= "00000" when nullifier = "10" else d2_expanded;
    d3_nullfier <= "00000" when nullifier = "11" else d3_expanded;
    
    SumEnul <= bit_vector(unsigned(d1_nullfier) + unsigned(d2_nullfier) + unsigned(d3_nullfier));
    
    max_value <= d1_nullfier when d1_nullfier >= d3_nullfier and d1_nullfier >= d2_nullfier else
                 d2_nullfier when d2_nullfier >= d3_nullfier and d2_nullfier >= d1 else
                 d3_nullfier;

    Max <= max_value(2 downto 0);

    ThreeEq <= '1' when d1_nullfier = d2_nullfier and d1_nullfier = d3_nullfier else '0';

    TwoEq <= '1' when (d1_nullfier = d2_nullfier and d1_nullfier /= d3_nullfier) or (d1_nullfier = d3_nullfier and d1_nullfier /= d2_nullfier) or (d2_nullfier = d3_nullfier and d2_nullfier /= d1_nullfier) else '0';

    AllDiff <= '1' when d1_nullfier /= d2_nullfier and d1_nullfier /= d3_nullfier and d2_nullfier /= d3_nullfier else '0';
    
    AnySix <= '1' when d1_nullfier = "00110" or d2_nullfier = "00110" or d3_nullfier = "00110" else
               '0';

end architecture Dice; 