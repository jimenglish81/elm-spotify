module Main exposing (..)

import Msgs exposing (Msg)
import Models
    exposing
        ( Model
        , initialModel
        , Flags
        , spotifyAuthClient
        , Route(..)
        , ClientId(..)
        , Url(..)
        )
import View exposing (view)
import Update exposing (update)
import Navigation exposing (Location)
import Routing exposing (parseLocation, getRouteCmd)
import OAuth
import Ports


init : Flags -> Location -> ( Model, Cmd Msg )
init flags location =
    let
        currentRoute =
            parseLocation location

        client =
            (spotifyAuthClient
                (ClientId flags.clientId)
                (Url flags.redirectUrl)
            )

        cmd =
            Cmd.batch
                [ OAuth.init client location
                    |> Cmd.map Msgs.Token
                , getRouteCmd currentRoute
                ]
    in
        ( initialModel
            currentRoute
            client
          <|
            Url flags.redirectUrl
        , cmd
        )


subscriptions : Model -> Sub Msg
subscriptions model =
    Ports.audioFinished (\s -> Msgs.AudioStop (Url s))


main : Program Flags Model Msg
main =
    Navigation.programWithFlags Msgs.OnLocationChange
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
