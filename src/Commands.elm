module Commands exposing (..)

import Http exposing (..)
import Json.Decode as Decode
import Json.Decode.Pipeline exposing (decode, required, requiredAt)
import Msgs exposing (Msg)
import Models exposing (Playlist)
import RemoteData

searchUrl : String -> String
searchUrl query =
    "https://api.spotify.com/v1/search?type=playlist&market=GB&limit=50&q=" ++ query

search : String -> Cmd Msg
search query =
    Http.get (searchUrl query) playListsDecode
      |> RemoteData.sendRequest
      |> Cmd.map Msgs.OnSearch

playListsDecode : Decode.Decoder (List Playlist)
playListsDecode =
    Decode.at ["playlists", "items"] (Decode.list playlistDecode)

playlistDecode : Decode.Decoder (Playlist)
playlistDecode =
    decode Playlist
      |> required "id" Decode.string
      |> required "name" Decode.string
      |> requiredAt [ "external_urls" ] hrefDecode
      |> requiredAt [ "images" ] (Decode.list imageDecode)

hrefDecode : Decode.Decoder (String)
hrefDecode =
    Decode.at [ "spotify" ] (Decode.string)

imageDecode : Decode.Decoder (String)
imageDecode =
    Decode.at [ "url" ] (Decode.string)
