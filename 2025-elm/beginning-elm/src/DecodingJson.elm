module DecodingJson exposing (main)

import Browser
import Html exposing (..)
import Html.Attributes exposing (href)
import Html.Events exposing (onClick)
import Http
import Json.Decode as Decode exposing (Decoder, int, list, string)
import Json.Decode.Pipeline exposing (required)
import RemoteData exposing (WebData)


type alias Post =
    { id : Int
    , title : String
    , authorName : String
    , authorUrl : String
    }


type alias Model =
    { posts : WebData (List Post)
    }


type Msg
    = FetchPosts
    | DataReceived (WebData (List Post))


view : Model -> Html Msg
view model =
    div []
        [ button [ onClick FetchPosts ]
            [ text "Refresh posts" ]
        , viewPostsOrError model
        ]


viewPostsOrError : Model -> Html Msg
viewPostsOrError model =
    case model.posts of
        RemoteData.NotAsked ->
            text ""

        RemoteData.Loading ->
            h3 [] [ text "Loading..." ]

        RemoteData.Success posts ->
            viewPosts posts

        RemoteData.Failure httpError ->
            viewError (buildErrorMessage httpError)


viewError : String -> Html Msg
viewError errorMessage =
    let
        errorHeading =
            "Couldn't fetch data at this time."
    in
    div []
        [ h3 [] [ text errorHeading ]
        , text ("Error: " ++ errorMessage)
        ]


viewPosts : List Post -> Html Msg
viewPosts posts =
    div []
        [ h3 [] [ text "Posts" ]
        , table []
            ([ viewTableHeader ] ++ List.map viewPost posts)
        ]


viewTableHeader : Html Msg
viewTableHeader =
    tr []
        [ th []
            [ text "ID" ]
        , th []
            [ text "Title" ]
        , th []
            [ text "Author" ]
        ]


viewPost : Post -> Html Msg
viewPost post =
    tr []
        [ td []
            [ text (String.fromInt post.id) ]
        , td []
            [ text post.title ]
        , td []
            [ a [ href post.authorUrl ] [ text post.authorName ] ]
        ]


postDecoder : Decoder Post
postDecoder =
    Decode.succeed Post
        |> required "id" int
        |> required "title" string
        |> required "authorName" string
        |> required "authorUrl" string



{--
--if using Json.Decode (vs Json.Decode.Pipeline), here is how:

postDecoder : Decoder Post
postDecoder =
    map4 Post
        (field "id" int)
        (field "title" string)
        (at [ "author", "name" ] string)
        (at [ "author", "url" ] string)
--}


fetchPosts : Cmd Msg
fetchPosts =
    Http.get
        { url = "http://localhost:5019/posts"
        , expect =
            list postDecoder
                |> Http.expectJson (RemoteData.fromResult >> DataReceived)
        }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        FetchPosts ->
            ( { model | posts = RemoteData.Loading }, fetchPosts )

        DataReceived response ->
            ( { model | posts = response }, Cmd.none )


buildErrorMessage : Http.Error -> String
buildErrorMessage httpError =
    case httpError of
        Http.BadUrl message ->
            message

        Http.Timeout ->
            "Timeout. Server is taking too long to respond. Please try again later."

        Http.NetworkError ->
            "Network error. Unable to reach server."

        Http.BadStatus statusCode ->
            "Bad status. Failed with status code: " ++ String.fromInt statusCode

        Http.BadBody message ->
            message


init : () -> ( Model, Cmd Msg )
init _ =
    ( { posts = RemoteData.Loading }, fetchPosts )


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }
