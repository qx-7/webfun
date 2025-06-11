module Playground exposing (doubleScores, main, signUp)

import Html
import Signup exposing (Msg(..))


escapeEarth myVelocity mySpeed fuelStatus =
    let
        escapeVelocityInKmPerSec =
            11.186

        orbitalSpeedInKmPerSec =
            7.67

        whereToLand =
            if fuelStatus == "low" then
                "land on droneship"

            else
                "land on launchpad"
    in
    if myVelocity > escapeVelocityInKmPerSec then
        "godspeed"

    else if mySpeed == orbitalSpeedInKmPerSec then
        "stay in orbit"

    else
        whereToLand


weekday dayInNumber =
    case dayInNumber of
        0 ->
            "Sunday"

        1 ->
            "Monday"

        2 ->
            "Tuesday"

        3 ->
            "Wednesday"

        4 ->
            "Thursday"

        5 ->
            "Friday"

        6 ->
            "Saturday"

        _ ->
            "Unknown day"


hashtag dayInNumber =
    case weekday dayInNumber of
        "Sunday" ->
            "#Suckday"

        "Monday" ->
            "#LasagnaNight"

        "Tuesday" ->
            "#MoreLasagna"

        "Wednesday" ->
            "#HumpDay"

        "Thursday" ->
            "#ThrowbackThursday"

        "Friday" ->
            "#Fartday"

        "Saturday" ->
            "#Shaturday"

        _ ->
            "#null"


revelation =
    """
    It became very clear to me sitting out there today
    that every decision I've made in my entire life has
    been wrong. My life is the complete "opposite" of
    everything I want it to be. Every instinct I have,
    in every aspect of life, be it something to wear,
    something to eat - it's all been wrong.
    """


scoreMultiplier =
    2


highestScores =
    [ 316, 320, 312, 370, 337, 318, 314 ]


doubleScores scores =
    List.map (\x -> x * scoreMultiplier) scores


signUp : String -> String -> Result String String
signUp email ageStr =
    case String.toInt ageStr of
        Nothing ->
            Err "Age must be an integer."

        Just age ->
            let
                emailPattern =
                    "\\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}\\b"

                regex =
                    Maybe.withDefault Regex.never <|
                        Regex.fromString emailPattern

                isValidEmail =
                    Regex.contains regex email
            in
            if age < 13 then
                Err "You need to be at least 13 years old to sign up."

            else if isValidEmail then
                Ok "Your account has been created successfully!"

            else
                Err "You entered an invalid email."


main =
    {--
    escapeEarth 10 6.7 "low"
        |> Html.text
    --}
    {--
    Html.text <|
        hashtag 5
--}
    {--}
    Html.text revelation
--}
