module Avocado.Values exposing (..)

import Parser
    exposing
        ( Parser
        , (|.)
        , (|=)
        , delayedCommit
        , andThen
        , succeed
        , oneOf
        , symbol
        , int
        , float
        , keyword
        , end
        , keep
        , ignore
        , zeroOrMore
        )
import Data.ValueStore exposing (ValueStore, Value(..), registerValue)
import Avocado.Primitives exposing (spaces, any, valid_string)


-- Typed


typedValue : Parser Value
typedValue =
    delayedCommit (symbol ":") <|
        succeed identity
            |. spaces
            |= oneOf
                [ typedIntValue
                , typedStringValue
                ]


inferredValue : Parser Value
inferredValue =
    delayedCommit (symbol "=") <|
        succeed identity
            |. spaces
            |= oneOf
                [ intValue
                , stringValue
                , listValue
                ]



-- Int


intValue : Parser Value
intValue =
    succeed IntValue
        |= int


typedIntValue : Parser Value
typedIntValue =
    succeed IntValue
        |. keyword "Int"
        |. spaces
        |. symbol "="
        |. spaces
        |= int



-- String


stringValue : Parser Value
stringValue =
    succeed StringValue
        |= valid_string


typedStringValue : Parser Value
typedStringValue =
    succeed StringValue
        |. keyword "String"
        |. spaces
        |. symbol "="
        |. spaces
        |= valid_string



-- List


listValue : Parser Value
listValue =
    delayedCommit (symbol "[") <|
        succeed identity
            |. spaces
            |= oneOf
                [ listIntValue
                , listStringValue
                ]


listIntValue : Parser Value
listIntValue =
    succeed ListValue
        |= andThen (\n -> intAccumulator [ n ]) intValue
        |. spaces
        |. symbol "]"


intAccumulator : List Value -> Parser (List Value)
intAccumulator revValues =
    oneOf
        [ nextIntValue
            |> andThen (\n -> intAccumulator (n :: revValues))
        , succeed (List.reverse revValues)
        ]


nextIntValue : Parser Value
nextIntValue =
    delayedCommit spaces <|
        succeed IntValue
            |. symbol ","
            |. spaces
            |= int


listStringValue : Parser Value
listStringValue =
    succeed ListValue
        |= andThen (\n -> stringAccumulator [ n ]) stringValue
        |. spaces
        |. symbol "]"


stringAccumulator : List Value -> Parser (List Value)
stringAccumulator revValues =
    oneOf
        [ nextStringValue
            |> andThen (\n -> stringAccumulator (n :: revValues))
        , succeed (List.reverse revValues)
        ]


nextStringValue : Parser Value
nextStringValue =
    delayedCommit spaces <|
        succeed StringValue
            |. symbol ","
            |. spaces
            |= valid_string
