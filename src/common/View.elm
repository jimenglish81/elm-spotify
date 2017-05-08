module Common.View exposing (..)

import Html exposing (Html, div, text)
import Html.Attributes exposing (class)


loader : Html a
loader =
    div
        [ class "loader"
        ]
        [ div
            [ class "uil-cube-css"
            ]
            [ div [] []
            , div [] []
            , div [] []
            , div [] []
            ]
        ]


errorMsg : Html a
errorMsg =
    div [ class "error" ]
        [ text "There has been an error." ]
