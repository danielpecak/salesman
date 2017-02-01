# -*- coding: utf-8 -*-
import random
import itertools
import copy

###################################
######      CONSTANTS        ######
###################################
inf = 10000000.

###################################
######      GENOM SCALE      ######
###################################
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

### Davis' Order Crossover (O1)
def OX1(p1,p2):
    countryNo=len(p1)
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

###################################
######    INDIVIDUAL SCALE    ######
###################################
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

### Fitness function
def fitness(ch,distance):
    "Function calculates the fitness of a chromosome 'ch'"
    countryNo=len(ch)
    total = 0.
    for c in range(countryNo-1):
        total += distance[ch[c]][ch[c+1]]
    return 10000./total

###################################
######   POPULATION SCALE    ######
###################################
def bruteForcePopulation(N):
    "Generetes a list of all permutations of the length N. It's factorial, so be carefull!"
    return list(itertools.permutations(range(N), N))

def growPopulation(N,M):
    "Grow population of N individuals, everyone with M genes. "
    population = []
    for i in range(N):
        basicPerm = range(M)
        random.shuffle(basicPerm)
        population.append(basicPerm)
    return population

def getHeuristicSolutions(distance,countryNo,heurNo):
    """Get HEURNO number of heuristicly found chromosome (COUNTRYNO long each)
    which is usually moderately good. It uses table of distances DISTANCE."""
    if heurNo>countryNo:
        print "WARNING: There might be no sense that heurNo > countryNo. There would be repetition"
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
