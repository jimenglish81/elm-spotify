module Routing exposing (..)

import Navigation exposing (Location)
import Msgs exposing (Msg)
import Models exposing (Query, PlaylistId, UserId, Route(..))
import Commands exposing (search)
import UrlParser
    exposing
        ( Parser
        , map
        , oneOf
        , parseHash
        , s
        , string
        , top
        , (</>)
        )
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
        , map
            PlaylistRoute
            (s "playlist" </> string </> string)
        ]


parseLocation : Location -> Route
parseLocation location =
    case (parseHash matchers location) of
        Just route ->
            route

        Nothing ->
            NotFoundRoute


sendMsg : msg -> Cmd msg
sendMsg msg =
    Task.succeed msg
        |> Task.perform identity


getRouteCmd : Route -> Cmd Msg
getRouteCmd route =
    case route of
        SearchResultRoute query ->
            Cmd.batch
                [ sendMsg (Msgs.UpdateQuery query)
                , (search query)
                ]

        PlaylistRoute userId playlistId ->
            sendMsg (Msgs.ViewPlaylist userId playlistId)

        NotFoundRoute ->
            redirectToSearch ""

        _ ->
            Cmd.none


maybeToken : a -> a -> Maybe OAuth.Token -> a
maybeToken valid invalid token =
    case token of
        Just token ->
            case token of
                OAuth.Validated t ->
                    valid

        Nothing ->
            invalid


redirectToSearch : String -> Cmd Msg
redirectToSearch query =
    let
        url =
            case query of
                "" ->
                    searchPath

                _ ->
                    searchResultPath query
    in
        Navigation.newUrl (url)
