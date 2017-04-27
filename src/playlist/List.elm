module Playlist.List exposing (..)

import Html exposing (..)
import Html.Attributes exposing (alt, class, href, target, src, title)
import Models exposing (Model, Playlist)
import Msgs exposing (Msg)
import RemoteData exposing (WebData)
import Routing exposing (playlistPath, maybeToken)
import Common.View exposing (errorMsg, loader)
import OAuth

view : Model -> Html Msg
view model =
    maybeList model

maybeList : Model -> Html Msg
maybeList model =
    let
      response = model.playlists
    in
      case response of
        RemoteData.NotAsked ->
          text ""

        RemoteData.Loading ->
          loader

        RemoteData.Success playlists ->
          list model.token playlists

        RemoteData.Failure error ->
          errorMsg

list : Maybe OAuth.Token -> List Playlist -> Html Msg
list token playlists =
    div [ class "image-grid" ]
      (List.map (playlistRow token) playlists)

playlistRow : Maybe OAuth.Token -> Playlist -> Html Msg
playlistRow token playlist =
    div [ class "image-grid-item" ]
      [ playlistBtn token playlist ]

playlistBtn : Maybe OAuth.Token -> Playlist -> Html Msg
playlistBtn token playlist =
    let
      path =
        maybeToken token (playlistPath playlist.userId playlist.id) playlist.href

      linkTarget =
        maybeToken token "_self" "_blank"

      url =
          Maybe.withDefault "https://image.flaticon.com/icons/png/512/226/226773.png" (List.head playlist.images)
    in
      a
        [ href path, target linkTarget, title playlist.name ]
        [ img [ src url, alt playlist.name ] []
        , div [ class "image-grid-item-title" ] [ text playlist.name ]
        ]
