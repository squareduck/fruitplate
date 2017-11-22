module Msg.Main exposing (..)

import Msg.ValueStore as ValueStore


type Msg
    = NoOp
    | MsgForValueStore ValueStore.Msg
