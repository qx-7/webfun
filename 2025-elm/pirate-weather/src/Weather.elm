module Weather exposing (capitalizeFirstLetter, main)

import Browser
import Css exposing (..)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (for, id, name, placeholder, type_, value)
import Html.Styled.Events exposing (onClick, onInput)
import Http
import Json.Decode as Decode exposing (Decoder, decodeString, float, int, list, string)
import Json.Decode.Pipeline exposing (optional, optionalAt, required, requiredAt)
import RemoteData exposing (WebData)
import VirtualDom


pirateVersion : String
pirateVersion =
    "0.1"


type alias Weather =
    { time : String
    , temperature : Float
    , humidity : Int
    , weatherCode : Int
    }


type alias Model =
    { locationCoords : ( Float, Float )
    , currentWeather : WebData Weather
    }


type Msg
    = CheckWeather
    | UpdateLatitude Float
    | UpdateLongitude Float
    | DataReceived (WebData Weather)
    | DoNothing


floatFromString : String -> Maybe Float
floatFromString string =
    let
        result =
            string
                |> decodeString Decode.float
    in
    case result of
        Ok float ->
            Just float

        Err _ ->
            Nothing


updateAxis : Int -> String -> Msg
updateAxis axisNumber newCoordString =
    let
        newCoordFloat =
            floatFromString newCoordString
    in
    case newCoordFloat of
        Just float ->
            case axisNumber of
                0 ->
                    UpdateLatitude float

                1 ->
                    UpdateLongitude float

                _ ->
                    DoNothing

        Nothing ->
            DoNothing


inputCoordinateFromModel : Model -> Int -> Html Msg
inputCoordinateFromModel model axisNumber =
    let
        axisName =
            case axisNumber of
                0 ->
                    "latitude"

                1 ->
                    "longitude"

                _ ->
                    "unknown"

        axisId =
            axisName
    in
    div []
        [ styledLabel [ for axisId ] [ text (capitalizeFirstLetter axisName) ]
        , styledInput
            [ type_ "text"
            , name axisName
            , id axisId
            , placeholder "e.g. -12.3"
            , value (extractCoordFromModel model axisNumber)
            , onInput (updateAxis axisNumber)
            ]
            []
        ]


styledLabel =
    styled Html.Styled.label
        [ margin (rem 0.5)
        ]


capitalizeFirstLetter : String -> String
capitalizeFirstLetter string =
    if string |> String.isEmpty then
        ""

    else
        String.concat
            [ String.left 1 string
                |> String.toUpper
            , String.dropLeft 1 string
            ]


extractCoordFromModel : Model -> Int -> String
extractCoordFromModel model axisNumber =
    case axisNumber of
        0 ->
            model.locationCoords
                |> Tuple.first
                |> String.fromFloat

        1 ->
            model.locationCoords
                |> Tuple.second
                |> String.fromFloat

        _ ->
            "0.0"


styledButton =
    styled Html.Styled.button
        [ padding (rem 0.5)
        ]


styledInput =
    styled Html.Styled.input
        [ padding (rem 0.5)
        ]


styledTable =
    styled Html.Styled.table
        [ border3 (px 3) solid (hex "000")
        , borderCollapse collapse
        ]


styledTd : List (Attribute msg) -> List (Html msg) -> Html msg
styledTd =
    styled Html.Styled.td
        [ border2 (px 1) solid
        , padding (rem 0.5)
        ]


styledTh =
    styled Html.Styled.th
        [ border2 (px 1) solid
        , padding (rem 0.5)
        ]


view : Model -> VirtualDom.Node Msg
view model =
    div []
        [ h1 [] [ text ("Pirate Weather v" ++ pirateVersion) ]
        , p [] [ text "Be it stormy or be it clear, now ye've got a pirate here! Yar!" ]
        , p [] [ text "Published 2025-06-15 by Mel Meadwell; available under AGPL-3.0-or-later" ]
        , p []
            [ text
                ("This is a strictly functional prototype!"
                    ++ " It'll look prettier very soon."
                    ++ " I had to teach myself Elm (which is a joy btw!)"
                    ++ " and also figure out how to make a web app first. lol."
                    ++ " Anyway, soon I'll have a real life PIRATE here to deliver the weather for me."
                    ++ " Check back often!"
                )
            ]
        , form []
            [ p []
                [ strong [] [ text "To use Pirate Weather:" ]
                , text " Input latitude and longitude coordinates. Note that negatives and decimals "
                , strong [] [ text "are" ]
                , text " allowed! They're just tricky to input on some browsers, sorgy. xp"
                , text " Accessibility will be a key design focus for the eventual v1.0 release,"
                , text " but for now, just muck around a bit till it works. :)"
                ]
            , inputCoordinateFromModel model 0
            , inputCoordinateFromModel model 1
            , styledButton
                [ onClick CheckWeather
                , type_ "button"
                ]
                [ text "check weather" ]
            ]
        , viewWeatherOrError model
        ]
        |> toUnstyled


