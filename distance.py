# -*- coding: utf-8 -*-
# My modules
import genetics
import cities
# General modules
import sys


# System parameters:
popNo = 10
heurNo = 5

# Load the CSV file with Countries and coordinates
countries = cities.loadCountries('SA') # South America

# Calculate the distance between countries
countryNo = len(countries)
countryNo = 6 # to make everything faster
print "Country number: ", countryNo

distance = cities.calcDistances(countries)
distance = [[distance[x][y] for x in range(countryNo)] for y in range(countryNo)] # to make everything faster

### Set population & heuristics
population = genetics.growPopulation(popNo,countryNo)
heuristicPop = genetics.getHeuristicSolutions(distance,countryNo,heurNo)

### Brute-force test
bruteList = genetics.bruteForcePopulation(countryNo)
print "MIN: ", min([genetics.fitness(i,distance) for i in bruteList])
print "MAX: ", max([genetics.fitness(i,distance) for i in bruteList])
