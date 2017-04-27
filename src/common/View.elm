module Common.View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class)
import Msgs exposing (Msg)

loader : Html Msg
loader =
    div [ class "loader" ]
      [ div [ class "uil-cube-css" ]
        [ div [] [], div [] [], div [] [], div [] [] ]
      ]

errorMsg : Html Msg
errorMsg =
    div [ class "error" ]
      [ text "There has been an error." ]
