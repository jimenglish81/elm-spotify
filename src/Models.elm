module Models exposing (..)

type alias Model =
    { playlists : List Playlist
    }

initialModel : Model
initialModel =
    { playlists = [ Playlist "1" "playlist" "http://google.com" ]
    }

type alias PlaylistId =
    String

type alias Playlist =
    { id : PlaylistId
    , name : String
    , href : String
    }
