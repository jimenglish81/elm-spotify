module Playlist.List exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, id, placeholder, required, type_)
import Models exposing (Playlist)
import Msgs exposing (Msg)

view : List Playlist -> Html Msg
view playlists =
    div []
      [ navBar
      , list playlists
      ]

navBar : Html Msg
navBar =
    nav []
    [ div [ class "nav-wrapper" ]
      [ searchForm ]
    ]

searchForm : Html Msg
searchForm =
    div [ class "input-field" ]
      [ input [ type_ "search", required True, placeholder "Start typing..." ] []
      , label [ class "label-icon" ] [ i [ class "material-icons" ] [ text "search" ]]
      , i [ class "material-icons" ] [ text "close" ]
      ]

list : List Playlist -> Html Msg
list playlists =
    div [ class "container" ]
      [ div [ class "image-grid" ]
        (List.map playlistRow playlists)
      ]

playlistRow : Playlist -> Html Msg
playlistRow playlist =
    div []
      [ text playlist.name ]
