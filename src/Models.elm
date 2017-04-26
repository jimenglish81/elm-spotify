module Models exposing (..)

import RemoteData exposing (WebData)

type alias Model =
    { playlists : WebData (List Playlist)
    , query : String
    }

initialModel : Model
initialModel =
    { playlists = RemoteData.NotAsked
    , query = ""
    }

type alias PlaylistId =
    String

type alias Playlist =
    { id : PlaylistId
    , name : String
    , href : String
    , images : (List String)
    }
