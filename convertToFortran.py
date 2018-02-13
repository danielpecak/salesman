# -*- coding: utf-8 -*-
"""This module writes coordinates in radians for different places to FORTRAN format. """

import cities
import sys

codes=['SA','NA','AS','AO','AF','EU','ALL']
names = ['southAmerica','northAmerica','asia','oceania','africa','europa','world']

for ii in range(len(codes)):
    code = codes[ii]
    name = names[ii]
    country = cities.loadCountries(code)
    f = open('fortran/{}.f'.format(code.lower()),'w')
    for c in range(len(country)):
        string = "{}(:,{:d}) = (/ {:.10f}d0, {:.10f}d0 /)\n".format(name,c+1,country[c][4],country[c][5])
        f.write(string)
    f.close()
