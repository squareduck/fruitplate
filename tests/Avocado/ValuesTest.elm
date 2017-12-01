module Avocado.ValuesTest exposing (..)

import Test exposing (..)
import Expect exposing (Expectation)
import Fuzz exposing (string, float)
import Parser
import TestUtils exposing (..)
import Avocado.Values
    exposing
        ( value
        , typedValue
        )
import Data.ValueStore exposing (emptyStore, Value(..))


suite : Test
suite =
    describe "Avocado Primitives"
        [ describe "Bool values"
            [ test "parses true Bool value" <|
                \_ ->
                    (Parser.run value "true")
                        |> Expect.equal
                            (Ok (BoolValue True))
            , test "parses false Bool value" <|
                \_ ->
                    (Parser.run value "false")
                        |> Expect.equal
                            (Ok (BoolValue False))
            , test "parses typed true Bool value" <|
                \_ ->
                    (Parser.run typedValue ("<Bool>" ++ "true"))
                        |> Expect.equal
                            (Ok (BoolValue True))
            , test "parses typed false Bool value" <|
                \_ ->
                    (Parser.run typedValue ("<Bool>" ++ "false"))
                        |> Expect.equal
                            (Ok (BoolValue False))
            ]
        , describe "Number values"
            [ fuzz float "parses Number values" <|
                \number ->
                    (Parser.run value (toString number))
                        |> Expect.equal
                            (Ok (NumberValue number))
            , fuzz float "parses typed Number values" <|
                \number ->
                    (Parser.run typedValue ("<Number>" ++ toString number))
                        |> Expect.equal
                            (Ok (NumberValue number))
            ]
        , describe "String values"
            [ withValidStringLiterals
                (\( string, result ) ->
                    test ("parses String values: " ++ string) <|
                        \_ ->
                            (Parser.run value string)
                                |> Expect.equal
                                    (Ok (StringValue result))
                )
            , withValidStringLiterals
                (\( string, result ) ->
                    test ("parses typed String values: " ++ string) <|
                        \_ ->
                            (Parser.run typedValue ("<String>" ++ string))
                                |> Expect.equal
                                    (Ok (StringValue result))
                )
            ]
        ]
