import Data.List (maximumBy, sortOn, partition, intercalate)
import Data.Ord (comparing)
import System.IO
import System.Environment (getArgs)
import Data.List.Split (chunksOf)
import Data.Array
import Debug.Trace

data Library = Library {
    library_id :: Int,
    n_books :: Int,
    signup_delay :: Int,
    books_per_day :: Int,
    books :: [Int]
} deriving Show

-- parsing

buildLibrary :: (String, String) -> Int -> Library
buildLibrary (s_cst, s_books) lib_id = Library { library_id = lib_id, n_books = n_books, signup_delay = signup_delay, books_per_day = books_per_day, books = lib_books } where
    (n_books, signup_delay, books_per_day) = readLibraryCst s_cst
    lib_books = readLibraryBooks s_books

chunksOf2 (a:b:c) = (a, b):(chunksOf2 c)
chunksOf2 _ = []

readLibraries :: [String] -> [Library]
readLibraries lines = map buildL indexed_lines_pairs where
    lines_pairs = chunksOf2 lines
    indexed_lines_pairs = zip lines_pairs [0..]
    buildL (pair, index) = buildLibrary pair index where

readInt :: String -> Int
readInt = read

readCst :: String -> (Int, Int, Int)
readCst line = (n_books, n_libraries, n_days) where
    [n_books, n_libraries, n_days] = readInt <$> words line

readScores :: String -> [Int]
readScores line = readInt <$> words line

readLibraryCst :: String -> (Int, Int, Int)
readLibraryCst line = (n_books, signup_delay, books_per_day) where
    [n_books, signup_delay, books_per_day] = readInt <$> words line

readLibraryBooks :: String -> [Int]
readLibraryBooks line = readInt <$> words line

-- logic

maxBooksSent :: Library -> Int -> Int
maxBooksSent lib days_left = (days_left - (signup_delay lib)) * (books_per_day lib)

nBestBooks :: Int -> [Int] -> (Int -> Int) -> [Int]
nBestBooks n books score = take n (sortOn score books)

libraryBestBooks :: Library -> Int -> (Int -> Int) -> [Int]
libraryBestBooks lib days_left score = nBestBooks mbs (books lib) score where
    mbs = maxBooksSent lib days_left

libraryHeuristic :: Library -> [Int] -> (Int -> Int) -> Int
libraryHeuristic lib best_books score = sum (map score best_books) `div` signup_delay lib

bestLibrary :: [Library] -> Int -> Array Int Int -> (Library, [Int], [Library], Array Int Int)
bestLibrary libraries days_left score_array = (best_library, best_books, other_libraries, new_score) where
  other_libraries = filter (\lib -> library_id lib /= library_id best_library) libraries
  best_books = bestBooks best_library
  best_library = maximumBy compare libraries
  compare = (comparing heuristic)
  score book = score_array ! book
  heuristic lib = libraryHeuristic lib (bestBooks lib) score
  bestBooks lib = libraryBestBooks lib days_left score
  new_score = score_array // [(book,0) | book <- best_books]

solve:: [Library] -> Int -> Array Int Int -> [(Library, [Int])]
solve libraries days_left score_array =
    if ((days_left <= 0) || (null libraries)) then [] else
    let (best_library, best_books, other_libraries, new_score) = bestLibrary libraries days_left score_array in
        if (null best_books) then [] else (best_library, best_books):(solve other_libraries (days_left - signup_delay best_library) new_score)

printBooks :: [Int] -> String
printBooks books =
    unwords (map show books)

main = do
    [file] <- getArgs
    (line_cst:line_scores:lines_libraries) <- lines <$> readFile file
    let (n_books, n_libraries, n_days) = readCst line_cst
    let score = readScores line_scores
    -- print ("score: " ++ show score)
    let score_array = array (0, n_books-1) [(i,s) | (s,i) <- zip score [0..] ]
    let libraries = readLibraries lines_libraries
    -- print libraries
    -- print [n_books, n_libraries, n_days]
    -- print score_array
    let (best_library, best_books, other_libraries, new_score) = bestLibrary libraries n_days score_array
    -- print ("best library: " ++ show best_library)
    -- print ("best_books:" ++ show best_books)
    -- print ("others: " ++ show other_libraries)
    -- print ("score: " ++ show new_score)
    let solution = solve libraries n_days score_array
    let output = map printSingle solution where
        printSingle (lib, books) = show (library_id lib) ++ " " ++ show (length books) ++ "\n" ++ (printBooks books)
    -- print output
    putStrLn (show (length solution))
    putStrLn (intercalate "\n" output)
    -- print ("solution:" ++ show solution)
