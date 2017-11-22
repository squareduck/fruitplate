module Update.ValueStore exposing (..)

import Model.ValueStore exposing (Model)
import Msg.Main as Main exposing (..)
import Msg.ValueStore as ValueStore exposing (..)


update : ValueStore.Msg -> Model -> Model
update msg model =
    case msg of
        UpdateInput text ->
            { model | input = text }
