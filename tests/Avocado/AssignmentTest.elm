module Avocado.AssignmentTest exposing (..)

import Test exposing (..)
import Expect exposing (Expectation)
import Fuzz exposing (float)
import Dict exposing (Dict)
import Parser
import TestUtils exposing (..)
import Avocado.Assignment exposing (assignment)
import Data.ValueStore exposing (emptyStore, Value(..))


suite : Test
suite =
    describe "Avocado assignments"
        [ describe "assignment"
            [ fuzz float "parses 'num = 123'" <|
                \number ->
                    let
                        store =
                            emptyStore

                        new_store =
                            case Parser.run (assignment store) ("num = " ++ (toString number)) of
                                Ok new_store ->
                                    new_store

                                Err err ->
                                    store
                    in
                        (Dict.get "num" new_store)
                            |> Expect.equal
                                (Just (NumberValue number))
            , fuzz float "parses 'num = <Int>123'" <|
                \number ->
                    let
                        store =
                            emptyStore

                        new_store =
                            case Parser.run (assignment store) ("num = <Number>" ++ (toString number)) of
                                Ok new_store ->
                                    new_store

                                Err err ->
                                    store
                    in
                        (Dict.get "num" new_store)
                            |> Expect.equal
                                (Just (NumberValue number))
            , withValidStringLiterals
                (\( string, result ) ->
                    test ("parses str = " ++ string) <|
                        \_ ->
                            let
                                store =
                                    emptyStore

                                new_store =
                                    case Parser.run (assignment store) ("str = " ++ string) of
                                        Ok new_store ->
                                            new_store

                                        Err err ->
                                            store
                            in
                                (Dict.get "str" new_store)
                                    |> Expect.equal
                                        (Just (StringValue result))
                )
            , withValidStringLiterals
                (\( string, result ) ->
                    test ("parses str = <String>" ++ string) <|
                        \_ ->
                            let
                                store =
                                    emptyStore

                                new_store =
                                    case Parser.run (assignment store) ("str = <String>" ++ string) of
                                        Ok new_store ->
                                            new_store

                                        Err err ->
                                            store
                            in
                                (Dict.get "str" new_store)
                                    |> Expect.equal
                                        (Just (StringValue result))
                )
            ]
        ]
