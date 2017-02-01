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


### Fitness function
def fitness(ch):
    "Function calculates the fitness of a chromosome 'ch'"
    total = 0.
    for c in range(countryNo-1):
        total += distance[ch[c]][ch[c+1]]
    return 10000./total

### Brute-force test
bruteList = list(itertools.permutations(range(countryNo), countryNo))
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

### Davis' Order Crossover (O1)
def OX1(p1,p2):
    "Applies so called Davis' Order Crossover OX1 for permutation based crossovers."
    [start,end] = sorted(random.sample(range(countryNo),2))
    ch1 = [-1 for i in range(len(p1))]
    ch2 = [-1 for i in range(len(p1))]
    for i in range(countryNo):
        if i>=start and i<=end:
            ch1[i]=p1[i]
            ch2[i]=p2[i]
    for i in range(countryNo):
        if p2[i] not in ch1:
            ch1[ch1.index(-1)]=p2[i]
    for i in range(countryNo):
        if p1[i] not in ch2:
            ch2[ch2.index(-1)]=p1[i]
    return ch1, ch2

### MUTATION
def ScrambleMutation(item2):
    "Mutation that shuffles randomly the genes."
    item=copy.deepcopy(item2)
    [start,end] = sorted(random.sample(range(countryNo+1),2))
    print start, end
    shuffle_slice(item,start,end)
    return item

def InversionMutation(item2):
    item=copy.deepcopy(item2)
    "Mutation that inverses the gene sequence."
    [start,end] = sorted(random.sample(range(countryNo+1),2))
    print start, end
    item[start:end] = reversed(item[start:end])
    return item

def shuffle_slice(a, start, stop):
    i = start
    while (i < stop-1):
        idx = random.randrange(i, stop)
        a[i], a[idx] = a[idx], a[i]
        i += 1

