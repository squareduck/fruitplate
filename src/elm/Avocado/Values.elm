module Avocado.Values exposing (..)

import Parser exposing (Parser, (|.), (|=), delayedCommit, succeed, oneOf, symbol, int, float, keyword, end, keep, ignore, zeroOrMore)
import Data.ValueStore exposing (ValueStore, Value(..), registerValue)
import Avocado.Primitives exposing (spaces, any, valid_string)


-- Typed


typedValue : Parser Value
typedValue =
    delayedCommit (keyword ":") <|
        succeed identity
            |. spaces
            |= oneOf
                [ typedIntValue
                , typedStringValue
                ]


inferredValue : Parser Value
inferredValue =
    delayedCommit (keyword "=") <|
        succeed identity
            |. spaces
            |= oneOf
                [ intValue
                , stringValue
                ]



-- Int


intValue : Parser Value
intValue =
    succeed IntValue
        |= int
        |. spaces
        |. end


typedIntValue : Parser Value
typedIntValue =
    succeed IntValue
        |. keyword "Int"
        |. spaces
        |. keyword "="
        |. spaces
        |= int
        |. spaces
        |. end



-- String


stringValue : Parser Value
stringValue =
    succeed StringValue
        |. symbol "\""
        |= valid_string
        |. symbol "\""
        |. spaces
        |. end


typedStringValue : Parser Value
typedStringValue =
    succeed StringValue
        |. keyword "String"
        |. spaces
        |. keyword "="
        |. spaces
        |. symbol "\""
        |= valid_string
        |. symbol "\""
        |. spaces
        |. end
