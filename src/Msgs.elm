module Msgs exposing (..)

import Models exposing (User, Playlist, Track, UserId, PlaylistId)
import RemoteData exposing (WebData)
import Navigation exposing (Location)
import OAuth
import Http

type Msg
    = Search
    | UpdateQuery String
    | ViewPlaylist UserId PlaylistId
    | OnSearch (WebData (List Playlist))
    | OnPlaylistView (WebData (List Track))
    | OnLocationChange Location
    | Token (Result Http.Error OAuth.Token)
    | Follow
    | UnFollow
    | OnFollow (RemoteData.WebData PlaylistId)
    | OnUnFollow (RemoteData.WebData PlaylistId)
    | OnUser (WebData User)
    | OnCheckFollowing (WebData Bool)
    | AudioStart String
    | AudioStop String
