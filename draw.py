# -*- coding: utf-8 -*-
import mapLib
import cities

f = open('fortran/eur.dat','r')
text = f.readlines()

data = []
for i in range(len(text)):
    data.append([x-1 for x in map(int,text[i][:-1].split(' '))])

continent='EU'
countries = cities.loadCountries(continent)

for i in range(10):
    filename = 'fortran-europa-{:d}'.format(i)
    mapLib.drawMap(data[i],continent,countries,fname=filename)
    # print filename
