# DPLL
A simple DPLL implementation written in Haskell.

## Background
The Davis–Putnam–Logemann–Loveland ([DPLL](https://en.wikipedia.org/wiki/DPLL_algorithm)) algorithm is a backtracking depth first search algorithm designed for finding a (truth assignment)[https://en.wikipedia.org/wiki/Truth_value] for a [CNF SAT](https://en.wikipedia.org/wiki/Boolean_satisfiability_problem) instance.

The algorithm extends/speeds up backtracking by applying numerous possible heuristics, including unit propagation, pure literal assignment, clause learning, etc. (many speed-ups to the basic idea have been developed over the years).

In my opinion this is one of the most important algorithms we have discovered, and it remains one of my favorite.

## Compilation and use.

The included `Makefile` has been tested on Linux and OS X systems in the past, and should compile using the [Glasgow Haskell Compiler](https://www.haskell.org/ghc/) (ghc) by calling make without any parameters.
```
./make
```

The binary `dpll` should result, and can be called with a single parameter: the cnf file to be processed. A few such files are provided in the directory `cnf`.

E.g.,
```
./dpll ./cnf/simple_v3_c2.cnf
([],[1,2,-3])
```

The above result is a 2-tuple:
* The first is any remaining clauses in the CNF (if search fails)
* the second is the variable assignment: [1, 2, -3]

The empty set of remaining clauses here indicates a successful assignment *was found.*

### Input format

Input files are in [DIMACS format](https://people.sc.fsu.edu/~jburkardt/data/cnf/cnf.html), where the CNF is expressed one clause per line, with variables represented as positive or negative integers.

