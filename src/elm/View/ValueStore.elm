module View.ValueStore exposing (valueStore)

import Html.Styled exposing (Html, Attribute, div, text, input)
import Html.Styled.Events exposing (onInput, on, keyCode)
import Html.Styled.Attributes exposing (value)
import Msg.Main as Main exposing (Msg(..))
import Msg.ValueStore exposing (Msg(..))
import Model.ValueStore exposing (Model)
import Json.Decode as Json


onKeyDown : (Int -> msg) -> Attribute msg
onKeyDown tagger =
    on "keydown" (Json.map tagger keyCode)


valueStore : Model -> Html Main.Msg
valueStore model =
    div []
        [ inputField model.input
        , text model.input
        , text model.error
        ]


inputField : String -> Html Main.Msg
inputField text =
    input
        [ value text
        , onInput (MsgForValueStore << UpdateInput)
        , onKeyDown (MsgForValueStore << KeyDown)
        ]
        []
