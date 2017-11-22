module View.Main exposing (..)

import Html exposing (Html)
import Element exposing (Element)
import Styling exposing (stylesheet)
import Model.Main exposing (Model)
import Msg.Main exposing (..)
import View.ValueStore as ValueStoreView


view : Model -> Html Msg
view model =
    Element.layout stylesheet <|
        ValueStoreView.valueStore model.valueStore
