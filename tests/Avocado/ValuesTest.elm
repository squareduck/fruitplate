module Avocado.ValuesTest exposing (..)

import Test exposing (..)
import Expect exposing (Expectation)
import Dict exposing (Dict)
import Avocado exposing (parseExpression)
import Data.ValueStore exposing (emptyStore, Value(..))


suite : Test
suite =
    describe "Parsing value assignment"
        [ describe "Annotated value assignment"
            [ test "'num: Int = 123' puts value into store" <|
                \_ ->
                    let
                        store =
                            emptyStore

                        result =
                            case parseExpression "num: Int = 123" store of
                                Ok new_store ->
                                    new_store

                                Err err ->
                                    store
                    in
                        Expect.equal (Dict.get "num" result) (Just (IntValue 123))
            ]
        , describe "Inferred value assignment"
            [ test "'num = 123' puts value into store" <|
                \_ ->
                    let
                        store =
                            emptyStore

                        result =
                            case parseExpression "num = 123" store of
                                Ok new_store ->
                                    new_store

                                Err err ->
                                    store
                    in
                        Expect.equal (Dict.get "num" result) (Just (IntValue 123))
            ]
        ]
