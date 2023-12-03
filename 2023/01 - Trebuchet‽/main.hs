import Data.Char (isDigit, digitToInt)
import Data.List (isPrefixOf, tails)
import Data.Maybe (mapMaybe)

extractDigits1 :: String -> [Int]
extractDigits1 [] = []
extractDigits1 (x:xs)
    | isDigit x = (digitToInt x) : (extractDigits1 xs)
    | otherwise =                   extractDigits1 xs

extractDigits2 :: String -> [Int]
extractDigits2 str = mapMaybe digit (tails str)
    where
        digit :: String -> Maybe Int
        digit [] = Nothing
        digit str
            | isDigit (head str)       = Just $ digitToInt (head str)
            | "zero"  `isPrefixOf` str = Just 0
            | "one"   `isPrefixOf` str = Just 1
            | "two"   `isPrefixOf` str = Just 2
            | "three" `isPrefixOf` str = Just 3
            | "four"  `isPrefixOf` str = Just 4
            | "five"  `isPrefixOf` str = Just 5
            | "six"   `isPrefixOf` str = Just 6
            | "seven" `isPrefixOf` str = Just 7
            | "eight" `isPrefixOf` str = Just 8
            | "nine"  `isPrefixOf` str = Just 9
            | otherwise                = Nothing

main :: IO ()
main = do
    input <- readFile "input.txt"

    let part1 = sum [ 10*(head nums) + (last nums) | nums <- map extractDigits1 $ lines input ]
    let part2 = sum [ 10*(head nums) + (last nums) | nums <- map extractDigits2 $ lines input ]

    putStr "Part 1: "
    putStrLn $ show $ part1

    putStr "Part 2: "
    putStrLn $ show $ part2