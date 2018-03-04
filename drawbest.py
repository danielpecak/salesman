#!/usr/bin/env python
# -*- coding: utf-8 -*-
import sys
import myio
import cities
import genetics
from mapLib import drawMap

def simplify(seq):
    # https://www.peterbe.com/plog/uniqifiers-benchmark
    # uniqifying a list; order preserving
    checked = []
    for e in seq:
        if e not in checked:
            checked.append(e)
    return checked

continent = sys.argv[1].split('data/')[1].split('_')[0]
popNo = sys.argv[1].split('_P')[1].split('_X')[0]
popNo = int(float(popNo)*1000)
xmen = sys.argv[1].split('_X')[1].split('_stats.dat')[0]
xmen = float(xmen)/1000

fname = myio.lastSnapshot(continent, popNo, xmen)
population, bestpopulation, time0 = myio.loadSnapshot(fname,popNo)

bestpopulation = simplify(bestpopulation)
population = simplify(population)
countries = cities.loadCountries(continent)

# for i in countries:
#     print i
distance = cities.calcDistances(countries)

for i in xrange(3):
    print genetics.cycleLength(bestpopulation[i],distance)
    fname = sys.argv[2][:-4]+'_'+str(i+1)
    fname = fname.split('images/')[1]
    drawMap(bestpopulation[i],continent,countries,fname)
