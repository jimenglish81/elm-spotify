module Playlist.Tracks exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Msgs exposing (Msg)
import Models exposing (Model, Track, Playlist)
import RemoteData exposing (WebData)

view : Model -> Playlist -> Html Msg
view model playlist =
  div []
    [ div [ class "follow-bar" ]
      [ h3 [] [ text playlist.name ]
      , maybeFollowBtn playlist
      ]
    , maybeList model.tracks
    ]

maybeList : WebData (List Track) -> Html Msg
maybeList response =
    case response of
      RemoteData.NotAsked ->
        text ""

      RemoteData.Loading ->
        text ""

      RemoteData.Success tracks ->
        list tracks

      RemoteData.Failure error ->
        text ""

list : List Track -> Html Msg
list tracks =
    ul [ class "collection" ]
      (List.map trackRow tracks)

trackRow : Track -> Html Msg
trackRow track =
    let
      artist =
          Maybe.withDefault "unknown" (List.head track.artists)
    in
      li [ class "collection-item" ]
        [ text (track.name ++ " - " ++  artist) ]

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
      a [ class "btn waves-effect waves-light scale-transition", onClick msg ]
        [ btnText ]

maybeFollowBtn : Playlist -> Html Msg
maybeFollowBtn playlist =
    let
      response =
        playlist.isFollowing
    in
      case response of
          RemoteData.NotAsked ->
            text ""

          RemoteData.Loading ->
            text ""

          RemoteData.Success isFollowing ->
            followBtn playlist.name isFollowing

          RemoteData.Failure error ->
            text ""
