module Model exposing
  ( init
  , update)

import Types exposing (..)
import Task
import Dom.Scroll exposing (toBottom)
import Adventure exposing (..)


init : Model
init =
  { location = "start"
  , flags = []
  , log = [] }

update : Msg -> Model -> (Model, Cmd Msg)
update msg model = 
  case msg of
    Show -> (model, Cmd.none)
    Go newLoc -> (doGo newLoc model,
      Task.attempt (always Show) <| toBottom "story")

doGo : Location -> Model -> Model
doGo newLoc model = 
  let model2 =
    {model |
      log = List.append model.log 
                 <| getElements model.location}
  in { model2 | location = newLoc }
