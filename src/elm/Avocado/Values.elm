module Avocado.Values
    exposing
        ( value
        , typedValue
        )

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
        , fail
        , map
        , repeat
        )
import Avocado.Primitives exposing (spaces)
import Data.ValueStore
    exposing
        ( ValueStore
        , Value(..)
        , registerValue
        , typeString
        , contentTypeString
        )


-- Value


value : Parser Value
value =
    succeed identity
        |= oneOf
            [ numberValue
            , stringValue
            , boolValue
            , listValue
            ]


typedValue : Parser Value
typedValue =
    succeed identity
        |. symbol "<"
        |= oneOf
            [ typedNumberValue
            , typedStringValue
            , typedBoolValue
            ]



-- Bool


boolValue : Parser Value
boolValue =
    succeed BoolValue
        |= oneOf
            [ map (\_ -> True) (keyword "true")
            , map (\_ -> False) (keyword "false")
            ]


typedBoolValue : Parser Value
typedBoolValue =
    succeed BoolValue
        |. keyword "Bool"
        |. symbol ">"
        |= oneOf
            [ map (\_ -> True) (keyword "true")
            , map (\_ -> False) (keyword "false")
            ]



-- Number


numberValue : Parser Value
numberValue =
    succeed NumberValue
        |= oneOf
            [ float
            , negativeNumber
            ]


typedNumberValue : Parser Value
typedNumberValue =
    succeed identity
        |. keyword "Number"
        |. symbol ">"
        |= numberValue


negativeNumber : Parser Float
negativeNumber =
    succeed identity
        |. symbol "-"
        |= map (\f -> -f) float



-- String


stringValue : Parser Value
stringValue =
    succeed StringValue
        |. symbol "\""
        |= validString
        |. symbol "\""


typedStringValue : Parser Value
typedStringValue =
    succeed identity
        |. keyword "String"
        |. symbol ">"
        |= stringValue


validString : Parser String
validString =
    map (String.join "") (repeat zeroOrMore validStringChar)


validStringChar : Parser String
validStringChar =
    oneOf
        [ keep (Parser.AtLeast 1) (\c -> c /= '"' && c /= '\\')
        , map (\_ -> "\"") (keyword "\\\"")
        , map (\_ -> "\\") (keyword "\\\\")
        ]



-- List


listValue : Parser Value
listValue =
    succeed constructListValue
        |. symbol "["
        |. spaces
        |= oneOf
            [ numberList
            , stringList
            , lazy (\_ -> subList)
            ]


constructListValue : List Value -> Value
constructListValue list =
    ListValue ( contentTypeString "" list, list )


subList : Parser (List Value)
subList =
    succeed identity
        |= andThen (\l -> (subListBuilder l [ l ])) listValue
        |. spaces
        |. symbol "]"


subListBuilder : Value -> List Value -> Parser (List Value)
subListBuilder firstElement sublist =
    let
        reference_typestring =
            case firstElement of
                ListValue ( ts, _ ) ->
                    ts

                _ ->
                    ""
    in
        oneOf
            [ andThen
                (\value ->
                    case value of
                        ListValue ( typestring, _ ) ->
                            if typestring == reference_typestring then
                                subListBuilder firstElement (value :: sublist)
                            else
                                failList "Bad type"

                        _ ->
                            failList "Bad type"
                )
                nextList
            , succeed (List.reverse sublist)
            ]


failList : String -> Parser (List Value)
failList reason =
    fail reason


nextList : Parser Value
nextList =
    delayedCommit spaces <|
        succeed identity
            |. symbol ","
            |. spaces
            |= listValue


numberList : Parser (List Value)
numberList =
    succeed identity
        |= andThen (\n -> numberListBuilder [ n ]) numberValue
        |. spaces
        |. symbol "]"


numberListBuilder : List Value -> Parser (List Value)
numberListBuilder numbers =
    oneOf
        [ andThen (\n -> numberListBuilder (n :: numbers)) nextNumber
        , succeed (List.reverse numbers)
        ]


nextNumber : Parser Value
nextNumber =
    delayedCommit spaces <|
        succeed identity
            |. symbol ","
            |. spaces
            |= numberValue


stringList : Parser (List Value)
stringList =
    succeed identity
        |= andThen (\n -> stringListBuilder [ n ]) stringValue
        |. spaces
        |. symbol "]"


stringListBuilder : List Value -> Parser (List Value)
stringListBuilder strings =
    oneOf
        [ andThen (\n -> stringListBuilder (n :: strings)) nextString
        , succeed (List.reverse strings)
        ]


nextString : Parser Value
nextString =
    delayedCommit spaces <|
        succeed identity
            |. symbol ","
            |. spaces
            |= stringValue
