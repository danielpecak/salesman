# -*- coding: utf-8 -*-
# My modules
import genetics
import cities
# General modules
import sys
import random
import matplotlib.pyplot as plt
import math

### System DEFAULT parameters:
time   = 10**3  # number of generations
popNo  = 10**3  # population size
heurNo = 5      # number of heruristic solutions
xmen   = 0.001  # probabilty of mutation
continent = 'SA'# South America

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


# Load the CSV file with Countries and coordinates
countries = cities.loadCountries(continent) # South America

# Calculate the distance between countries
countryNo = len(countries)
distance = cities.calcDistances(countries)

### Set population & heuristics
population = genetics.growPopulation(popNo,countryNo)
meanCase = mean([genetics.cycleLength(p,distance) for p in population])
heuristicPop = genetics.getHeuristicSolutions(distance,countryNo,countryNo)
for i in heuristicPop:
    population.append(i)


print "Population: ", len(population)
print "Chromosome length: ", len(population[0])

### Fitness Based Selection
fitT = []
for t in range(time):
    if t%(time/10)==0:
        print "Generation #"+str(t).rjust(4)+" out of "+str(time)+", prob:"+str(xmen).rjust(6)+", population:"+str(popNo).rjust(6)
    # Calculate fitness
    fitnesses = [genetics.fitness(i,distance,meanCase) for i in population]
    # Sort population based on fitnesses (sort the shit out)
    fitnesses,population=zip(*sorted(zip(fitnesses,population),reverse=True))
    nextgeneration = []
    for tt in range(popNo/2):
        # Pick parents
        p1 = genetics.rouletteWheelSelection(population,fitnesses)
        p2 = genetics.rouletteWheelSelection(population,fitnesses)
        # Breed chromosomes using Crossover
        ch1, ch2 = genetics.CrossoverOX1(p1,p2)
        # Apply Mutaton with some probability 'xmen'
        x = random.random()
        if x < xmen: ch1 = genetics.ScrambleMutation(ch1)
        x = random.random()
        if x < xmen: ch1 = genetics.InversionMutation(ch1)
        x = random.random()
        if x < xmen: ch2 = genetics.ScrambleMutation(ch2)
        x = random.random()
        if x < xmen: ch2 = genetics.InversionMutation(ch2)
        nextgeneration.append(ch1)
        nextgeneration.append(ch2)
    population = nextgeneration
    # Look at the average fitness
    fitT.append(sum(fitnesses)/len(fitnesses))
    # TODO calculate also variance
    # TODO save histogram

### Plot convergence
plt.plot(range(1,1+time),[(meanCase-x)/1000 for x in fitT])
plt.ylabel('Path length [km]')
minx = (meanCase-max(fitT))/1000-1
maxx = (meanCase-min(fitT))/1000+1
# plt.ylim([minx,maxx])
# plt.plot(range(1,1+time),fitT)
# plt.ylabel('Fitness')
# TODO Save this data fitT
# TODO For longer times save just every n-th (n=10 etc.) realization parametrs.
plt.xlabel('Generation #')
filename = '{}time{:0.2f}_Pop{:0.2f}_prob{:0.2f}'.format(continent,math.log10(time),math.log10(popNo), math.log10(xmen))
plt.savefig('images/{:s}.png'.format(filename))
print 'Saved in images/{:s}.png'.format(filename)
