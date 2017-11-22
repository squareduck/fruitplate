module Styling exposing (Styles(..), stylesheet)

import Style exposing (Style)


type Styles
    = None
    | MetaPage


stylesheet =
    Style.styleSheet
        [ Style.style None []
        , Style.style MetaPage []
        ]
