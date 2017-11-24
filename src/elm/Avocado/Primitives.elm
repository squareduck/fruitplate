module Avocado.Primitives exposing (..)

import Parser exposing (..)
import Char


-- General


spaces : Parser ()
spaces =
    ignore zeroOrMore (\c -> c == ' ')


any : Parser String
any =
    keep zeroOrMore (\c -> True)



-- Language


identifier : Parser String
identifier =
    succeed (++)
        |= keep zeroOrMore (\c -> Char.isUpper c || Char.isLower c || c == '_')
        |= keep zeroOrMore (\c -> Char.isUpper c || Char.isLower c || c == '_' || Char.isDigit c)


valid_string : Parser String
valid_string =
    keep zeroOrMore (\c -> c /= '"')
