set term pngcairo enhanced size 2048,1536 font 'Arial,34' dashed
set output OUT

set nokey
set border linewidth 1.5

set xlabel 'Time [100 generations]'
set xrange [0:]

set style line 1 lt 1 lc rgb "blue" lw 4

set multiplot layout 2,1 rowsfirst
#1-1
set ylabel 'Mean distance [1000 km]'
plot IN using ($1/100):($2/1000) w l ls 1

#1-2
set ylabel '{/Symbol \326} Var [1000 km]'
plot IN using ($1/100):($3/1000) w l ls 1


unset multiplot
