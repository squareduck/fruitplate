module Avocado.Assignment exposing (assignment)

import Parser exposing (Parser, (|.), (|=), delayedCommit, succeed, oneOf, symbol, int, float, keyword, end, keep, ignore, zeroOrMore)
import Data.ValueStore exposing (ValueStore, Value(..), registerValue)
import Dict exposing (Dict)
import Avocado.Primitives exposing (spaces, identifier)
import Avocado.Values exposing (value, typedValue)


assignment : ValueStore -> Parser ValueStore
assignment store =
    succeed (updateStore store)
        |= identifier
        |. spaces
        |. symbol "="
        |. spaces
        |= oneOf
            [ value
            , typedValue
            ]


updateStore : ValueStore -> String -> Value -> ValueStore
updateStore store name value =
    Dict.insert name value store
