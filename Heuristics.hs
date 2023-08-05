{- |
Module      :  <File name or $Header$ to be replaced automatically>
Description :  An implementation of DPLL in Haskell.
Copyright   :  (c) Joshua T. Guerin, Ph.D.
License     :  <license>

Maintainer  :  jguerin@utm.edu
Stability   :  experimental
Portability :  portable

<module description starting at first column>
-}

module Heuristics where

import Common

moms :: (Ord a, Num a) => [[a]] -> a
-- ^ Maximum occurrences of minimal size (MOMS) heuristic.
moms cnf = addSign moms_value cnf
  where moms_value = moms' cnf

moms' :: (Ord c, Num c) => [[c]] -> c
-- ^ Helper generates positive MOMS value.
moms' cnf = mostFrequent $ map abs $ flatten $
            filter (\c -> length c == min) cnf
  where min = minimum $ map length cnf

addSign :: (Num a, Eq a) => a -> [[a]] -> a
-- ^ Helper for MOMS heuristic, selects sign for MOMS value.
addSign literal cnf = if count (negate literal) flat < count literal flat
                      then literal else (negate literal)
  where flat = flatten cnf
