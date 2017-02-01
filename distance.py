# -*- coding: utf-8 -*-
import math
import random
import csv
import sys
import copy
import itertools

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
population = []
for i in range(popNo):
    basicPerm = range(countryNo)
    random.shuffle(basicPerm)
    population.append(basicPerm)
    # print population[-1]


### Set heuristic individuals
heuristicPop = []
for ii in range(heurNo):
    # Copy distance list
    tempdist = copy.deepcopy(distance)
    # Pick one guy
    # print ii,"################## Runda 1"
    basicPerm = range(countryNo)
    heur = []
    # print basicPerm
    luckyGuy = random.sample(basicPerm,1)[0]
    # print luckyGuy
    basicPerm.remove(luckyGuy)
    heur.append(luckyGuy)
    # print basicPerm
    # Get closest neighbour
    for i in range(countryNo-1):
        # print ii,"################## Runda", i+2
        # print tempdist[luckyGuy][:]
        minval = min(tempdist[luckyGuy][:])
        # print minval
        oldGuy = luckyGuy
        luckyGuy = tempdist[luckyGuy].index(minval)
        # print luckyGuy
        basicPerm.remove(luckyGuy)
        heur.append(luckyGuy)
        # print basicPerm, heur
        for jj in range(countryNo):
            tempdist[oldGuy][jj] = inf
            tempdist[jj][oldGuy] = inf
    heuristicPop.append(heur)


### Fitness function
def fitness(ch):
    "Function calculates the fitness of a chromosome 'ch'"
    total = 0.
    # print ch
    for c in range(countryNo-1):
        total += distance[ch[c]][ch[c+1]]
        # print ch[c],ch[c+1], distance[ch[c]][ch[c+1]]
    return 10000./total

### Brute-force test
bruteList = list(itertools.permutations(range(countryNo), countryNo))
# for i in bruteList:
    # print i, fitness(i)
print "MIN: ", min([fitness(i) for i in bruteList])
print "MAX: ", max([fitness(i) for i in bruteList])

### Choose parents
def rouletteWheelSelection(population):
    "Chooses parent from the population: calculating the fitness, sorting population by the fitness and weighting by the fitness it randomly chooses a parent."
    # Sort shit out
    a=zip(*sorted(zip(fitnesses,population),reverse=True))[1]
    fitnesses.sort(reverse=True)
    total = sum(fitnesses)
    lotteryTicket = random.uniform(0,total)
    pick = 0.
    for i in range(len(population)):
        pick += fitnesses[i]
        if pick > lotteryTicket:
            return population[i]

# ### CHECK THE WHEEL
# N=1000000
# stat = [0 for i in range(len(population))]
# for i in range(N):
#     item = rouletteWheelSelection(population)
#     # print i, item, population.index(item), len(population)
#     stat[population.index(item)] += 1
#
# for i in range(len(population)):
#     print i, 100*fitnesses[i]/sum(fitnesses), 100.*stat[i]/N

### Davis' Crossover (O1)
