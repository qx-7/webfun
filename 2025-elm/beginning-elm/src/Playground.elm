module Playground exposing (main)

import Html


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
