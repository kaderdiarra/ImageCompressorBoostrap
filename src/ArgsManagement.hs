module ArgsManagement
    ( parseArgs,
      errorMessage
    ) where

import System.Environment (getArgs)
import Data.Char (isDigit)
import Data.Maybe (fromMaybe, fromJust, isJust, isNothing )
import System.Exit (exitWith, ExitCode (ExitFailure, ExitSuccess),exitSuccess)
import System.IO (hPutStrLn, stderr)
import Text.Read (readMaybe)

-- • -n : number of colors in the final image
-- • –l : convergence limit
-- • -f : path to the file containing the colors of the pixels

errorMessage :: IO ()
errorMessage = hPutStrLn stderr "USAGE: ./imageCompressor -n N -l L -f F:\n\n\
\      N       number of colors in the final image\n\
\      L       convergence limit\n\
\      F       path to the file containing the colors of the pixels\n" >> exitWith (ExitFailure 84)

-- CONF
data Conf = Conf {
    n :: Maybe Int,
    l :: Maybe Float,
    f :: Maybe String
}   deriving Show

-- DEFAULT CONF
initConf :: Conf
initConf = Conf {
    n = Nothing,
    l = Nothing,
    f = Nothing
}


strToMaybeFloat :: [Char] -> Maybe Float
strToMaybeFloat [] = Nothing
strToMaybeFloat str = readMaybe str :: Maybe Float


strToMaybeInt :: [Char] -> Maybe Int
strToMaybeInt [] = Nothing
strToMaybeInt str = readMaybe str :: Maybe Int

{- PARSE NBR OF COLORS -}
parseNbrOfColors:: [Char] -> Maybe Int
parseNbrOfColors [] = Nothing
parseNbrOfColors str | nbrOfColors >= Just 0 = nbrOfColors
                       | otherwise = Nothing
                        where
                            nbrOfColors = strToMaybeInt str

{- PARSE CONVERGENCE LIMIT -}
parseConvergenceLimit:: [Char] -> Maybe Float
parseConvergenceLimit [] = Nothing
parseConvergenceLimit str | limit >= Just 0 = limit
                       | otherwise = Nothing
                        where
                            -- string to float
                            limit = strToMaybeFloat str

parseFilePath:: [Char] -> Maybe String
parseFilePath [] = Nothing
parseFilePath str = Just str -- check if file exist

manageOptions :: Maybe Conf -> [String] -> Maybe Conf
manageOptions (Just conf) ("-n":y:xs) | isJust val = Just conf {
                                        n = val
                                    }
                          | otherwise = Nothing
                          where
                              val = parseNbrOfColors y
manageOptions (Just conf) ("-l":y:xs) | isJust val = Just conf {
                                                      l = val
                                                    }
                           | otherwise = Nothing
                          where
                              val = parseConvergenceLimit y
manageOptions (Just conf) ("-f":y:xs) | isJust val = Just conf {
                                                      f = val
                                                    }
                           | otherwise = Nothing
                          where
                              val = parseFilePath y

manageOptions conf (_:_) = Nothing

getOpts :: Maybe Conf -> [String] -> Maybe Conf
getOpts Nothing (x:xs) = Nothing
getOpts conf [] = conf
getOpts conf [x] = Nothing
getOpts conf (x:y:xs) =  getOpts (manageOptions conf (x:y:xs)) xs

parseArgs :: [String] -> Maybe Conf
parseArgs [] = Nothing
parseArgs args | "-n" `notElem` args = Nothing
               | "-l" `notElem` args = Nothing
               | "-f" `notElem` args = Nothing
               | otherwise = getOpts (Just initConf) args
