module Playlist.Tracks exposing (..)

import Html
    exposing
        ( Html
        , a
        , div
        , h3
        , i
        , li
        , ul
        , text
        )
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Msgs exposing (Msg)
import Models exposing (Model, Track, Playlist, Url(..))
import RemoteData exposing (WebData)


view : Model -> Playlist -> Html Msg
view model playlist =
    div []
        [ div [ class "follow-bar" ]
            [ h3
                []
                [ text playlist.name
                ]
            , maybeFollowBtn playlist
            ]
        , maybeList model
        ]


maybeList : Model -> Html Msg
maybeList model =
    case model.tracks of
        RemoteData.NotAsked ->
            text ""

        RemoteData.Loading ->
            text ""

        RemoteData.Success tracks ->
            list
                model.isPlaying
                model.currentTrackUrl
                tracks

        RemoteData.Failure error ->
            text ""


list : Bool -> Maybe Url -> List Track -> Html Msg
list isPlaying currentTrackUrl tracks =
    ul [ class "collection" ] <|
        List.map
            (trackRow isPlaying currentTrackUrl)
            tracks


trackRow : Bool -> Maybe Url -> Track -> Html Msg
trackRow isPlaying currentTrackUrl track =
    let
        artist =
            Maybe.withDefault
                "unknown"
                (List.head track.artists)

        currentUrl =
            Maybe.withDefault (Url "") (currentTrackUrl)

        attrs =
            case track.previewUrl of
                Just url ->
                    if url == currentUrl && isPlaying then
                        [ onClick (Msgs.AudioStop url) ]
                    else
                        [ onClick (Msgs.AudioStart url) ]

                Nothing ->
                    []
    in
        li
            ([ class "collection-item track-row" ]
                ++ attrs
            )
            [ (trackIcon
                isPlaying
                currentUrl
                track.previewUrl
              )
            , div
                []
                [ text (track.name ++ " - " ++ artist)
                ]
            ]


trackIcon : Bool -> Url -> Maybe Url -> Html a
trackIcon isPlaying currentUrl previewUrl =
    let
        icon =
            case previewUrl of
                Just url ->
                    if url == currentUrl && isPlaying then
                        "pause"
                    else
                        "play_arrow"

                Nothing ->
                    "remove"
    in
        i
            [ class "material-icons"
            ]
            [ text icon
            ]


followBtn : String -> Bool -> Html Msg
followBtn playlistName isFollowing =
    let
        btnText =
            case isFollowing of
                True ->
                    text "unfollow"

                False ->
                    text "follow"

        msg =
            case isFollowing of
                True ->
                    Msgs.UnFollow

                False ->
                    Msgs.Follow
    in
        a
            [ class "btn waves-effect waves-light scale-transition"
            , onClick msg
            ]
            [ btnText
            ]


maybeFollowBtn : Playlist -> Html Msg
maybeFollowBtn { isFollowing, name } =
    case isFollowing of
        RemoteData.NotAsked ->
            text ""

        RemoteData.Loading ->
            text ""

        RemoteData.Success resp ->
            followBtn name resp

        RemoteData.Failure error ->
            text ""
