{-# LANGUAGE OverloadedStrings #-}
import Text.Megaparsec
import Text.Megaparsec.Char
import Text.Megaparsec.Char.Lexer (decimal)
import Data.Text (Text, lines)
import qualified Data.Text.IO
import Data.Void
import Data.Map
import qualified Data.Map as Map
import qualified Data.List as List

type Parser = Parsec Void Text

data Game = Game Int [Map Color Int]
    deriving (Ord, Eq, Show)
data Color = Red | Green | Blue
    deriving (Ord, Eq, Show)

-- Parsing logic mostly copied from: https://github.com/gruhn/advent-of-code/blob/master/2023/Day02.hs
-- Megaparsec is still breaking my brain as of writing ><
parseGame :: Parser Game
parseGame = Game <$> gameID <*> gameRound `sepBy` "; "
    where
        gameID :: Parser Int
        gameID = string "Game " *> decimal <* string ": "

        gameRound :: Parser (Map Color Int)
        gameRound = Map.fromList <$> draw `sepBy` string ", "

        draw :: Parser (Color, Int)
        draw = do
            amount <- decimal
            string " "
            color <- drawColor
            return (color, amount)

        drawColor :: Parser Color
        drawColor = choice
            [ Red   <$ string "red"
            , Green <$ string "green"
            , Blue  <$ string "blue" ]


maxColorsShown :: Game -> (Int, (Int, Int, Int))
maxColorsShown (Game gameID rounds) = (gameID, List.foldr maxColors (0,0,0) rounds)
    where
        maxColors :: (Map Color Int) -> (Int,Int,Int) -> (Int,Int,Int)
        maxColors draw (maxR,maxG,maxB) =
            ( max maxR $ Map.findWithDefault 0 Red   draw
            , max maxG $ Map.findWithDefault 0 Green draw
            , max maxB $ Map.findWithDefault 0 Blue  draw )


main :: IO ()
main = do
    input <- Data.Text.IO.readFile "input.txt"

    let games = maxColorsShown <$> [ x | line <- Data.Text.lines input, let Right x = runParser parseGame ("" :: String) line ]

    putStr "Part 1: "
    print $ sum [ gameID | (gameID, (r,g,b)) <- games, r <= 12 && g <= 13 && b <= 14 ]

    putStr "Part 2: "
    print $ sum [ r*g*b | (gameID, (r,g,b)) <- games ]