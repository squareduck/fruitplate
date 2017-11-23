module Avocado exposing (..)

import Parser exposing (Parser, (|.), (|=), succeed, symbol, int, float, keyword, end, keep, ignore, zeroOrMore)
import Data.ValueStore exposing (ValueStore, Value(..), registerValue)
import Char


type alias ParsedValue =
    { name : String
    , dataType : String
    , content : String
    }


parseLine : String -> ValueStore -> Result String ValueStore
parseLine input store =
    case Parser.run value input of
        Ok parsed_value ->
            case toStoreValue parsed_value of
                Ok value ->
                    Ok (registerValue parsed_value.name value store)

                Err message ->
                    Err message

        Err message ->
            Err "Parser error"


toStoreValue : ParsedValue -> Result String Value
toStoreValue parsedValue =
    case parsedValue.dataType of
        "Int" ->
            case String.toInt parsedValue.content of
                Ok content ->
                    Ok (IntValue content)

                Err message ->
                    Err message

        dataType ->
            Err ("Type " ++ dataType ++ " is not supported.")


value : Parser ParsedValue
value =
    succeed ParsedValue
        |. spaces
        |= letters
        |. spaces
        |. symbol ":"
        |. spaces
        |= letters
        |. spaces
        |. symbol "="
        |. spaces
        |= any
        |. end


spaces : Parser ()
spaces =
    ignore zeroOrMore (\c -> c == ' ')


letters : Parser String
letters =
    keep zeroOrMore (\c -> Char.isUpper c || Char.isLower c)


any : Parser String
any =
    keep zeroOrMore (\c -> True)
