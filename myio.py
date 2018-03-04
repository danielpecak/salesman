#!/usr/bin/env python
# -*- coding:utf-8 -*-
"""Module to manage Input and Output. This is important to save the evolution at some stage and load it later and continue."""
from os import listdir, remove

#####
##### Managin snapshots
#####
def saveSnapshot(continent,popNo,xmen,t,population,bestpopulation,prefix=None):
    """Saves progess during the process."""
    """Units:"""
    """population  (thousand)"""
    """mutation rate (permil)"""
    """time          (hundred)"""
    if prefix==None:
        prefix=''
    fname = "{}{}_P{}_X{}_T{}.dat".format(prefix,continent,popNo/1000.,xmen*1000.,t/100.)
    f = open('snapshot/'+fname,'wb')
    for p in population:
        f.write(" ".join(map(str,p))+"\n")
    for p in bestpopulation:
        f.write(" ".join(map(str,p))+"\n")
    f.close()


def loadSnapshot(fname,popNo):
    """Loads a file saved at a given time (according to the filename) and returns list of population, list of best examples and a time at which it was saved."""
    tab = []
    f = open('snapshot/'+fname,'rb')
    file = f.readlines()
    for row in file:
        r = map(str.strip,row[:-1].split())
        tab.append(map(int,r))
    f.close()
    time0 = 100*float(fname.split('_T')[1].split('.dat')[0])
    return tab[0:popNo], tab[popNo:2*popNo], int(time0)

def lastSnapshot(continent,popNo,xmen):
    """Reads all snapshots and shows the last one."""
    fname = "{}_P{}_X{}".format(continent,popNo/1000.,xmen*1000.)
    ldir = listdir('snapshot/')
    for f in sorted(ldir,reverse=True):
        if fname in f:
            return f
    return None

def clearSnapshots(continent,popNo,xmen,prefix=None):
    """Removes all snapshots from data/ directory. """
    fname = "{}{}_P{}_X{}_T{}".format(prefix,continent,popNo/1000.,xmen*1000.,10.)
    if prefix==None: prefix=''
    ldir = listdir('snapshot/')
    for f in ldir:
        if fname.split('_T')[0] in f:
            try:
                remove('snapshot/'+f)
                print "Snapshot {} removed".format(f)
            except OSError:
                pass

#####
##### Managin STATS
#####
def newStats(continent,popNo,xmen):
    """Creates a file with stats ()"""
    fname = "{}_P{}_X{}".format(continent,popNo/1000.,xmen*1000.)

    path  = 'data/'+fname+'_stats.dat'
    f = open(path,'wb')
    f.write('# Time | Mean | Sqr(Variance) \n')
    f.close()
    print "Creates new file: "+path

def saveStats(continent,popNo,xmen,t,mean,sqvar):
    """Saves an average value and dispertion for a time t."""
    fname = "{}_P{}_X{}".format(continent,popNo/1000.,xmen*1000.)

    path  = 'data/'+fname+'_stats.dat'
    f = open(path,'a')
    output = "{} {:0.2f} {:0.2f} \n".format(t,mean,sqvar)
    f.write(output)
    f.close()
