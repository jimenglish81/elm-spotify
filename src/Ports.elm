port module Ports exposing (..)

port audioStart : String -> Cmd msg

port audioStop : String  -> Cmd msg

port audioFinished : (String -> msg) -> Sub msg
