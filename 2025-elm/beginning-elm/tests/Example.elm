module Example exposing (..)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Test exposing (..)


additionTests : Test
additionTests =
    describe "Addition"
        [ test "two plus two equals four" <|
            \_ -> (2 + 2) |> Expect.equal 4
        , test "three plus four equals seven" <|
            \_ -> (3 + 4) |> Expect.equal 7
        ]


guardianNames : Test
guardianNames =
    test "only 2 guardians have names with less than 6 characters" <|
        \_ ->
            let
                guardians =
                    [ "Star-Lord", "Groot", "Gamora", "Drax", "Rocket" ]
            in
            guardians
                |> List.map String.length
                |> List.filter (\x -> x < 6)
                |> List.length
                |> Expect.equal 2


comparisonTests =
    describe "Comparison"
        [ test "2 /= 3" <|
            \_ -> 2 |> Expect.notEqual 3
        , test "4 < 5" <|
            \_ -> 4 |> Expect.lessThan 5
        , test "6 <= 7" <|
            \_ -> 6 |> Expect.atMost 7
        , test "9 > 8" <|
            \_ -> 9 |> Expect.greaterThan 8
        , test "11 >= 10" <|
            \_ -> 11 |> Expect.atLeast 10
        , test "a list with zero elements is empty" <|
            \_ ->
                List.isEmpty []
                    |> Expect.equal True
                    |> Expect.onFail "expected the list to be empty"
        , test "a list with some elements is not empty" <|
            \_ ->
                List.isEmpty [ "Jyn", "Cassian", "K-2SO" ]
                    |> Expect.equal False
                    |> Expect.onFail "expected the list not to be empty"
        ]
