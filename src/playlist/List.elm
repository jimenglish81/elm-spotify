module Playlist.List exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class)
import Models exposing (Playlist)
import Msgs exposing (Msg)

view : List Playlist -> Html Msg
view playlists =
    div []
      [ nav
      , list playlists
      ]

nav : Html Msg
nav =
    div [ class "clearfix mb2 white bg-black" ]
      [ div [ class "left p2" ] [ text "Playlists" ] ]

list : List Playlist -> Html Msg
list playlists =
    div [ class "p2" ]
      [ table []
        [ thead []
          [ tr []
            [ th [] [ text "Name" ]
            ]
          ]
        , tbody [] (List.map playlistRow playlists)
        ]
      ]

playlistRow : Playlist -> Html Msg
playlistRow playlist =
    tr []
      [ td [] [ text playlist.name ]
      ]
