{- |
Module      :  <File name or $Header$ to be replaced automatically>
Description :  <optional short text displayed on contents page>
Copyright   :  (c) <Authors or Affiliations>
License     :  <license>

Maintainer  :  <email>
Stability   :  unstable | experimental | provisional | stable | frozen
Portability :  portable | non-portable (<reason>)

<module description starting at first column>
-}

module ReadCNF where

import Data.List (isPrefixOf)
import Data.List.Split (splitOn)
import Data.String (words)


parse :: [Char] -> [[Int]]
{- ^
--  Takes a DIMACS file as an input string and generates a [[Int]]
--  CNF representation.
  Parameters:
    cnf     - DIMACS .cnf file input directly from a file as a string.
  Returns:
    [[Int]] - Double list CNF.
-}
parse cnf = makeCNF $ stripComments $ splitOn "\n" cnf


makeCNF :: [[Char]] -> [[Int]]
-- ^ Essentially a helper for parse.  Process [[Char]] CNF instance.
makeCNF cnf = map stringsToInts $ dropEmpties $
              map dropZero $ map words $ stripProblem cnf


stringsToInts :: [String] -> [Int]
-- ^ Converts number strings to Ints in each clause.
stringsToInts clause = map (read::String->Int) clause


dropEmpties :: Eq t => [[t]] -> [[t]]
-- ^ Removes any empty lines from preprocessed instance.
dropEmpties cnf = filter (/= []) cnf


dropZero :: [[Char]] -> [[Char]]
-- ^ Removes 0's from the end of clauses.
dropZero clause = filter (/= "0") clause


getProblem :: [[Char]] -> [Char]
-- ^ Processes problem information from DIMACS file (currently unused).
getProblem cnf = head $ filter (isPrefixOf "p") cnf


stripProblem :: [[Char]] -> [[Char]]
-- ^ Removes problem line "p cnf".  Information is acquired parsing cnf.
stripProblem cnf = filter (not . isPrefixOf "p") cnf


stripComments :: [[Char]] -> [[Char]]
-- ^ Removes any lines starting with a 'c'
stripComments cnf = filter (not . isPrefixOf "c") cnf

