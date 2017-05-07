module View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class)
import Msgs exposing (Msg)
import Models exposing (Model, PlaylistId)
import RemoteData
import Playlist.List
import Playlist.Nav
import Playlist.Tracks
import Common.View exposing (errorMsg, loader)


view : Model -> Html Msg
view model =
    div []
        [ Playlist.Nav.view model
        , main_ [ class "container" ] [ page model ]
        ]


page : Model -> Html Msg
page model =
    case model.route of
        Models.SearchRoute ->
            text ""

        Models.SearchResultRoute _ ->
            Playlist.List.view model

        Models.PlaylistRoute _ playlistId ->
            playlistPage model playlistId

        Models.NotFoundRoute ->
            notFoundView


playlistPage : Model -> PlaylistId -> Html Msg
playlistPage model playlistId =
    case model.playlists of
        RemoteData.NotAsked ->
            text ""

        RemoteData.Loading ->
            loader

        RemoteData.Success playlists ->
            let
                maybePlaylist =
                    playlists
                        |> List.filter
                            (\{ id } -> id == playlistId)
                        |> List.head
            in
                case maybePlaylist of
                    Just playlist ->
                        Playlist.Tracks.view model playlist

                    Nothing ->
                        notFoundView

        RemoteData.Failure _ ->
            errorMsg


notFoundView : Html a
notFoundView =
    div [ class "error" ]
        [ text "Not found" ]
