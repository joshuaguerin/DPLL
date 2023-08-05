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

import System.Environment (getArgs)

import ReadCNF (parse)
import DPLL

main :: IO ()
main = do args <- getArgs
          fileContent <- readFile (head args)
          --putStr $ ( show $ parse fileContent) ++ "\n\n\n\n"
          putStr $ show $ propagatePurify $ parse fileContent

