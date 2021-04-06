module Lib
    ( someFunc
    ) where

import System.Environment (getArgs)
import Data.Maybe (isNothing)
import ArgsManagement (parseArgs, errorMessage)

type MyTuple = (Int, Int, Int)

calcul3DDistance ::  MyTuple -> MyTuple -> Float
calcul3DDistance (x1, y1, z1) (x2, y2, z2) = sqrt(xres + yres + zres)
    where
        xres = fromIntegral (x1 - x2)**2
        yres = fromIntegral (y1 - y2)**2
        zres = fromIntegral (z1 - z2)**2

readTuple :: String -> MyTuple
readTuple str = read str :: MyTuple

closestVector :: [MyTuple] -> MyTuple -> MyTuple
closestVector [x] compare = x
closestVector (x:y:xs) compare | (calcul3DDistance x compare) < (calcul3DDistance y compare) = closestVector (x:xs) compare
                               | otherwise = closestVector (y:xs) compare


program :: [String] -> IO ()
program args | isNothing conf = errorMessage
             | otherwise =  print "hello Kader !"
             where
               conf = parseArgs args

imageCompressor :: IO ()
imageCompressor = do
    args <- getArgs
    program args

someFunc :: IO ()
someFunc = do
    contents <- readFile "./src/liste"
    --print $ map readTuple $ words contents
    let vectorsTuple = map readTuple $ words contents
    print $ closestVector vectorsTuple (34,18,112)
