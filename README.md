# DPLL
A simple DPLL implementation written in Haskell.

## Background
The Davis–Putnam–Logemann–Loveland ([DPLL](https://en.wikipedia.org/wiki/DPLL_algorithm)) algorithm is a backtracking depth first search algorithm designed for finding a [https://en.wikipedia.org/wiki/Truth_value](truth assignment) for a [CNF SAT](https://en.wikipedia.org/wiki/Boolean_satisfiability_problem) instance.

The algorithm extends/speeds up backtracking by applying numerous possible heuristics, including unit propagation, pure literal assignment, clause learning, etc. (many speed-ups to the basic idea have been developed over the years).

In my opinion this is one of the most important algorithms we have discovered, and it remains one of my favorite.

## Compilation and use.

The included `Makefile` has been tested on Linux and OS X systems in the past, and should compile using the [Glasgow Haskell Compiler](https://www.haskell.org/ghc/) (ghc) by calling make without any parameters.
```
./make
```