viewWeatherOrError : Model -> Html Msg
viewWeatherOrError model =
    case model.currentWeather of
        RemoteData.NotAsked ->
            text ""

        RemoteData.Loading ->
            p [] [ text "Loading..." ]

        RemoteData.Success weather ->
            viewWeather weather

        RemoteData.Failure httpError ->
            viewError (buildErrorMessage httpError)


viewError : String -> Html Msg
viewError errorMessage =
    div []
        [ h3 [] [ text "Couldn't get the weather!" ]
        , text ("Error: " ++ errorMessage)
        ]


buildErrorMessage : Http.Error -> String
buildErrorMessage httpError =
    case httpError of
        Http.BadUrl message ->
            message

        Http.Timeout ->
            "Timeout."

        Http.NetworkError ->
            "Network error."

        Http.BadStatus statusCode ->
            "Bad status. Code: " ++ String.fromInt statusCode

        Http.BadBody message ->
            message


viewWeather : Weather -> Html Msg
viewWeather weather =
    div []
        [ h2 [] [ text "Current Weather" ]
        , styledTable []
            ([ viewTableHeader ] ++ [ viewWeatherDetails weather ])
        ]


viewTableHeader : Html Msg
viewTableHeader =
    tr []
        [ styledTh []
            [ text "Time" ]
        , styledTh []
            [ text "Temperature" ]
        , styledTh []
            [ text "Relative Humidity" ]
        , styledTh []
            [ text "Weather Code" ]
        ]


viewWeatherDetails : Weather -> Html Msg
viewWeatherDetails weather =
    tr []
        [ styledTd []
            [ text weather.time ]
        , styledTd []
            [ text (String.fromFloat weather.temperature) ]
        , styledTd []
            [ text (String.fromInt weather.humidity) ]
        , styledTd []
            [ text (String.fromInt weather.weatherCode) ]
        ]


weatherDecoder : Decoder Weather
weatherDecoder =
    Decode.succeed Weather
        |> requiredAt [ "current", "time" ] Decode.string
        |> requiredAt [ "current", "temperature_2m" ] Decode.float
        |> requiredAt [ "current", "relative_humidity_2m" ] Decode.int
        |> requiredAt [ "current", "weather_code" ] Decode.int


checkWeather : ( Float, Float ) -> Cmd Msg
checkWeather locationCoords =
    let
        latitude =
            Tuple.first locationCoords
                |> String.fromFloat

        longitude =
            Tuple.second locationCoords
                |> String.fromFloat
    in
    Http.get
        { url =
            "https://api.open-meteo.com/v1/forecast?"
                ++ ("latitude=" ++ latitude)
                ++ ("&longitude=" ++ longitude)
                ++ "&current=temperature_2m,relative_humidity_2m,weather_code"
        , expect =
            weatherDecoder
                |> Http.expectJson (RemoteData.fromResult >> DataReceived)
        }


newLocationCoords : ( Float, Float ) -> Int -> Float -> ( Float, Float )
newLocationCoords oldCoords axisNumber newCoord =
    let
        oldLatitude =
            Tuple.first oldCoords

        oldLongitude =
            Tuple.second oldCoords
    in
    case axisNumber of
        0 ->
            ( newCoord, oldLongitude )

        1 ->
            ( oldLatitude, newCoord )

        _ ->
            oldCoords


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        CheckWeather ->
            ( { model | currentWeather = RemoteData.Loading }
            , checkWeather model.locationCoords
            )

        UpdateLatitude latitude ->
            ( { model
                | locationCoords =
                    newLocationCoords model.locationCoords 0 latitude
              }
            , Cmd.none
            )

        UpdateLongitude longitude ->
            ( { model
                | locationCoords =
                    newLocationCoords model.locationCoords 1 longitude
              }
            , Cmd.none
            )

        DataReceived response ->
            ( { model | currentWeather = response }, Cmd.none )

        DoNothing ->
            ( model, Cmd.none )


init : () -> ( Model, Cmd Msg )
init _ =
    ( { locationCoords = ( 0, 0 )
      , currentWeather = RemoteData.Loading
      }
    , checkWeather ( 0, 0 )
    )


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }
