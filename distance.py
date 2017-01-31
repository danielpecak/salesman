# -*- coding: utf-8 -*-
import math
import random
import csv

# Constants:
R = 6371. # mean radius of the Earth that minimalizes the fact that the Earth
          # is not spherical but elipsoidal

# Load the CSV file with Countries and coordinates
countries = []
with open('south-america.csv','rb') as file:
    reader = csv.reader(file,delimiter=';')
    for row in reader:
        # row=(0-Country; 1-Capital; 2-LatitudeDEG; 3-LongitudeDEG; 4-LatitudeRAD; 5-LongitudeRAD)
        if row[0] != 'Country':
            countries.append(row[0:2]+map(float,row[2:]))

# Calculate the distance between countries
countryNo = len(countries)-6
print "Country number: ", countryNo
distance = [[0. for x in range(countryNo)] for y in range(countryNo)]
k=1
for i in range(countryNo):
    for j in range(i+1,countryNo):
        deltaLong=abs(countries[i][5]-countries[j][5])
        fi1 = countries[i][4]
        fi2 = countries[j][4]
        dist = math.acos(math.sin(fi1)*math.sin(fi2) + math.cos(fi1)*math.cos(fi2)*math.cos(deltaLong))
        print k, countries[i][1], countries[j][1], dist*R
        # distance[i][j] = k
        k+=1


# Set population
popNo = 10
population = []
for i in range(popNo):
    basicPerm = range(countryNo)
    random.shuffle(basicPerm)
    population.append(basicPerm)
    # print population[-1]


# Set heuristic individuals
# Fitness function
# Choose parents
# Davis' Crossover (O1)
