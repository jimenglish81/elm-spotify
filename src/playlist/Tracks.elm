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
    , maybeList model.isPlaying model.currentSrc model.tracks
    ]

maybeList : Bool -> Maybe String -> WebData (List Track) -> Html Msg
maybeList isPlaying currentSrc response =
    case response of
      RemoteData.NotAsked ->
        text ""

      RemoteData.Loading ->
        text ""

      RemoteData.Success tracks ->
        list isPlaying currentSrc tracks

      RemoteData.Failure error ->
        text ""

list : Bool -> Maybe String -> List Track -> Html Msg
list isPlaying currentSrc tracks =
    ul [ class "collection" ]
      (List.map (trackRow isPlaying currentSrc) tracks)

trackRow : Bool -> Maybe String -> Track -> Html Msg
trackRow isPlaying currentSrc track =
    let
      artist =
          Maybe.withDefault "unknown" (List.head track.artists)

      src =
          Maybe.withDefault "" currentSrc

      msg =
        if track.previewUrl == src && isPlaying then
          Msgs.AudioStop src
        else
          Msgs.AudioStart track.previewUrl

      icon =
        if track.previewUrl == src && isPlaying then
          "pause"
        else if track.previewUrl == "" then
          "remove"
        else
          "play_arrow"

      action =
        if track.previewUrl == "" then
          i [ class "material-icons track-icon" ]
            [ text icon ]
        else
          a [ onClick msg ]
            [ i
              [ class "material-icons track-icon" ]
              [ text icon ]
            ]
    in
      li [ class "collection-item" ]
        [ action
         , div [] [ text (track.name ++ " - " ++  artist) ]
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
