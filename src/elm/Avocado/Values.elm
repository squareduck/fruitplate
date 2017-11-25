module Avocado.Values exposing (..)

import Parser
    exposing
        ( Parser
        , (|.)
        , (|=)
        , delayedCommit
        , lazy
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
    succeed ListValue
        |. symbol "["
        |. spaces
        |= oneOf
            [ listIntValue
            , listStringValue
            , lazy (\_ -> listListValue)
            ]
        |. spaces
        |. symbol "]"


listListValue : Parser (List Value)
listListValue =
    succeed identity
        |= andThen (\l -> listAccumulator [ l ]) listValue


listAccumulator : List Value -> Parser (List Value)
listAccumulator revValues =
    oneOf
        [ nextListValue
            |> andThen (\l -> listAccumulator (l :: revValues))
        , succeed (List.reverse revValues)
        ]


nextListValue : Parser Value
nextListValue =
    delayedCommit spaces <|
        succeed identity
            |. symbol ","
            |. spaces
            |= lazy (\_ -> listValue)


listIntValue : Parser (List Value)
listIntValue =
    succeed identity
        |= andThen (\n -> intAccumulator [ n ]) intValue


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


listStringValue : Parser (List Value)
listStringValue =
    succeed identity
        |= andThen (\n -> stringAccumulator [ n ]) stringValue


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
