#!/usr/bin/env python
# -*- coding:utf-8 -*-
"""Module to manage Input and Output. This is important to save the evolution at some stage and load it later and continue."""
from os import listdir

def fnameSnapshot(continent,popNo,xmen,t,prefix=None):
    """Makes the name of the snapshot to save."""
    return"{}{}_P{}_X{}_T{}".format(prefix,continent,popNo/1000.,xmen*1000.,t/100.)

def saveSnapshot(continent,popNo,xmen,t,population,bestpopulation,prefix=None):
    """Saves progess during the process."""
    fname = fnameSnapshot(continent,popNo,xmen,t,prefix=None)
    f = open('snapshot/'+fname,'wb')
    for p in population:
        f.write(" ".join(map(str,p))+"\n")
    for p in bestpopulation:
        f.write(" ".join(map(str,p))+"\n")
    f.close()

def loadSnapshot(fname,popNo):
    """Loads a file saved at a given time (according to the filename) and returns list of population and list of best examples."""
    tab = []
    f = open('snapshot/'+fname,'rb')
    file = f.readlines()
    for row in file:
        r = map(str.strip,row[:-1].split())
        tab.append(map(int,r))
    f.close()
    time0 = 100*float(fname.split('_T')[1])
    return tab[0:popNo], tab[popNo:2*popNo], int(time0)

def lastSnapshot(continent,popNo,xmen):
    """Reads all snapshots and shows the last one."""
    fname = fnameSnapshot(continent,popNo,xmen,1000) # time=1000 because it does not matter. not very elegant
    ldir = listdir('snapshot/')
    for f in sorted(ldir,reverse=True):
        if fname.split('_T')[0] in f:
            return f
    return None


def saveLog(filename):
    """Saves logs of saving the process of evolution."""
    # TODO get time (year-month-day hh:mm:ss)
    # timestamp = ''
    # TODO write logs in a form timestamp FILENAME
    # f = open('logs.log','wb')
    #   f.write(timestamp+filename+"\n")
    # f.close()
