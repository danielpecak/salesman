FC = f95
INCLUDE	 	 = -I.
FFLAGS	 	 = -O3 -march=native -fbounds-check -g -Wall -Wextra -fopenmp
COMPILE.F  = $(FC) $(INCLUDE) $(FFLAGS)

BINS =  bin/galgorithm bin/test

all: $(BINS)

random.o: interpol.o

bin/%: cmparser.o random.o interpol.o genetics.o cities.o myio.o  %.o
	mkdir -p bin
	$(COMPILE.F) -o $@ $^

%.o : %.f95
	$(COMPILE.F) -c $< -o $@


clean:
	rm -f *.o *.mod $(BINS)
