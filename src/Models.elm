module Models exposing (..)

type alias Model =
    { playlists : List Playlist
    }

initialModel : Model
initialModel =
    { playlists = [
      Playlist "1" "playlist" "http://google.com"
      , Playlist "2" "playlist2" "http://google.com"
      , Playlist "3" "playlist3" "http://google.com"
      , Playlist "4" "playlist" "http://google.com"
      , Playlist "5" "playlist2" "http://google.com"
      , Playlist "6" "playlist3" "http://google.com" 
    ]
    }

type alias PlaylistId =
    String

type alias Playlist =
    { id : PlaylistId
    , name : String
    , href : String
    }
