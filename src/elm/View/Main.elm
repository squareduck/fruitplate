module View.Main exposing (..)

import Html.Styled exposing (Html, Attribute, div, text, input)
import Css exposing (..)
import Html.Styled.Attributes exposing (css)
import Model.Main exposing (Model)
import Msg.Main exposing (..)
import View.ValueStore as ValueStoreView


view : Model -> Html Msg
view model =
    div
        [ css
            [ fontFamilies [ "Helvetica", "Arial", "sans-serif" ]
            ]
        ]
        [ ValueStoreView.valueStore model.valueStore
        ]
