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

module Common where

import Data.List (group, maximumBy, sort)
import Data.Ord (comparing)

--
mostFrequent literals =
  head . maximumBy (comparing length) . group . sort $ literals


flatten :: [[a]] -> [a]
-- ^ Flattens a double list into a single list
flatten [] = []
flatten (x:xs) = flatten' x xs

flatten' :: [a] -> [[a]] -> [a]
-- ^ Does the work of flatten.
flatten' [] [] = []
flatten' [] (x:xs) = flatten' x xs
flatten' (x:xs) cnf = x:(flatten' xs cnf)


count :: Eq a => a -> [a] -> Int
-- ^ Count occurrences of value in provided parameter.
count value  = length . filter (value ==)

