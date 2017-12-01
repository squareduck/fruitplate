module Data.ValueStore
    exposing
        ( ValueStore
        , Value(..)
        , emptyStore
        , registerValue
        , typeString
        , contentTypeString
        )

import Dict exposing (Dict)


type Value
    = NumberValue Float
    | StringValue String
    | BoolValue Bool
      -- ( content typestring, value )
    | ListValue ( String, List Value )


type alias ValueStore =
    Dict String Value


emptyStore : ValueStore
emptyStore =
    Dict.empty


registerValue : String -> Value -> ValueStore -> ValueStore
registerValue name value store =
    Dict.insert name value store


isBasicValue : Value -> Bool
isBasicValue value =
    case value of
        ListValue _ ->
            False

        _ ->
            True


typeString : Value -> String
typeString value =
    case value of
        NumberValue _ ->
            "Number"

        StringValue _ ->
            "String"

        BoolValue _ ->
            "Bool"

        ListValue ( default, content ) ->
            contentTypeString default content


contentTypeString : String -> List Value -> String
contentTypeString default content =
    let
        firstElement =
            List.head content
    in
        case firstElement of
            Just element ->
                "List(" ++ typeString element ++ ")"

            Nothing ->
                "List(" ++ default ++ ")"
