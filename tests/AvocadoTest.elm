module AvocadoTest exposing (..)

import Test exposing (..)
import Expect exposing (Expectation)
import Parser exposing (Parser)
import Avocado exposing (ParsedValue, value, parseLine, toStoreValue)
import Data.ValueStore exposing (Value(..))


suite : Test
suite =
    describe "Avocado"
        [ describe "parseLine"
            [ test "parses 'num: Int = 123' into ('num', IntValue(123))" <|
                \_ ->
                    let
                        result =
                            parseLine "num: Int = 123"
                    in
                        Expect.equal result (Ok ( "num", IntValue 123 ))
            ]
        , describe "toStoreValue"
            [ test "Returns IntValue from correct ParsedValue" <|
                \_ ->
                    let
                        value =
                            toStoreValue correctParsedInt
                    in
                        value
                            |> Expect.equal (Ok (IntValue 123))
            , test "Returns Err from wrong ParsedValue" <|
                \_ ->
                    let
                        value =
                            toStoreValue wrongParsedInt
                    in
                        Expect.err value
            ]
        , describe "value"
            [ test "parses 'num: Int = 123' into ParsedValue" <|
                \_ ->
                    let
                        result =
                            Parser.run value "num: Int = 123"
                    in
                        Expect.equal result
                            (Ok
                                { name = "num"
                                , dataType = "Int"
                                , content = "123"
                                }
                            )
            ]
        ]


correctParsedInt : ParsedValue
correctParsedInt =
    { name = "myint"
    , dataType = "Int"
    , content = "123"
    }


wrongParsedInt : ParsedValue
wrongParsedInt =
    { name = "myint"
    , dataType = "Int"
    , content = "wrong"
    }
