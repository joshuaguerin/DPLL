# DPLL
A simple DPLL implementation written in Haskell.

The Davis–Putnam–Logemann–Loveland ([DPLL](https://en.wikipedia.org/wiki/DPLL_algorithm)) algorithm is a backtracking depth first search algorithm designed for finding a [https://en.wikipedia.org/wiki/Truth_value](truth assignment) for a [CNF SAT](https://en.wikipedia.org/wiki/Boolean_satisfiability_problem) instance.

The algorithm extends/speeds up backtracking by applying numerous possible heuristics, including unit propagation, pure literal assignment, clause learning, etc. (many speed-ups to the basic idea have been developed over the years).

