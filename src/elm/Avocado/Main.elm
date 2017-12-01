module Avocado.Main exposing (parseExpression)

import Parser exposing (Parser, (|.), (|=), delayedCommit, succeed, oneOf, symbol, int, float, keyword, end, keep, ignore, zeroOrMore)
import Data.ValueStore exposing (ValueStore, Value(..), registerValue)
import Avocado.Primitives exposing (spaces)
import Avocado.Assignment exposing (assignment)


parseExpression : String -> ValueStore -> Result Parser.Error ValueStore
parseExpression input store =
    Parser.run (expressionParser store) input


expressionParser : ValueStore -> Parser ValueStore
expressionParser store =
    succeed identity
        |. spaces
        |= oneOf
            [ assignment store
            ]
