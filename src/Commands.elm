module Commands exposing (..)

import Http exposing (..)
import Json.Decode as Decode
import Json.Decode.Pipeline exposing (decode, required, requiredAt, hardcoded, optional)
import Msgs exposing (Msg)
import Models exposing (User, Playlist, Track, PlaylistId, UserId)
import RemoteData exposing (WebData)
import OAuth

getUserUrl : String
getUserUrl =
    "https://api.spotify.com/v1/me"

searchUrl : String -> String
searchUrl query =
    "https://api.spotify.com/v1/search?type=playlist&market=GB&limit=50&q=" ++ query

playlistUrl : UserId -> PlaylistId -> String
playlistUrl userId playlistId =
    "https://api.spotify.com/v1/users/" ++ userId ++ "/playlists/" ++ playlistId ++ "/tracks"

followUrl : UserId -> PlaylistId -> String
followUrl userId playlistId =
  "https://api.spotify.com/v1/users/" ++ userId ++ "/playlists/" ++ playlistId  ++ "/followers"

checkFollowUrl : UserId -> PlaylistId -> UserId -> String
checkFollowUrl userId playlistId currentUserId =
  "https://api.spotify.com/v1/users/" ++ userId ++ "/playlists/" ++ playlistId  ++ "/followers/contains?ids=" ++ currentUserId

search : String -> Cmd Msg
search query =
    Http.get (searchUrl query) playListsDecode
      |> RemoteData.sendRequest
      |> Cmd.map Msgs.OnSearch

getUser : Maybe OAuth.Token -> Cmd Msg
getUser token =
    Http.request
      { body = Http.emptyBody
      , expect = Http.expectJson userDecode
      , headers = getHeaders token
      , method = "GET"
      , timeout = Nothing
      , url = getUserUrl
      , withCredentials = False
      }
        |> RemoteData.sendRequest
        |> Cmd.map Msgs.OnUser

getTracks : Maybe OAuth.Token -> UserId -> PlaylistId -> Cmd Msg
getTracks token userId playlistId =
    Http.request
      { body = Http.emptyBody
      , expect = Http.expectJson tracksDecode
      , headers = getHeaders token
      , method = "GET"
      , timeout = Nothing
      , url = (playlistUrl userId playlistId)
      , withCredentials = False
      }
        |> RemoteData.sendRequest
        |> Cmd.map Msgs.OnPlaylistView

followPlaylist : Maybe OAuth.Token -> UserId -> PlaylistId -> String -> (WebData Models.PlaylistId -> Msg) -> Cmd Msg
followPlaylist token userId playlistId method msg =
    Http.request
      { body = Http.emptyBody
      , expect = Http.expectStringResponse (\response -> Ok playlistId)
      , headers = getHeaders token
      , method = method
      , timeout = Nothing
      , url = (followUrl userId playlistId)
      , withCredentials = False
      }
        |> RemoteData.sendRequest
        |> Cmd.map msg

checkFollowPlaylist : Maybe OAuth.Token -> UserId -> PlaylistId -> UserId -> Cmd Msg
checkFollowPlaylist token userId playlistId currentUserId =
    Http.request
      { body = Http.emptyBody
      , expect = Http.expectJson isFollowingDecode
      , headers = getHeaders token
      , method = "GET"
      , timeout = Nothing
      , url = (checkFollowUrl userId playlistId currentUserId)
      , withCredentials = False
      }
        |> RemoteData.sendRequest
        |> Cmd.map Msgs.OnCheckFollowing

playListsDecode : Decode.Decoder (List Playlist)
playListsDecode =
    Decode.at ["playlists", "items"] (Decode.list playlistDecode)

playlistDecode : Decode.Decoder (Playlist)
playlistDecode =
    decode Playlist
      |> required "id" Decode.string
      |> required "name" Decode.string
      |> requiredAt [ "external_urls" ] hrefDecode
      |> requiredAt [ "owner" ] userIdDecode
      |> hardcoded RemoteData.NotAsked
      |> requiredAt [ "images" ] (Decode.list imageDecode)

hrefDecode : Decode.Decoder (String)
hrefDecode =
    Decode.at [ "spotify" ] (Decode.string)

userIdDecode : Decode.Decoder (String)
userIdDecode =
    Decode.at [ "id" ] (Decode.string)

imageDecode : Decode.Decoder (String)
imageDecode =
    Decode.at [ "url" ] (Decode.string)

tracksDecode : Decode.Decoder (List Track)
tracksDecode =
    Decode.at [ "items" ] (Decode.list trackItemDecode)

trackItemDecode : Decode.Decoder (Track)
trackItemDecode =
    Decode.at [ "track" ] trackDecode

trackDecode : Decode.Decoder (Track)
trackDecode =
    decode Track
      |> required "name" Decode.string
      |> requiredAt [ "artists" ] (Decode.list artistDecode)
      |> optional "preview_url" Decode.string ""

artistDecode : Decode.Decoder (String)
artistDecode =
    Decode.at [ "name" ] (Decode.string)

userDecode : Decode.Decoder (User)
userDecode =
    decode User
      |> required "id" Decode.string

isFollowingDecode : Decode.Decoder (Bool)
isFollowingDecode =
    Decode.at [ "0" ] (Decode.bool)

getHeaders : Maybe OAuth.Token -> List Http.Header
getHeaders maybe =
  --  TODO use util
  case maybe of
    Just token ->
      case token of
        OAuth.Validated t ->
          [ Http.header "Authorization" ("Bearer " ++ t) ]

    Nothing ->
      []
