# -*- coding: utf-8 -*-
# My modules
import genetics
import cities
# General modules
import sys
import random


# System parameters:
time   = 100   # number of generations
popNo  = 10**4 # population size
heurNo = 5     # number of heruristic solutions
xmen   = 0.001 # probabilty of mutation

# Load the CSV file with Countries and coordinates
countries = cities.loadCountries('SA') # South America

# Calculate the distance between countries
countryNo = len(countries)
distance = cities.calcDistances(countries)

### Set population & heuristics
population = genetics.growPopulation(popNo,countryNo)
heuristicPop = genetics.getHeuristicSolutions(distance,countryNo,heurNo)
print "Population: ", len(population)
print "Chromosome length: ", len(population[0])

### Fitness Based Selection
for t in range(time):
    pass
    # Calculate fitness
    # Sort population based on fitnesses
    nextgeneration = []
    for tt in range(popNo/2):
        pass
        # # Pick parents
        # p1 = genetics.rouletteWheelSelection(population)
        # p2 = genetics.rouletteWheelSelection(population)
        # # Breed chromosomes using Crossover
        # ch1, ch2 = genetics.CrossoverOX1(p1,p2)
        # # Apply Mutaton with some probability 'xmen'
        # x = random.random()
        # if x < xmen: ch1 = genetics.ScrambleMutation(ch1)
        # x = random.random()
        # if x < xmen: ch1 = genetics.InversionMutation(ch1)
        # x = random.random()
        # if x < xmen: ch2 = genetics.ScrambleMutation(ch2)
        # x = random.random()
        # if x < xmen: ch2 = genetics.InversionMutation(ch2)
        # nextgeneration.append(ch1,ch2)
