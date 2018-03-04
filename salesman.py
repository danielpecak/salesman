#!/usr/bin/env python
# -*- coding: utf-8 -*-
# My modules
import genetics
import cities
import mapLib
import myio
# General modules
import sys
import random
import matplotlib.pyplot as plt
import math
import copy

def mean(list):
    "Returns mean of the points in list."
    return sum(list)/len(list)

def variance(list):
    mean = sum(list)/len(list)
    s = [(x - mean)**2 for x in list]
    return sum(s)/len(s)


### System DEFAULT parameters:
time   = 10**3  # number of generations
popNo  = 10**3  # population size
heurNo = 5      # number of heruristic solutions
xmen   = 0.001  # probabilty of mutation
continent = 'SA'# South America (the least places)
dsave = 15*10**6 # save every ~30 minutes; 1 mln = 2 minutes (on my laptop)
if time < 10000:
    dt = time/10
else:
    dt = time/100
dsave = 4000

### System optional command line parameter:
for a in sys.argv:
    if a in ['--population','--pop','-population','-pop']:
        popNo = int(sys.argv[sys.argv.index(a)+1])
    if a in ['--probability','--prob','-probability','-prob']:
        xmen = float(sys.argv[sys.argv.index(a)+1])
    if a in ['--time','--t','-t']:
        time = int(sys.argv[sys.argv.index(a)+1])
    if a in ['--type']:
        allowed = ['AS','SA','NA','AO','EU','AF','ALL']
        continent = sys.argv[sys.argv.index(a)+1]
        if continent.strip() not in allowed:
            sys.exit("""Wrong parameter! \n --type can be one of {}""".format(allowed))
    if a in ['-n','--reset','--new']:
        myio.newStats(continent,popNo,xmen)
        myio.clearSnapshots(continent,popNo,xmen,prefix="TEST__")

# Load the CSV file with Countries and coordinates
countries = cities.loadCountries(continent)

# Calculate the distance between countries
countryNo = len(countries)
distance = cities.calcDistances(countries)

### Set population & heuristics
if myio.lastSnapshot(continent,popNo,xmen) != None:
    population, bestpopulation, time0 = myio.loadSnapshot(myio.lastSnapshot(continent,popNo,xmen),popNo)
else:
    population = genetics.growPopulation(popNo-countryNo,countryNo)
    heuristicPop = genetics.getHeuristicSolutions(distance,countryNo,countryNo)
    time0 = 0
    for i in heuristicPop:
        population.append(i)
    bestpopulation = copy.deepcopy(population)
meanCase = mean([genetics.cycleLength(p,distance) for p in population])

print "Population (random + heuristics): ", len(population)
print "Chromosome length: ", len(population[0])
print "Mean: ",int(meanCase)


### Fitness Based Selection
fitT = []
varT = []
for t in range(time0,time0+time):
    if t%dt==0:
        print "Generation #"+str(t).rjust(4)+" out of "+str(time+time0)+" ( prob:"+str(xmen).rjust(6)+", population:"+str(popNo).rjust(6)+")"
    # if t%dsave==0:
    #     myio.saveSnapshot(continent,popNo,xmen,t,population,bestpopulation)
    #     print "Saved"
    # Calculate fitness
    # meanCase = 2*mean([genetics.cycleLength(p,distance) for p in population])
    fitnesses = [genetics.fitness(i,distance,meanCase) for i in population]
    # Sort population based on fitnesses (sort the shit out)
    fitnesses,population=zip(*sorted(zip(fitnesses,population),reverse=False))
    population = list(population)
    nextgeneration = []
    for tt in range(popNo/2):
        # Pick parents
        p1 = genetics.rouletteWheelSelection(population,fitnesses)
        p2 = genetics.rouletteWheelSelection(population,fitnesses)
        # Breed chromosomes using Crossover
        # print tt
        # print len(population)
        # print p1
        # print p1
        ch1, ch2 = genetics.CrossoverOX1(p1,p2)
        # Apply Mutaton with some probability 'xmen'
        x = random.random()
        if x < xmen: ch1 = genetics.ScrambleMutation(ch1)
        x = random.random()
        if x < xmen: ch1 = genetics.InversionMutation(ch1)
        x = random.random()
        if x < xmen: ch1 = genetics.SwapMutaton(ch1)
        x = random.random()
        if x < xmen: ch2 = genetics.ScrambleMutation(ch2)
        x = random.random()
        if x < xmen: ch2 = genetics.InversionMutation(ch2)
        x = random.random()
        if x < xmen: ch2 = genetics.SwapMutaton(ch2)
        nextgeneration.append(ch1)
        nextgeneration.append(ch2)
    # TODO TO NIE JEST POSORTOWANE JAK NALEŻY
    bestpopulation = sorted(bestpopulation + population,reverse=False)[0:popNo]
    population = nextgeneration
    # Look at the average fitness
    totLength = [genetics.cycleLength(p,distance) for p in population]
    fitT.append(mean(totLength))
    varT.append(math.sqrt(variance(totLength)))
    # fname = myio.fnameSnapshot(continent,popNo,xmen,time)
    myio.saveStats(continent,popNo,xmen,t,fitT[-1],varT[-1])
    # f = open('output/'+fname+'_stats.dat','a')
    # f.write(" ".join(map(str,[t,fitT[-1],varT[-1]]))+"\n")
    # f.close()
    # TODO save histogram

myio.saveSnapshot(continent,popNo,xmen,t,population,bestpopulation,prefix='TEST__')

for p in population:
    print genetics.cycleLength(p,distance)

# ### Plot convergence
# plt.plot(range(1+time0,1+time+time0),[x/1000. for x in fitT],label="Mean")
# plt.plot(range(1+time0,1+time+time0),[x/1000. for x in varT],label="sigma")
# plt.ylabel('Path length [km]')
# minx = (meanCase-max(fitT))/1000-1
# maxx = (meanCase-min(fitT))/1000+1
# # TODO Save this data fitT
# # TODO For longer times save just every n-th (n=10 etc.) realization parametrs.
# plt.xlabel('Generation #')
# plt.legend()
#
# filename = myio.fnameSnapshot(continent,popNo,xmen,time)
# # filename = '{}time{:0.2f}_Pop{:0.2f}_prob{:0.2f}'.format(continent,math.log10(time),math.log10(popNo), math.log10(xmen))
# plt.savefig('images/{:s}.png'.format(filename))
# print 'Saved in images/{:s}.png'.format(filename)
# # for i in range(5):
# #     mapLib.drawMap(population[i],continent,countries,fname=filename[:-4]+'MAP{}'.format(i+1))
