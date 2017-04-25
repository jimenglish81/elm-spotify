module Update exposing (..)

import Commands exposing (search)
import Msgs exposing (Msg)
import Models exposing (Model)

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
      Msgs.OnSearch response ->
        ( { model | playlists = response }, Cmd.none )

      Msgs.UpdateQuery str ->
        { model | query = str }
          ! []

      Msgs.Search ->
        ( model, search model.query )
