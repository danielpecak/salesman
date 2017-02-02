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
time   = 1000  # number of generations
popNo  = 10**3 # population size
heurNo = 5     # number of heruristic solutions
xmen   = 0.001 # probabilty of mutation

### System optional command line parameter:
for a in sys.argv:
    if a in ['--population','--pop','-population','-pop']:
        popNo = int(sys.argv[sys.argv.index(a)+1])
    if a in ['--probability','--prob','-probability','-prob']:
        xmen = float(sys.argv[sys.argv.index(a)+1])

# Load the CSV file with Countries and coordinates
countries = cities.loadCountries('SA') # South America

# Calculate the distance between countries
countryNo = len(countries)
distance = cities.calcDistances(countries)

### Set population & heuristics
population = genetics.growPopulation(popNo,countryNo)
heuristicPop = genetics.getHeuristicSolutions(distance,countryNo,countryNo)
for i in heuristicPop:
    population.append(i)


print "Population: ", len(population)
print "Chromosome length: ", len(population[0])

### Fitness Based Selection
fitT = []
for t in range(time):
    print "Generation #"+str(t)
    # Calculate fitness
    fitnesses = [genetics.fitness(i,distance) for i in population]
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

### Plot convergence
plt.plot(range(1,1+time),fitT)
plt.ylabel('Fitness')
plt.xlabel('Generation #')
filename = 'time_Pop{:0.2f}_prob{:0.2f}'.format(math.log10(popNo), math.log10(xmen))
plt.savefig('images/{:s}.png'.format(filename))
