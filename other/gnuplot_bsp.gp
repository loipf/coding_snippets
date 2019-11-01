set term png
set output "gobi_2.5.1.png"
set title "Coverage Verteilung "
set yrange [0.0:1.1]
set xrange [0:60.0]
set xlabel "Anzahl Basen"
set ylabel "Anteil Basen mit Coverage >= X"
plot "outputT.dat" using 1:3 with line lw 3 title "NA12877", "outputT.dat" using 1:4 with line lw 3 title "NA12878", "outputT.dat" using 1:2 with line lw 3 title "NA12882"

