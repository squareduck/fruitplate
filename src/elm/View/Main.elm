module View.Main exposing (..)

import Html.Styled exposing (Html, Attribute, div, text, input)
import Model.Main exposing (Model)
import Msg.Main exposing (..)
import View.ValueStore as ValueStoreView


view : Model -> Html Msg
view model =
    ValueStoreView.valueStore model.valueStore
