module Data.ValueStoreTest exposing (..)

import Test exposing (..)
import Expect exposing (Expectation)
import Dict exposing (Dict)
import Data.ValueStore exposing (emptyStore, registerValue, Value(..))


suite : Test
suite =
    describe "ValueStore"
        [ describe "emptyStore"
            [ test "creates empty ValueStore" <|
                \_ ->
                    let
                        store =
                            emptyStore
                    in
                        store
                            |> Expect.equal Dict.empty
            ]
        , describe "registerValue"
            [ test "registers value in the store" <|
                \_ ->
                    let
                        value =
                            IntValue 1

                        store =
                            registerValue "i1" value emptyStore
                    in
                        (Dict.get "i1" store)
                            |> Expect.equal (Just value)
            ]
        ]
