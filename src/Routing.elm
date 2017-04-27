module Routing exposing (..)

import Navigation exposing (Location)
import Msgs exposing(Msg)
import Models exposing (Query, PlaylistId, UserId, Route(..))
import Commands exposing (search)
import UrlParser exposing (..)
import Task
import OAuth

searchPath : String
searchPath =
    "#search"

searchResultPath : Query -> String
searchResultPath query =
    "#search/" ++ query

playlistPath : PlaylistId -> UserId -> PlaylistId
playlistPath userId playlistId =
    "#playlist/" ++ userId ++ "/" ++ playlistId

matchers : Parser (Route -> a) a
matchers =
    oneOf
      [ map SearchRoute top
      , map SearchRoute (s "search")
      , map SearchResultRoute (s "search" </> string)
      , map PlaylistRoute (s "playlist" </> string </> string) ]

parseLocation : Location -> Route
parseLocation location =
    case (parseHash matchers location) of
      Just route ->
        route

      Nothing ->
        SearchRoute

sendMsg : msg -> Cmd msg
sendMsg msg =
    Task.succeed msg
      |> Task.perform identity

getRouteCmd : Route -> Cmd Msg
getRouteCmd route =
    case route of
      SearchResultRoute query ->
        Cmd.batch [ sendMsg (Msgs.UpdateQuery query), (search query) ]

      PlaylistRoute userId playlistId ->
        sendMsg (Msgs.ViewPlaylist userId playlistId)

      _ ->
        Cmd.none

maybeToken : Maybe OAuth.Token -> a -> a -> a
maybeToken token valid invalid =
  case token of
    Just token ->
      case token of
        OAuth.Validated t ->
          valid

    Nothing ->
      invalid
