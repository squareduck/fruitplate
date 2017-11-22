module Data.ValueStore
    exposing
        ( ValueStore
        , Value(..)
        , emptyStore
        , registerValue
        )

import Dict exposing (Dict)


type Value
    = IntValue Int
    | StringValue String
    | EmptyValue


type alias ValueStore =
    Dict String Value


emptyStore =
    Dict.empty


registerValue : String -> Value -> ValueStore -> ValueStore
registerValue name value store =
    Dict.insert name value store