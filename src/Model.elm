module Model exposing
  ( init
  , update
  , execute
  )

import Types exposing (..)
import Task
import Dom.Scroll exposing (toBottom)
import Set exposing (Set)
import Adventure exposing (..)

import Debug exposing (crash,log)


init : Model
init = setDisplay
  { location = "start"
  , flags = Set.empty
  , view = []
  , controls = []
  , log = [] }

{- (re_sets the display.  Updates the log, 
  sets the view, and control content,
  Ususally called when the player moves
  to a new node -}
setDisplay : Model -> Model
setDisplay model =
  let model2 = updateLog model
      model3 = updateView model2
      model4 = updateControls model3
  in model4

{- Updates the view based on the current node -}
updateView : Model -> Model
updateView model =
  let model2 = deleteDisplay model
  in  printElements printView model2 (getNode model2.location).view

{- Updates the contrls based on the current node -}
updateControls : Model -> Model
updateControls model = 
  let model2 = deleteControls model
  in  printElements printControl model2 (getNode model2.location).controls

{- Append the view to the log -}
updateLog : Model -> Model
updateLog model = List.foldr logElement model model.view

{- Appends an element to the log, skips any controls -}
logElement : ViewElement -> Model -> Model
logElement element model = 
  case element of
    VText txt -> { model | log = element :: model.log }
    _         -> model

deleteDisplay : Model -> Model
deleteDisplay model = { model | view = [] }

deleteControls : Model -> Model
deleteControls model = { model | controls = [] }
      
{- A function that takes a view element adds it 
  to a field in the model -}
type alias PrintFn = ViewElement -> Model -> Model

{- print to the view -}
printView : PrintFn
printView element model = { model | view = element :: model.view }

{- print to the controls -}
printControl : PrintFn
printControl element model =
  { model | controls = element :: model.controls } 

{- Prints a list of element (converting them to ViewElements
  in the process), using the provided print function to the model -}
printElements : PrintFn -> Model -> List Element -> Model
printElements printfn = List.foldl (printElement printfn)

{- Prints a single element (converting to ViewElement) to the model -}
printElement : PrintFn -> Element -> Model -> Model
printElement printfn element model =
  case element of
    Text str -> printfn (VText str)  model
    Link action str -> printfn (VLink action str) model
    Cond cond elements -> printCondition printfn model cond elements

{- Conditionally print something.
   eg if a flag is set or not -}
printCondition : PrintFn -> Model -> Condition -> List Element -> Model
printCondition printfn model cond elements =
  case cond of
    IfSet flag -> if (Set.member flag model.flags)
                    then printElements printfn model elements 
                    else model
    IfNotSet flag -> if (Set.member flag model.flags)
                        then model
                        else printElements printfn model elements 

{- The main update method -}
update : Msg -> Model -> (Model, Cmd Msg)
update msg model = 
  case msg of
    Show -> (model, Cmd.none)
    Do action -> (execute action model, 
                    Task.attempt (always Show) <| toBottom "story")

{- Execute an action, updating the model as appropriate -}
execute : Action -> Model -> Model
execute action model = 
  case action of
    Set flag   -> updateControls { model | flags = Set.insert flag model.flags }
    UnSet flag -> updateControls { model | flags = Set.remove flag model.flags }
    MoveTo loc -> 
      let model2 = { model | location = loc }
      in setDisplay model2

    Print elements -> printElements printView model elements
    Comp actions -> List.foldl execute model actions




