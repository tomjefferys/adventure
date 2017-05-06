import Html exposing (program)
import Debug exposing (log)
import Task
import Model as Model
import Types exposing (..)
import View exposing (..)
import Adventure exposing (..)
import Dom.Scroll exposing (toBottom)

main =
  Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }

-- MODEL



-- INIT
init : (Model, Cmd Msg)
init = (Model.init, Cmd.none)


-- UPDATE


update : Msg -> Model -> (Model, Cmd Msg)
update msg model = 
  case msg of
    Show -> (model, Cmd.none)
    Go newLoc -> (doGo newLoc model,
      Task.attempt (always Show) <| toBottom "story")

doGo : String -> Model -> Model
doGo newLoc model = 
  let model2 = {model | log = List.append model.log 
                                <| getElements model.location}
  in { model2 | location = newLoc }

-- SUBSCRIPTIONS
subscriptions : Model -> Sub Msg
subscriptions model = Sub.none
--  Time.every second Tick

-- VIEW


