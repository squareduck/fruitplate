module View.ValueStore exposing (..)

import Element exposing (..)
import Element.Attributes exposing (..)
import Element.Input as Input
import Model.ValueStore exposing (Model)
import Msg.Main as Main exposing (..)
import Msg.ValueStore exposing (..)
import Styling exposing (Styles(..))


valueStore : Model -> Element Styles variation Main.Msg
valueStore model =
    column MetaPage
        [ padding 10 ]
        [ Input.text
            None
            []
            { onChange = (MsgForValueStore << UpdateInput)
            , value = model.input
            , label = Input.hiddenLabel "Input"
            , options = []
            }
        , text model.input
        ]
