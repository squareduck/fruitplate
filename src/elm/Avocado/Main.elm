module Avocado.Main exposing (parseExpression)

import Parser exposing (Parser, (|.), (|=), delayedCommit, succeed, oneOf, symbol, int, float, keyword, end, keep, ignore, zeroOrMore)
import Data.ValueStore exposing (ValueStore, Value(..), registerValue)
import Dict exposing (Dict)
import Avocado.Primitives exposing (..)
import Avocado.Values exposing (..)


parseExpression : String -> ValueStore -> Result Parser.Error ValueStore
parseExpression input store =
    Parser.run (expressionParser store) input


expressionParser : ValueStore -> Parser ValueStore
expressionParser store =
    succeed identity
        |. spaces
        |= oneOf
            [ assignmentParser store
            ]


assignmentParser : ValueStore -> Parser ValueStore
assignmentParser store =
    succeed (updateStore store)
        |= identifier
        |. spaces
        |= oneOf
            [ typedValue
            , inferredValue
            ]


updateStore : ValueStore -> String -> Value -> ValueStore
updateStore store name value =
    Dict.insert name value store
