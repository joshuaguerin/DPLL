
TARGET = dpll

all: $(TARGET)

$(TARGET): main.hs ReadCNF.hs DPLL.hs Heuristics.hs Common.hs
	ghc --make main.hs -o $(TARGET)
#	ghc --make main.hs -o $(TARGET) -threaded
#	ghc --make main.hs -o $(TARGET) -prof -fprof-auto

clean:
	rm *.o *.hi *~ $(TARGET)
