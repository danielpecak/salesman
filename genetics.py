#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""This module contains the meat of genetic algorithms."""

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
def SwapMutaton(item):
    """Mutation that swaps two random genes."""
    countryNo = len(item)
    [start,end] = sorted(random.sample(range(1,countryNo),2))
    temp = item[start]
    item[start] = item[end]
    item[end]   = temp
    return item
    # TODO CHECK !!

def ScrambleMutation(item):
    """Mutation that shuffles randomly the genes."""
    item=copy.deepcopy(item)
    countryNo = len(item)
    [start,end] = sorted(random.sample(range(1,countryNo+1),2))
    shuffle_slice(item,start,end)
    return item

def InversionMutation(item):
    """Mutation that inverses the gene sequence."""
    item=copy.deepcopy(item)
    countryNo = len(item)
    [start,end] = sorted(random.sample(range(1,countryNo+1),2))
    item[start:end] = reversed(item[start:end])
    return item

def shuffle_slice(a, start, stop):
    """Shuffling a region in table 'a' between 'start' and 'stop'. """
    i = start
    while (i < stop-1):
        idx = random.randrange(i, stop)
        a[i], a[idx] = a[idx], a[i]
        i += 1

### Davis' Order Crossover (O1)
def CrossoverOX1(p1,p2):
    """Applies so-called Davis' Order Crossover OX1 for permutation based crossovers."""
    countryNo=len(p1)
    [start,end] = sorted(random.sample(range(1,countryNo),2))
    ch1 = [0]+[-1 for i in range(1,len(p1))]
    ch2 = [0]+[-1 for i in range(1,len(p1))]
    for i in range(1,countryNo):
        if i>=start and i<=end:
            ch1[i]=p1[i]
            ch2[i]=p2[i]
    for i in range(1,countryNo):
        if p2[i] not in ch1:
            ch1[ch1.index(-1)]=p2[i]
    for i in range(1,countryNo):
        if p1[i] not in ch2:
            ch2[ch2.index(-1)]=p1[i]
    return ch1, ch2

###################################
######    INDIVIDUAL SCALE    ######
###################################
### Choose parents
def rouletteWheelSelection(population,fitnesses):
    """Chooses parent from the population: calculating the fitness, sorting population by the fitness and weighting by the fitness it randomly chooses a parent."""
    # TODO olej, gdy ujemne
    total = sum(fitnesses)
    lotteryTicket = random.uniform(0,total)
    pick = 0.
    for i in range(len(population)):
        pick += fitnesses[i]
        if pick > lotteryTicket:
            return population[i]

### Fitness function
def fitness(ch,distance,shift):
    """Function calculates the fitness of a chromosome 'ch'"""
    countryNo=len(ch)
    total = 0.
    for c in range(countryNo):
        total += distance[ch[c]][ch[(c+1)%countryNo]]
    if shift - total < 0:
        return 0
    else:
        return shift - total

def cycleLength(ch,distance):
    """Function calculates the total length of the path given by a  chromosome 'ch'."""
    countryNo=len(ch)
    total = 0.
    for c in range(countryNo):
        total += distance[ch[c]][ch[(c+1)%countryNo]]
    return total

###################################
######   POPULATION SCALE    ######
###################################
def bruteForcePopulation(N):
    """Generetes a list of all permutations of the length N. It's factorial complexity, so be carefull!"""
    return list(itertools.permutations(range(N), N))

def growPopulation(P,G):
    """Grow population of P individuals, everyone with G genes. """
    population = []
    for i in range(P):
        basicPerm = range(1,G)
        random.shuffle(basicPerm)
        population.append([0]+basicPerm)
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
        ind = heur.index(0)
        heur = [heur[(it+ind)%countryNo] for it in range(countryNo)]
        heuristicPop.append(heur)
    return heuristicPop
