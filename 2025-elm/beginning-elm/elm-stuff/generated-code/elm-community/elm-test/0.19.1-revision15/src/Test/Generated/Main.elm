module Test.Generated.Main exposing (main)

import RippleCarryAdderTests

import Test.Reporter.Reporter exposing (Report(..))
import Console.Text exposing (UseColor(..))
import Test.Runner.Node
import Test

main : Test.Runner.Node.TestProgram
main =
    Test.Runner.Node.run
        { runs = 100
        , report = ConsoleReport UseColor
        , seed = 250196474005609
        , processes = 8
        , globs =
            [ "tests/RippleCarryAdderTests.elm"
            ]
        , paths =
            [ "/home/emmie/hugo/webfun/2025-elm/beginning-elm/tests/RippleCarryAdderTests.elm"
            ]
        }
        [ ( "RippleCarryAdderTests"
          , [ Test.Runner.Node.check RippleCarryAdderTests.andGateTests
            , Test.Runner.Node.check RippleCarryAdderTests.fullAdderTests
            , Test.Runner.Node.check RippleCarryAdderTests.halfAdderTests
            , Test.Runner.Node.check RippleCarryAdderTests.inverterTests
            , Test.Runner.Node.check RippleCarryAdderTests.orGateTests
            ]
          )
        ]