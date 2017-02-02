# -*- coding: utf-8 -*-
from mpl_toolkits.basemap import Basemap
import matplotlib.pyplot as plt
import numpy as np
import cities
import genetics
import sys
import time

def drawWorldMap(chromosome,countries,fname=None):
    "Draws a map of the whole world"
    m = Basemap(projection='robin',lon_0=0,resolution='c')
    m.drawcoastlines()
    m.fillcontinents(color='coral',lake_color='aqua')
    # draw parallels and meridians.
    m.drawparallels(np.arange(-90.,140.,30.))
    m.drawmeridians(np.arange(0.,360.,60.))
    m.drawmapboundary(fill_color='aqua')
    # Draw points on cities
    caplon = [x[3] for x in countries]
    caplat = [x[2] for x in countries]
    labels = [unicode(x[1],'utf-8') for x in countries]
    x,y = m(caplon,caplat)
    m.plot(x,y, 'bo', markersize=5)
    for i in range(len(caplon)-1):
        nylon,nylat,lonlon,lonlat = caplon[chromosome[i]],caplat[chromosome[i]],caplon[chromosome[i+1]],caplat[chromosome[i+1]]
        m.drawgreatcircle(nylon,nylat,lonlon,lonlat,linewidth=1,color='b')
    if fname==None:
        fname = 'world'+str(int(time.time()))
    plt.savefig('images/'+fname+'.png')


def drawMap(chromosome,continent,countries,fname=None):
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
    caplon = [x[3] for x in countries]
    caplat = [x[2] for x in countries]
    labels = [unicode(x[1],'utf-8') for x in countries]
    # TODO make maps prettier: better colors etc.
    map.fillcontinents(color = 'coral')
    # Connect cities in a proper order
    # TODO fix 180/-180 longitude problem
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

def drawUSMap(chromosome,states,fname=None):
    "Draws a map of the United States of America. That is true."
    m = Basemap(llcrnrlon=-126,llcrnrlat=24,urcrnrlon=-67,urcrnrlat=50,
                resolution='c',projection='merc',lon_0=-95,lat_0=37)
    caplon = [x[3] for x in states]
    caplat = [x[2] for x in states]
    labels = [unicode(x[1],'utf-8') for x in states]
    m.drawcoastlines()
    m.drawstates()
    m.drawcountries()
    m.fillcontinents(color='coral',lake_color='aqua')
    m.drawmapboundary(fill_color='aqua')
    for i in range(len(caplon)-1):
        nylon,nylat,lonlon,lonlat = caplon[chromosome[i]],caplat[chromosome[i]],caplon[chromosome[i+1]],caplat[chromosome[i+1]]
        m.drawgreatcircle(nylon,nylat,lonlon,lonlat,linewidth=2,color='b')
    # Draw points on cities
    x,y = m(caplon,caplat)
    m.plot(x,y, 'bo', markersize=4)
    # Write city names
    for label, xpt, ypt in zip(labels,x,y):
        plt.text(xpt,ypt,label,fontsize=10)
    if fname==None:
        fname = 'US'+str(int(time.time()))
    plt.savefig('images/'+fname+'.svg', bbox_inches='tight')
