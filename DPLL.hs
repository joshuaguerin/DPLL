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

module DPLL where

import Data.List (sort, sortBy)
import Heuristics
import Common

cnf:: [[Int]]
cnf = [[16, 17, 30], [-17, 22, 30], [-17, -22, 30], [16, -30, 47], [16, -30, -47], [-16, -21, 31], [-16, -21, -31], [-16, 21, -28], [-13, 21, 28], [13, -16, 18], [13, -18, -38], [13, -18, -31], [31, 38, 44], [-8, 31, -44], [8, -12, -44], [8, 12, -27], [12, 27, 40], [-4, 27, -40], [12, 23, -40], [-3, 4, -23], [3, -23, -49], [3, -13, -49], [-23, -26, 49], [12, -34, 49], [-12, 26, -34], [19, 34, 36], [-19, 26, 36], [-30, 34, -36], [24, 34, -36], [-24, -36, 43], [6, 42, -43], [-24, 42, -43], [-5, -24, -42], [5, 20, -42], [5, -7, -20], [4, 7, 10], [-4, 10, -20], [7, -10, -41], [-10, 41, 46], [-33, 41, -46], [33, -37, -46], [32, 33, 37], [6, -32, 37], [-6, 25, -32], [-6, -25, -48], [-9, 28, 48], [-9, -25, -28], [19, -25, 48], [2, 9, -19], [-2, -19, 35], [-2, 22, -35], [-22, -35, 50], [-17, -35, -50], [-29, -35, -50], [-1, 29, -50], [1, 11, 29], [-11, 17, -45], [-11, 39, 45], [-26, 39, 45], [-3, -26, 45], [-11, 15, -39], [14, -15, -39], [14, -15, -45], [14, -15, -27], [-14, -15, 47], [17, 17, 40], [1, -29, -31], [-7, 32, 38], [-14, -33, -47], [-1, 2, -8], [35, 43, 44], [21, 21, 24], [20, 29, -48], [23, 35, -37], [2, 18, -33], [15, 25, -45], [9, 14, -38], [-5, 11, 50], [-3, -13, 46], [-13, -41, 43]]


-- | Generates a list of literals from cnf.
literals = filterDuplicates $ sort $
           map (\x->if x>0 then x else (-x)) $ flatten cnf


propagatePurify :: [[Int]] -> ([[Int]], [Int])
{- ^
  Wrapper for unitPropagate'.
  Applies unit propagation until convergence.
-}
propagatePurify cnf = propagatePurify' cnf []


propagatePurify' :: [[Int]] -> [Int] -> ([[Int]], [Int])
-- ^ Repeatedly apply unit Propagation until convergence.
propagatePurify' cnf units = 
  if newUnits==[] && pures==[] then (cnf, units)
  else propagatePurify' purified assignment
  where (propagated, newUnits) = unitPropagate cnf
        (purified, pures) = pureLiteralAssign propagated
        assignment = filterDuplicates $ sortAssign (newUnits ++ pures ++ units)


unitPropagate :: [[Int]] -> ([[Int]], [Int])
-- ^ Apply unit propagation once to cnf.
unitPropagate cnf =
  (reduceCNF units $ filter (not . clauseSat units) cnf, units)
  where units = findUnits cnf


findUnits :: (Ord a, Num a) => [[a]] -> [a]
-- ^ Generates a lit of unit clauses.
findUnits cnf = sortAssign $ findUnits' cnf
findUnits' [] = []
findUnits' (x:xs)
  | (length x) == 1 = (head x):findUnits' xs
  | otherwise = findUnits' xs


pureLiteralAssign cnf = (applyAssignment pureList cnf, pureList)
  where pureList = pureLiterals cnf


pureLiterals :: (Ord a, Num a) => [[a]] -> [a]
-- ^ Computes a list of pure literals from the cnf
pureLiterals cnf = 
  pureLiterals' positive negative
  where candidates = sort $ flatten cnf
        positive = filterDuplicates $ filter (\x->x>0) candidates
        negative = filterDuplicates $ reverse $ filter (\x->x<0) candidates


pureLiterals' :: (Ord a, Num a) => [a] -> [a] -> [a]
{- ^
  Helper function for pureLiterals
  Parameters:
    (x:xs) - A list of positive literals, ascending
    (y:ys) - A list of negative literals, descending
  Returns:
    A list of pure literals (occurs positive or negative, not both).
-}
pureLiterals' [] [] = []
pureLiterals' (x:xs) [] = (x:xs)
pureLiterals' [] (y:ys) = (y:ys)
pureLiterals' (x:xs) (y:ys)
  | x == (-y) = pureLiterals' xs ys
  | x < (-y) = x:(pureLiterals' xs (y:ys))
  | (-y) < x = y:(pureLiterals' (x:xs) ys)


contradiction :: Foldable t => [t a] -> Bool
-- ^ Checks for empty clauses (contradictions) in current theory.
contradiction cnf = foldr (||) False $ map (== 0) $ map length cnf


filterDuplicates :: Eq a => [a] -> [a]
-- ^ Filters out duplicate entries from a sorted list.
filterDuplicates [] = []
filterDuplicates [x] = [x]
filterDuplicates (x:xs) =
  if x == (head xs) then filterDuplicates xs
  else x:(filterDuplicates xs)


sortAssign list = sortBy (\x y -> if abs(x) < abs(y) then LT else GT) list

reduceCNF :: (Foldable t, Num a, Eq a) => t a -> [[a]] -> [[a]]
-- ^ Reduces opposite literals from assignment out of the CNF.
reduceCNF assignment cnf = map (reduce assignment) cnf


reduce :: (Foldable t, Num a, Eq a) => t a -> [a] -> [a]
-- ^ Reduce opposite literals from assignment out of clause.
reduce assignment clause = filter (\l ->(- l) `notElem` assignment) clause


applyAssignment :: [Int] -> [[Int]] -> [[Int]]
-- ^ Applies reduces CNF by assigned values.
applyAssignment assignment cnf = filter (not . clauseSat assignment) cnf


clauseSat :: [Int] -> [Int] -> Bool
-- ^ Returns True if assignment satisfies clause, False otherwise
clauseSat assignment clause =
 foldr (||) False $ map (check assignment) clause


check :: [Int] -> Int -> Bool
-- ^ Checks whether the literal value is the same as the value in assignment
check assignment literal = literal `elem` assignment
