module Subs exposing (subscriptions)

import Model.Main exposing (Model)
import Msg.Main exposing (Msg)


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
