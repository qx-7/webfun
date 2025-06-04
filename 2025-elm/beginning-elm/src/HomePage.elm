module HomePage exposing (main)

import Html exposing (..)
import Html.Attributes exposing (..)



-- single line comment
{-
   multi line comment
-}
{--
    smarter multi line comment!
    shrimply add a right curly brace to the above to toggle comment
    so that the closing tag is itself treated as a single line comment!!
    like so:
--}
{--
    -- not executed
--}


{--}
-- executed
--}


view model =
    div [ class "jumbotron" ]
        [ h1 [] [ text "Welcome to Dunder Mifflin!" ]
        , p []
            [ text "Dunder Mifflin Inc. (stock symbol "
            , strong [] [ text "DMI" ]
            , text <|
                """) is a micro-cap regional paper and office
                supply distributor with an emphasis on servicing
                small-business clients.
                """
            ]
        ]


main =
    view "dummy model"
