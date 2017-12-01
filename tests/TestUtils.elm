module TestUtils exposing (..)

import Data.ValueStore exposing (..)
import Test exposing (..)


withValidStringLiterals : (( String, String ) -> Test) -> Test
withValidStringLiterals test =
    concat (List.map test validStringLiterals)


validStringLiterals : List ( String, String )
validStringLiterals =
    [ ( "\"\"", "" )
    , ( "\"test\"", "test" )
    , ( "\"\\\"test\\\"\"", "\"test\"" )
    ]


withValidValuesAndTypestrings : (( Value, String ) -> Test) -> Test
withValidValuesAndTypestrings test =
    concat (List.map test validValuesWithTypestrings)


validValuesWithTypestrings : List ( Value, String )
validValuesWithTypestrings =
    [ ( NumberValue 1, "Number" )
    , ( StringValue "test", "String" )
    , ( BoolValue True, "Bool" )
    , ( ListValue ( "Number", [ NumberValue 1, NumberValue 2 ] ), "List(Number)" )
    ]
