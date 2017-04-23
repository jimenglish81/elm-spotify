module View exposing (..)

import Html exposing (Html, div, text)
import Models exposing (Model)
import Msgs exposing (Msg)
import Playlist.List

view : Model -> Html Msg
view model =
    div []
      [ page model ]

page : Model -> Html Msg
page model =
    Playlist.List.view model.playlists
