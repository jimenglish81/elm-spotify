module Update exposing (..)

import Commands
    exposing
        ( getTracks
        , followPlaylist
        , getUser
        , checkFollowPlaylist
        )
import Msgs exposing (Msg)
import Models exposing (Model, Url(..))
import Routing
    exposing
        ( parseLocation
        , getRouteCmd
        , redirectToSearch
        )
import RemoteData exposing (WebData)
import Ports


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Msgs.OnSearch response ->
            ( { model | playlists = response }, Cmd.none )

        Msgs.OnPlaylistView response ->
            ( { model | tracks = response }, Cmd.none )

        Msgs.OnLocationChange location ->
            let
                newRoute =
                    parseLocation location

                cmd =
                    case model.currentTrackUrl of
                        Just (Url url) ->
                            Ports.audioStop url

                        Nothing ->
                            Cmd.none
            in
                ( { model
                    | route = newRoute
                    , currentTrackUrl = Nothing
                    , isPlaying = False
                  }
                , Cmd.batch [ cmd, getRouteCmd newRoute ]
                )

        Msgs.UpdateQuery str ->
            ( { model | query = str }, Cmd.none )

        Msgs.ViewPlaylist userId playlistId ->
            let
                currentUserId =
                    case model.user of
                        RemoteData.NotAsked ->
                            ""

                        RemoteData.Loading ->
                            ""

                        RemoteData.Success user ->
                            user.id

                        RemoteData.Failure error ->
                            ""
            in
                ( { model
                    | userId = userId
                    , playlistId = playlistId
                  }
                , Cmd.batch
                    [ getTracks
                        model.token
                        userId
                        playlistId
                    , checkFollowPlaylist
                        model.token
                        userId
                        playlistId
                        currentUserId
                    ]
                )

        Msgs.Search ->
            ( model, redirectToSearch model.query )

        Msgs.Token (Ok t) ->
            let
                token =
                    Just t
            in
                ( { model | token = token }, getUser token )

        Msgs.Token (Err _) ->
            model ! []

        Msgs.Follow ->
            ( model
            , (followPlaylist
                model.token
                model.userId
                model.playlistId
                "PUT"
                Msgs.OnFollow
              )
            )

        Msgs.OnFollow (RemoteData.Success _) ->
            ( updateIsFollowing
                model
                (RemoteData.Success True)
            , Cmd.none
            )

        Msgs.OnFollow _ ->
            ( updateIsFollowing
                model
                (RemoteData.Success False)
            , Cmd.none
            )

        Msgs.UnFollow ->
            ( model
            , (followPlaylist
                model.token
                model.userId
                model.playlistId
                "DELETE"
                Msgs.OnUnFollow
              )
            )

        Msgs.OnUnFollow (RemoteData.Success _) ->
            ( updateIsFollowing
                model
                (RemoteData.Success False)
            , Cmd.none
            )

        Msgs.OnUnFollow _ ->
            ( model, Cmd.none )

        Msgs.OnCheckFollowing isFollowing ->
            ( updateIsFollowing
                model
                isFollowing
            , Cmd.none
            )

        Msgs.OnUser response ->
            ( { model | user = response }
            , Cmd.none
            )

        Msgs.AudioStart (Url url) ->
            ( { model
                | currentTrackUrl = Just (Url url)
                , isPlaying = True
              }
            , Ports.audioStart url
            )

        Msgs.AudioStop (Url url) ->
            ( { model | isPlaying = False }
            , Ports.audioStop url
            )


updateIsFollowing : Model -> WebData Bool -> Model
updateIsFollowing model isFollowing =
    let
        toggle playlist =
            if playlist.id == model.playlistId then
                { playlist | isFollowing = isFollowing }
            else
                playlist

        updatePlaylist playlists =
            List.map toggle playlists

        updatedPlaylist =
            RemoteData.map updatePlaylist model.playlists
    in
        { model | playlists = updatedPlaylist }
