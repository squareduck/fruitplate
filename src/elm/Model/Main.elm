module Model.Main exposing (..)

import Model.ValueStore as ValueStore
import Msg.Main exposing (Msg)


type alias Model =
    { valueStore : ValueStore.Model
    }


initialModel : Model
initialModel =
    { valueStore = ValueStore.initialModel
    }


init : Int -> ( Model, Cmd Msg )
init seed =
    ( initialModel, Cmd.none )
