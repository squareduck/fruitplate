module View.ValueStore exposing (valueStore)

import Dict exposing (Dict)
import Css exposing (..)
import Html.Styled exposing (Html, Attribute, div, text, input)
import Html.Styled.Events exposing (onInput, on, keyCode)
import Html.Styled.Attributes exposing (value, css)
import Msg.Main as Main exposing (Msg(..))
import Msg.ValueStore exposing (Msg(..))
import Model.ValueStore exposing (Model)
import Data.ValueStore exposing (ValueStore, Value(..))
import Json.Decode as Json
import Fuzzy exposing (match)


onKeyUp : (Int -> msg) -> Attribute msg
onKeyUp tagger =
    on "keyup" (Json.map tagger keyCode)


valueStore : Model -> Html Main.Msg
valueStore model =
    div
        [ css
            [ displayFlex
            , flexDirection column
            , height (pct 100)
            , padding (px 20)
            , backgroundColor (hex "f8f8f8")
            ]
        ]
        [ inputField model.input
        , errorMessage model.error
        , inspector model.input model.store
        ]


inputField : String -> Html Main.Msg
inputField text =
    input
        [ value text
        , onInput (MsgForValueStore << UpdateInput)
        , onKeyUp (MsgForValueStore << KeyDown)
        , css
            [ padding (px 10)
            , borderWidth (px 1)
            , borderStyle solid
            , borderRadius (px 2)
            , borderColor (hex "a8a8a8")
            , outline zero
            , fontSize (em 1)
            ]
        ]
        []


errorMessage : String -> Html Main.Msg
errorMessage error =
    if String.isEmpty error then
        div [] []
    else
        div
            [ css
                [ padding (px 10)
                , marginTop (px 20)
                , borderWidth (px 1)
                , borderStyle solid
                , borderRadius (px 2)
                , borderColor (hex "a8a8a8")
                , backgroundColor (hex "ffe8e8")
                ]
            ]
            [ text error ]


inspector : String -> ValueStore -> Html Main.Msg
inspector input store =
    div
        [ css
            [ displayFlex
            , flexDirection column
            , marginTop (px 20)
            , borderTopWidth (px 5)
            , borderTopStyle solid
            , borderColor (hex "c9c9c9")
            ]
        ]
        (store
            |> fuzzySort input
            |> List.map valueBlock
        )


fuzzySort : String -> ValueStore -> List ( String, Data.ValueStore.Value )
fuzzySort text store =
    let
        simpleMatch config separators needle hay =
            match config separators needle hay |> .score

        scoredValues =
            store
                |> Dict.toList
                |> List.map (\( name, value ) -> ( (simpleMatch [] [] text name), name, value ))
                |> List.sortBy (\( score, name, value ) -> score)
    in
        scoredValues
            |> List.map (\( _, name, value ) -> ( name, value ))


valueBlockColor : Data.ValueStore.Value -> Css.Color
valueBlockColor value =
    case value of
        IntValue _ ->
            hex "E3EEF5"

        StringValue _ ->
            hex "E0DCEF"

        ListValue _ ->
            hex "EFEEDC"


valueToStringTuple : Data.ValueStore.Value -> ( String, String )
valueToStringTuple value =
    case value of
        IntValue content ->
            ( "Int", toString content )

        StringValue content ->
            ( "String", content )

        ListValue content ->
            ( "List", toString content )


valueBlock : ( String, Data.ValueStore.Value ) -> Html Main.Msg
valueBlock ( name, value ) =
    let
        ( value_type, value_content ) =
            valueToStringTuple (value)
    in
        div
            [ css
                [ displayFlex
                , padding (px 10)
                , borderTopWidth (px 0)
                , borderBottomWidth (px 1)
                , borderLeftWidth (px 1)
                , borderRightWidth (px 1)
                , borderStyle solid
                , borderColor (hex "c9c9c9")
                , backgroundColor (valueBlockColor value)
                ]
            ]
            [ div [] [ text name ]
            , div [ css [ marginLeft (em 0), opacity (num 0.3) ] ] [ text (" : " ++ value_type) ]
            , div [ css [ marginLeft auto ] ] [ text value_content ]
            ]
