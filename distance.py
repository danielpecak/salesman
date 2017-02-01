# -*- coding: utf-8 -*-
# My modules
import genetics
# General modules
import sys
import csv
import math
import random
import copy

# Constants:
R = 6371. # mean radius of the Earth that minimalizes the fact that the Earth
          # is not spherical but elipsoidal
inf = 10000000.

# System parameters:
popNo = 10
heurNo = 10
countryNormalizer = 6

# Load the CSV file with Countries and coordinates
countries = []
with open('south-america.csv','rb') as file:
    reader = csv.reader(file,delimiter=';')
    for row in reader:
# row=(0-Country; 1-Capital; 2-LatitudeDEG; 3-LongitudeDEG; 4-LatitudeRAD; 5-LongitudeRAD)
        if row[0] != 'Country':
            countries.append(row[0:2]+map(float,row[2:]))

# Calculate the distance between countries
countryNo = len(countries)-countryNormalizer
print "Country number: ", countryNo
distance = [[inf for x in range(countryNo)] for y in range(countryNo)]
k=1
for i in range(countryNo):
    for j in range(i+1,countryNo):
        deltaLong=abs(countries[i][5]-countries[j][5])
        fi1 = countries[i][4]
        fi2 = countries[j][4]
        dist = math.acos(math.sin(fi1)*math.sin(fi2) + math.cos(fi1)*math.cos(fi2)*math.cos(deltaLong))
        # print k, countries[i][1], countries[j][1], dist*R
        distance[i][j] = dist*R
        distance[j][i] = dist*R
        k+=1


### Set population
population = genetics.growPopulation(popNo,countryNo)


### Set heuristic individuals
heuristicPop = []
for ii in range(heurNo):
    # Copy distance list
    tempdist = copy.deepcopy(distance)
    # Pick one guy
    basicPerm = range(countryNo)
    heur = []
    luckyGuy = random.sample(basicPerm,1)[0]
    basicPerm.remove(luckyGuy)
    heur.append(luckyGuy)
    # Get closest neighbour
    for i in range(countryNo-1):
        minval = min(tempdist[luckyGuy][:])
        oldGuy = luckyGuy
        luckyGuy = tempdist[luckyGuy].index(minval)
        basicPerm.remove(luckyGuy)
        heur.append(luckyGuy)
        for jj in range(countryNo):
            tempdist[oldGuy][jj] = inf
            tempdist[jj][oldGuy] = inf
    heuristicPop.append(heur)


### Brute-force test
bruteList = genetics.bruteForcePopulation(countryNo)
print "MIN: ", min([genetics.fitness(i,distance) for i in bruteList])
print "MAX: ", max([genetics.fitness(i,distance) for i in bruteList])
