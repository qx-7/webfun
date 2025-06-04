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


main =
    escapeEarth 10 6.7 "low"
        |> Html.text
