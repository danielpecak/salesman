# -*- coding: utf-8 -*-
import csv
import math
inf = 10000000.

###################################
######        CITIES         ######
###################################

def loadCountries(continent):
    """Load the list of countres from a file which has the structure:
row=(0-Country; 1-Capital; 2-LatitudeDEG; 3-LongitudeDEG; 4-LatitudeRAD; 5-LongitudeRAD)."""
    code = {'SA':'south-america.csv','NA':'north-america.csv'}
    fname = code[continent]
    countries = []
    with open(fname,'rb') as file:
        reader = csv.reader(file,delimiter=';')
        for row in reader:
            if row[0] != 'Country':
                countries.append(row[0:2]+map(float,row[2:]))
    return countries

def calcDistances(countries):
    """Calculates distances between all posible cities. We deal with a problem of MINIMAL path, so we set the distance between city with itself as infinity (or very large). To calculate the distance from lattitude and longitude, we assume that the Earth is a sphere (not elipsoid). Then, we use the cosine rules for spherical trigonometry: https://en.wikipedia.org/wiki/Spherical_trigonometry#Cosine_rules_and_sine_rules
    The angular distance dS between two points of lattitudes fi1 and fi2 and longitudes  difference deltaLong is:
    dS = arccos(sin(f1)sin(f2)+cos(fi1)cos(fi2)cos(deltaLong)). Then, the final distance between points is d=R*dS, where R is mean radius of the earth."""
    R = 6371. # mean radius of the Earth that minimalizes the fact that the Earth
              # is not spherical but elipsoidal
    countryNo=len(countries)
    distance = [[inf for x in range(countryNo)] for y in range(countryNo)]
    for i in range(countryNo):
        for j in range(i+1,countryNo):
            deltaLong=abs(countries[i][5]-countries[j][5])
            fi1 = countries[i][4]
            fi2 = countries[j][4]
            dist = math.acos(math.sin(fi1)*math.sin(fi2) + math.cos(fi1)*math.cos(fi2)*math.cos(deltaLong))
            distance[i][j] = dist*R
            distance[j][i] = dist*R
    return distance
