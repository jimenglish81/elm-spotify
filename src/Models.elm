module Models exposing (..)

import RemoteData exposing (WebData)
import OAuth

type alias Model =
    { playlists : WebData (List Playlist)
    , tracks : WebData (List Track)
    , user : WebData User
    , query : String
    , client : OAuth.Client
    , redirectUrl : String
    , token : Maybe OAuth.Token
    , route: Route
    , userId : String
    , playlistId : String
    }

initialModel : Route -> OAuth.Client -> String -> Model
initialModel route client redirectUrl =
    { playlists = RemoteData.NotAsked
    , tracks = RemoteData.NotAsked
    , user = RemoteData.NotAsked
    , query = ""
    , client = client
    , redirectUrl = redirectUrl
    , token = Nothing
    , route = route
    , userId = ""
    , playlistId = ""
    }

type Route
    = SearchRoute
    | SearchResultRoute Query
    | PlaylistRoute UserId PlaylistId
    | NotFoundRoute

type alias PlaylistId =
    String

type alias UserId =
    String

type alias Query =
    String

type alias Playlist =
    { id : PlaylistId
    , name : String
    , href : String
    , userId : String
    , isFollowing : WebData Bool
    , images : (List String)
    }

type alias Track =
    { name : String
    , artists : (List String)
    }

type alias User =
    { id : UserId
    }

type alias Flags =
    { clientId : String
    , redirectUrl : String
    }

spotifyAuthClient : String -> String -> OAuth.Client
spotifyAuthClient clientId redirectUrl =
    OAuth.newClient
        { authorizeUrl = "https://accounts.spotify.com/authorize"
        , tokenUrl = "https://accounts.spotify.com/api/token"
        , validateUrl = "https://api.spotify.com/v1/me"
        }
        { clientId = clientId
        , scopes = [ "playlist-modify-public", "playlist-read-private" ]
        , redirectUrl = redirectUrl
        , authFlow = OAuth.Implicit
        }
