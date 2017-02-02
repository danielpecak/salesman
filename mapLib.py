# -*- coding: utf-8 -*-
from mpl_toolkits.basemap import Basemap
import matplotlib.pyplot as plt
import numpy as np
import cities
import genetics
import sys
import time

def drawMap(chromosome,continent,fname=None):
    "Draws a map of a given chromosome on a given continent."
    continentBoundary = {
    'AO': [ 121, -43.0, 230, 20, 130,-10],
    'AS': [  31, -13.0, 141, 53,  60, 20],
    'AF': [ -24, -35.0,  59, 38,  10,  0],
    'EU': [ -22,  33.0,  40, 65,  17, 52],
    'SA': [ -82, -52.0, -40, 15, -17,-62],
    'NA': [-100,   4.0, -52, 50, -62, 20]}
    lllon, lllat, urlon, urlat, lon0, lat0 = continentBoundary[continent]
    map = Basemap(projection='merc', lat_0 = lat0, lon_0 = lon0,
        resolution = 'c',
        llcrnrlon=lllon, llcrnrlat=lllat,
        urcrnrlon=urlon, urcrnrlat=urlat)
    map.drawcountries()
    # TODO make maps prettier: better colors etc.
    map.fillcontinents(color = 'coral')
    # Connect cities in a proper order
    for i in range(len(caplon)-1):
        nylon,nylat,lonlon,lonlat = caplon[chromosome[i]],caplat[chromosome[i]],caplon[chromosome[i+1]],caplat[chromosome[i+1]]
        map.drawgreatcircle(nylon,nylat,lonlon,lonlat,linewidth=1,color='b')
    # Draw points on cities
    x,y = map(caplon,caplat)
    map.plot(x,y, 'bo', markersize=2)
    # Write city names
    for label, xpt, ypt in zip(labels,x,y):
        plt.text(xpt,ypt,label,fontsize=4)
    if fname==None:
        fname = str(int(time.time()))
    plt.savefig('images/'+fname+'.svg', bbox_inches='tight')

mycontinent = 'AO'
mycontinent = 'AS'
mycontinent = 'AF'
mycontinent = 'NA'
mycontinent = 'SA'
mycontinent = 'EU'

countries = cities.loadCountries(mycontinent)
# Calculate the distance between countries
countryNo = len(countries)
distance = cities.calcDistances(countries)
### Set population & heuristics
population = genetics.growPopulation(10,countryNo)
heuristicPop = genetics.getHeuristicSolutions(distance,countryNo,countryNo)
caplon = [x[3] for x in countries]
caplat = [x[2] for x in countries]
labels = [unicode(x[1],'utf-8') for x in countries]

chromosome = population.pop()
chromosome = heuristicPop.pop()

drawMap(chromosome,mycontinent)
