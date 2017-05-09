import Html exposing (program)
import Debug exposing (log)
import Model as Model
import Types exposing (..)
import View exposing (..)

import Debug exposing (..)

main : Program Never Model Msg
main = log "Main" <|
  Html.program
    { init = init
    , view = view
    , update = Model.update
    , subscriptions = subscriptions
    }

-- INIT
init : (Model, Cmd Msg)
init = (Model.init, Cmd.none)


-- SUBSCRIPTIONS
subscriptions : Model -> Sub Msg
subscriptions model = Sub.none
--  Time.every second Tick


