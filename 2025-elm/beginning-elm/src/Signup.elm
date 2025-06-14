module Signup exposing (..)

import Browser
import Css exposing (..)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)
import Html.Styled.Events exposing (onClick, onInput)
import VirtualDom


type alias User =
    { name : String
    , email : String
    , password : String
    , loggedIn : Bool
    }


initialModel : User
initialModel =
    { name = ""
    , email = ""
    , password = ""
    , loggedIn = False
    }


view : User -> Html Msg
view user =
    div []
        [ styledH1 [] [ text "Sign Up" ]
        , styledForm []
            [ div []
                [ text "Name"
                , styledInput
                    [ id "name"
                    , type_ "text"
                    , onInput SaveName
                    ]
                    []
                ]
            , div []
                [ text "Email"
                , styledInput
                    [ id "email"
                    , type_ "email"
                    , onInput SaveEmail
                    ]
                    []
                ]
            , div []
                [ text "Password"
                , styledInput
                    [ id "password"
                    , type_ "password"
                    , onInput SavePassword
                    ]
                    []
                ]
            , div []
                [ styledButton
                    [ type_ "submit"
                    , onClick Signup
                    ]
                    [ text "Create my account" ]
                ]
            ]
        ]


styledH1 : List (Attribute msg) -> List (Html msg) -> Html msg
styledH1 =
    styled Html.Styled.h1
        [ margin2 (rem 1) auto
        , minWidth fitContent
        , maxWidth fitContent
        ]


styledForm : List (Attribute msg) -> List (Html msg) -> Html msg
styledForm =
    styled Html.Styled.form
        [ displayFlex
        , flexFlow2 noWrap column
        , border3 (rem 0.2) dotted (hex "#000")
        , borderRadius (rem 1)
        , padding (rem 1)
        , backgroundColor (hex "#eee")
        , margin auto
        , maxWidth fitContent
        ]


styledInput : List (Attribute msg) -> List (Html msg) -> Html msg
styledInput =
    styled Html.Styled.input
        [ display block
        , padding (rem 0.5)
        , Css.width (rem 16)
        , margin auto
        ]


styledButton : List (Attribute msg) -> List (Html msg) -> Html msg
styledButton =
    styled Html.Styled.button
        [ display block
        , Css.width auto
        , margin2 (rem 1) auto
        , backgroundColor (hex "#b54")
        , color (hex "#fff")
        , padding (rem 1)
        , borderRadius (rem 1)
        , border3 (rem 0.15) solid (hex "#333")
        , fontSize larger
        ]


type Msg
    = SaveName String
    | SaveEmail String
    | SavePassword String
    | Signup


update : Msg -> User -> User
update message user =
    case message of
        SaveName name ->
            { user | name = name }

        SaveEmail email ->
            { user | email = email }

        SavePassword password ->
            { user | password = password }

        Signup ->
            { user | loggedIn = True }


main : Program () User Msg
main =
    Browser.sandbox
        { init = initialModel
        , view = view >> toUnstyled
        , update = update
        }
