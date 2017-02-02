# -*- coding: utf-8 -*-
from mpl_toolkits.basemap import Basemap
import matplotlib.pyplot as plt
import numpy as np
import cities
import genetics
import sys

continentBoundary = {'AO': [ 131, -38.0,-145, 58, 170,  0], 'AS': [  31, -12.0, 145, 58,  60, 20], 'AF': [ -19, -38.0,  54, 38,  10,  0], 'EU': [ -12,  33.0,  40, 65,  17, 52], 'SA': [ -85, -44.0, -30, 15, -17,-62], 'NA': [-130,   6.0, -55, 53, -72, 20]}
def drawMap(chromosome,continent):
    "Draws a map of a given chromosome on a given continent."
    lllon, lllat, urlon, urlat, lon0, lat0 = continentBoundary[continent]
    map = Basemap(projection='merc', lat_0 = lat0, lon_0 = lon0,
        resolution = 'c',
        llcrnrlon=lllon, llcrnrlat=lllat,
        urcrnrlon=urlon, urcrnrlat=urlat)
    map.drawcountries()
    map.fillcontinents(color = 'coral')
    # Connect cities in a proper order
    for i in range(len(caplon)-1):
        nylon,nylat,lonlon,lonlat = caplon[chromosome[i]],caplat[chromosome[i]],caplon[chromosome[i+1]],caplat[chromosome[i+1]]
        map.drawgreatcircle(nylon,nylat,lonlon,lonlat,linewidth=1,color='b')
    # Draw points on cities
    x,y = map(caplon,caplat)
    map.plot(x,y, 'bo', markersize=8)
    # Write city names
    for label, xpt, ypt in zip(labels,x,y):
        plt.text(xpt,ypt,label)
    plt.show()


countries = cities.loadCountries('SA')
# Calculate the distance between countries
countryNo = len(countries)
distance = cities.calcDistances(countries)
### Set population & heuristics
population = genetics.growPopulation(10,countryNo)
heuristicPop = genetics.getHeuristicSolutions(distance,countryNo,countryNo)

caplon = [x[3] for x in countries]
caplat = [x[2] for x in countries]
labels = [x[1] for x in countries] #TODO unicode problem!
labels = ['Buenos Aires', 'Sucre', 'Brasilia', 'Santiago', 'Bogota', 'Quito', 'New Guatemala', 'Georgetown', 'Asuncion', 'Lima', 'Paramaribo', 'Montevideo', 'Caracas']



chromosome = population.pop()
chromosome = heuristicPop.pop()

drawMap(chromosome,'SA')
