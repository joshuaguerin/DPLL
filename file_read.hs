import System.Environment (getProgName, getArgs)
import Data.List (isPrefixOf)
import Data.List.Split (splitOn)
import Data.String (words)

main = do args <- getArgs
          fileContent <- readFile (head args)
          putStr $ show $  parse fileContent

parse cnf = makeCNF $ stripComments $ splitOn "\n" cnf

makeCNF cnf = map stringsToInts $ dropEmpties $
              map dropZero $ map words $ stripProblem cnf


stringsToInts clause = map (read::String->Int) clause
dropEmpties cnf = filter (/= []) cnf
dropZero clause = filter (/= "0") clause
getProblem cnf = head $ filter (isPrefixOf "p") cnf
stripProblem cnf = filter (not . isPrefixOf "p") cnf
stripComments cnf = filter (not . isPrefixOf "c") cnf

