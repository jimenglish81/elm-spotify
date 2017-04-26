module Playlist.List exposing (..)

import Html exposing (..)
import Html.Attributes exposing (autofocus, class, id, placeholder, required, type_)
import Html.Events exposing (..)
import Models exposing (Playlist)
import Msgs exposing (Msg)
import Json.Decode as Json
import RemoteData exposing(WebData)

view : WebData (List Playlist) -> Html Msg
view response =
    div []
      [ navBar
      , main_ [ class "container" ]
        [ maybeList response ]
      ]

navBar : Html Msg
navBar =
    header [ class "navbar-fixed"]
    [ nav []
      [ div [ class "nav-wrapper" ]
        [ searchForm ]
      ]
    ]

searchForm : Html Msg
searchForm =
    div
      [ class "input-field" ]
      [ input
        [ autofocus True
        , type_ "search"
        , required True
        , placeholder "Start typing..."
        , onInput Msgs.UpdateQuery
        , onEnter Msgs.Search
        ]
        []
      , label
        [ class "label-icon" ]
        [
          i [ class "material-icons" ]
          [ text "search" ] ]
      , i [ class "material-icons" ] [ text "close" ]
      ]

maybeList : WebData (List Playlist) -> Html Msg
maybeList response =
  case response of
    RemoteData.NotAsked ->
      text ""

    RemoteData.Loading ->
      loader

    RemoteData.Success playlists ->
      list playlists

    RemoteData.Failure error ->
      text (toString error)

list : List Playlist -> Html Msg
list playlists =
    div [ class "image-grid" ]
      (List.map playlistRow playlists)

playlistRow : Playlist -> Html Msg
playlistRow playlist =
    div []
      [ text playlist.name ]

onEnter : Msg -> Attribute Msg
onEnter msg =
    let
      isEnter code =
        if code == 13 then
          Json.succeed msg
        else
          Json.fail "not ENTER"
    in
      on "keydown" (Json.andThen isEnter keyCode)

loader : Html Msg
loader =
    div [ class "loader" ]
      [ div [ class "uil-cube-css" ]
        [ div [] [], div [] [], div [] [], div [] [] ]
      ]
