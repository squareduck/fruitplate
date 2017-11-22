module Model.ValueStore exposing (..)


type alias Model =
    { input : String
    }


initialModel : Model
initialModel =
    { input = "Test"
    }
