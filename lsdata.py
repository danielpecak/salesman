#!/usr/bin/env python
# -*- coding:utf-8 -*-

import os

ls = os.listdir('snapshot/')
for l in ls:
    time = l.split('_T')[1]
    pop  = l.split('_P')[1].split('_X')[0]
    prob = l.split('_X')[1].split('_T')[0]
    print "The file: {} run for {} generations, growing population of {} with mutation rate: {}.".format( l, float(time)*100, float(pop)*1000, float(prob)/1000.)

print l



# names = ['AO','GG','PL','EA']
# names = ['AS']
# pops  = [100,1000,2000,5000,10000,20000,50000,100000]
# probs = [0.5,0.1,0.01,0.003,0.00005]
# probs = [0.00005]
# gens  = [400,1000,1500,2100,10000]
# gens = [10000]
# i=0
# for name in names:
#     for pop in pops:
#         for prob in probs:
#             for gen in gens:
#              i+=1
#              print "{}_P{}_X{}_T{}".format(name,pop/1000,prob*1000,gen/100)
# print i
