module Main exposing (main)

import Html exposing (Html)
import Model.Main exposing (Model, init)
import Msg.Main exposing (Msg)
import Update.Main exposing (updateWithCmd)
import View.Main exposing (view)
import Subs exposing (subscriptions)


main : Program Int Model Msg
main =
    Html.programWithFlags
        { init = init
        , view = view
        , update = updateWithCmd
        , subscriptions = subscriptions
        }
