module Msgs exposing (..)

import Models exposing (Playlist)
import RemoteData exposing (WebData)

type Msg
    = Search
    | UpdateQuery String
    | OnSearch (WebData (List Playlist))
