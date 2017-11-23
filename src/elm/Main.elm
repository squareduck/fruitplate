module Main exposing (main)

import Html exposing (Html)
import Html.Styled exposing (toUnstyled)
import Model.Main exposing (Model, init)
import Update.Main exposing (updateWithCmd)
import Msg.Main exposing (Msg)
import View.Main exposing (view)
import Subs exposing (subscriptions)


main : Program Int Model Msg
main =
    Html.programWithFlags
        { init = init
        , view = view >> toUnstyled
        , update = updateWithCmd
        , subscriptions = subscriptions
        }
