module Model.ValueStore exposing (..)

import Data.ValueStore exposing (ValueStore, emptyStore)
import Avocado.Main exposing (parseExpression)


type alias Model =
    { input : String
    , error : String
    , store : ValueStore
    }


evaluateInput : Model -> Model
evaluateInput model =
    case parseExpression model.input model.store of
        Ok store ->
            { model | store = store, error = "", input = "" }

        Err msg ->
            { model | error = toString msg.problem }


initialModel : Model
initialModel =
    { input = "num: Int = 123"
    , error = ""
    , store = emptyStore
    }
