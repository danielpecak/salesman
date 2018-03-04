all: plots
STATS = $(patsubst data/%_stats.dat, images/STATS_%.png, $(shell ls  data/* | grep _stats.dat | grep -v \~))
BEST  = $(patsubst data/%_stats.dat, images/BEST_%_1.svg, $(shell ls  data/* | grep _stats.dat | grep -v \~))
# BEST  = $(patsubst snapshot/%.dat,   images/BEST_%.png,  $(shell ls  snapshot/* | grep .dat | grep -v \~))
plots: $(STATS) $(BEST)

images/STATS_%.png: data/%_stats.dat gnuplot/stats.plt
	gnuplot -e "IN='$<';OUT='$@'" gnuplot/stats.plt

images/BEST_%_1.svg: data/%_stats.dat drawbest.py
	python drawbest.py $< $@
