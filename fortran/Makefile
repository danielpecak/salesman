FC = f95
INCLUDE	 	 = -I.
FFLAGS	 	 = -O3 -march=native -g -Wall -Wextra
COMPILE.F  = $(FC) $(INCLUDE) $(FFLAGS)

BINS = bin/test

all: bin/test

random.o: interpol.o

bin/%: random.o interpol.o genetics.o cities.o  %.o
	mkdir -p bin
	$(COMPILE.F) -o $@ $^

%.o : %.f95
	$(COMPILE.F) -c $< -o $@


clean:
	rm -f *.o *.mod $(BINS)
