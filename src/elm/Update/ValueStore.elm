module Update.ValueStore exposing (..)

import Model.ValueStore exposing (Model, evaluateInput)
import Msg.ValueStore as ValueStore exposing (..)


update : ValueStore.Msg -> Model -> Model
update msg model =
    case msg of
        UpdateInput text ->
            { model | input = text }

        KeyDown keyCode ->
            case keyCode of
                13 ->
                    evaluateInput model

                _ ->
                    model
