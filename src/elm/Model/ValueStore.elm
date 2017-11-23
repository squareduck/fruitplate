module Model.ValueStore exposing (..)

import Data.ValueStore exposing (ValueStore, emptyStore)
import Avocado exposing (parseLine)


type alias Model =
    { input : String
    , error : String
    , store : ValueStore
    }


evaluateInput : Model -> Model
evaluateInput model =
    case parseLine model.input model.store of
        Ok store ->
            { model | store = store, error = "", input = "" }

        Err msg ->
            { model | error = msg }


initialModel : Model
initialModel =
    { input = "num: Int = 123"
    , error = ""
    , store = emptyStore
    }
