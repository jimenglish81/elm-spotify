module Playlist.List exposing (..)

import Html exposing (Html, a, div, img, text)
import Html.Attributes
    exposing
        ( alt
        , class
        , href
        , target
        , src
        , title
        )
import Models exposing (Model, Playlist)
import RemoteData exposing (WebData)
import Routing exposing (playlistPath, maybeToken)
import Common.View exposing (errorMsg, loader)
import OAuth


view : Model -> Html a
view model =
    maybeList model


maybeList : Model -> Html a
maybeList { playlists, token } =
    case playlists of
        RemoteData.NotAsked ->
            text ""

        RemoteData.Loading ->
            loader

        RemoteData.Success response ->
            list token response

        RemoteData.Failure _ ->
            errorMsg


list : Maybe OAuth.Token -> List Playlist -> Html a
list token playlists =
    div [ class "image-grid" ] <|
        List.map
            (playlistRow token)
            playlists


playlistRow : Maybe OAuth.Token -> Playlist -> Html a
playlistRow token playlist =
    div [ class "image-grid-item" ]
        [ playlistBtn token playlist ]


playlistBtn : Maybe OAuth.Token -> Playlist -> Html a
playlistBtn token playlist =
    let
        path =
            maybeToken
                (playlistPath playlist.userId playlist.id)
                playlist.href
                token

        linkTarget =
            maybeToken "_self" "_blank" token

        url =
            Maybe.withDefault
                "https://image.flaticon.com/icons/png/512/226/226773.png"
                (List.head playlist.images)
    in
        a
            [ href path
            , target linkTarget
            , title playlist.name
            ]
            [ img
                [ src url
                , alt playlist.name
                ]
                []
            , div
                [ class "image-grid-item-title"
                ]
                [ text playlist.name
                ]
            ]
