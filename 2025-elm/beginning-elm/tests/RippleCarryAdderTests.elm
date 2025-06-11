module RippleCarryAdderTests exposing
    ( andGateTests
    , fullAdderTests
    , halfAdderTests
    , inverterTests
    , orGateTests
    )

import Expect exposing (Expectation)
import Fuzz exposing (..)
import Html exposing (b)
import RippleCarryAdder exposing (..)
import Test exposing (..)


inverterTests =
    describe "Inverter"
        [ test "output is 0 when the input is 1" <|
            \_ ->
                inverter 0
                    |> Expect.equal 1
        , test "output is 1 when the input is 0" <|
            \_ ->
                inverter 1
                    |> Expect.equal 0
        ]


andGateTests =
    describe "AND gate"
        [ test "output is 0 when neither input is 1" <|
            \_ ->
                andGate 0 0
                    |> Expect.equal 0
        , test "output is 0 when the second input is 1" <|
            \_ ->
                andGate 0 1
                    |> Expect.equal 0
        , test "output is 0 when the first input is 1" <|
            \_ ->
                andGate 1 0
                    |> Expect.equal 0
        , test "output is 1 when both inputs are 1" <|
            \_ ->
                andGate 1 1
                    |> Expect.equal 1
        ]


orGateTests =
    describe "OR gate"
        [ test "output is 0 when neither input is 1" <|
            \_ ->
                orGate 0 0
                    |> Expect.equal 0
        , test "output is 1 when second input is 1" <|
            \_ ->
                orGate 0 1
                    |> Expect.equal 1
        , test "output is 1 when first input is 1" <|
            \_ ->
                orGate 1 0
                    |> Expect.equal 1
        , test "output is 1 when both inputs are 1" <|
            \_ ->
                orGate 1 1
                    |> Expect.equal 1
        ]


halfAdderTests =
    describe "Half adder"
        [ describe "when input1 is 0"
            [ test "and input2 is 0, then sum is 0 and carry-out is 0" <|
                \_ ->
                    halfAdder 0 0
                        |> Expect.equal { carry = 0, sum = 0 }
            , test "and input2 is 1, then sum is 1 and carry-out is 0" <|
                \_ ->
                    halfAdder 0 1
                        |> Expect.equal { carry = 0, sum = 1 }
            ]
        , describe "when input1 is 1"
            [ test "and input2 is 0, then sum is 1 and carry-out is 0" <|
                \_ ->
                    halfAdder 1 0
                        |> Expect.equal { carry = 0, sum = 1 }
            , test "and input2 is 1, then sum is 0 and carry-out is 1" <|
                \_ ->
                    halfAdder 1 1
                        |> Expect.equal { carry = 1, sum = 0 }
            ]
        ]


fullAdderTests =
    describe "Full adder"
        [ describe "when input1 is 0"
            [ describe "and input2 is 0"
                [ test "and carry-in is 0, then sum and carry-out are 0" <|
                    \_ ->
                        fullAdder 0 0 0
                            |> Expect.equal { carry = 0, sum = 0 }
                , test "and carry-in is 1, then sum is 1 and carry-out is 0" <|
                    \_ ->
                        fullAdder 0 0 1
                            |> Expect.equal { carry = 0, sum = 1 }
                ]
            , describe "and input2 is 1"
                [ test "and carry-in is 0, then sum is 1 and carry-out is 0" <|
                    \_ ->
                        fullAdder 0 1 0
                            |> Expect.equal { carry = 0, sum = 1 }
                , test "and carry-in is 1, then sum is 0 and carry-out is 1" <|
                    \_ ->
                        fullAdder 0 1 1
                            |> Expect.equal { carry = 1, sum = 0 }
                ]
            ]
        , describe "when input1 is 1"
            [ describe "and input2 is 0"
                [ test "and carry-in is 0, then sum is 1 and carry-out is 0" <|
                    \_ ->
                        fullAdder 1 0 0
                            |> Expect.equal { carry = 0, sum = 1 }
                , test "and carry-in is 1, then sum is 0 and carry-out is 1" <|
                    \_ ->
                        fullAdder 1 0 1
                            |> Expect.equal { carry = 1, sum = 0 }
                ]
            , describe "and input2 is 1"
                [ test "and carry-in is 0, then sum is 0 and carry-out is 1" <|
                    \_ ->
                        fullAdder 1 1 0
                            |> Expect.equal { carry = 1, sum = 0 }
                , test "and carry-in is 1, then sum is 1 and carry-out is 1" <|
                    \_ ->
                        fullAdder 1 1 1
                            |> Expect.equal { carry = 1, sum = 1 }
                ]
            ]
        ]
