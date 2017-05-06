module Playlist.Nav exposing (..)

import Html exposing (..)
import Html.Attributes
    exposing
        ( autofocus
        , class
        , href
        , placeholder
        , required
        , type_
        , value
        )
import Html.Events exposing (..)
import Msgs exposing (Msg)
import Json.Decode as Json
import View.Extra exposing (viewMaybe)
import OAuth
import RemoteData exposing (WebData)
import Models exposing (Model, User)


view : Model -> Html Msg
view model =
    header [ class "navbar-fixed" ]
        [ nav []
            [ div
                [ class "nav-wrapper"
                ]
                [ ul []
                    [ li []
                        [ viewMaybe
                            (loggedIn model.user)
                            (loginBtn model.client)
                            model.token
                        ]
                    ]
                , searchForm model.query
                ]
            ]
        ]


loggedIn : WebData User -> a -> Html Msg
loggedIn user _ =
    case user of
        RemoteData.NotAsked ->
            text ""

        RemoteData.Loading ->
            text ""

        RemoteData.Success user ->
            div
                [ class "username"
                ]
                [ text user.id
                ]

        RemoteData.Failure _ ->
            text "fail"


loginBtn : OAuth.Client -> Html Msg
loginBtn client =
    a
        [ href <| OAuth.buildAuthUrl client
        , class "waves-effect waves-light"
        ]
        [ i
            [ class "material-icons left"
            ]
            [ text "cloud"
            ]
        , text "sign in"
        ]


searchForm : String -> Html Msg
searchForm query =
    div
        [ class "input-field" ]
        [ input
            [ autofocus True
            , value query
            , type_ "search"
            , required True
            , placeholder "Start typing..."
            , onInput Msgs.UpdateQuery
            , onEnter Msgs.Search
            ]
            []
        , label
            [ class "label-icon" ]
            [ i [ class "material-icons" ]
                [ text "search" ]
            ]
        , i
            [ class "material-icons"
            ]
            [ text "close"
            ]
        ]


onEnter : Msg -> Attribute Msg
onEnter msg =
    let
        isEnter code =
            if code == 13 then
                Json.succeed msg
            else
                Json.fail "not ENTER"
    in
        on "keydown" <| Json.andThen isEnter keyCode
