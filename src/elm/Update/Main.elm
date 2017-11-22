module Update.Main exposing (..)

import Model.Main exposing (Model, initialModel)
import Msg.Main exposing (..)
import Update.ValueStore as ValueStore


update : Msg -> Model -> Model
update msg model =
    case msg of
        NoOp ->
            model

        MsgForValueStore subMsg ->
            { model | valueStore = ValueStore.update subMsg model.valueStore }


updateWithCmd : Msg -> Model -> ( Model, Cmd msg )
updateWithCmd msg model =
    ( update msg model, Cmd.none )
