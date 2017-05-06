import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Array exposing (Array, get)
import Random exposing (Seed, initialSeed, step, int)
import Time exposing (Time, second, inMilliseconds)
import Debug exposing (log)
import Dict exposing (Dict, insert, get)
import Dom.Scroll exposing (..)
import Task

main =
  Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }

-- MODEL

type alias Model = 
  { location : String
  , log : List Element
  }

type Element
  = Text String
  | Link String String
--  | Item String


type alias Node =
  { name     : String
  , elements : List Element
  }

type alias Location = { name : String }

nodeArr : Array Node
nodeArr = 
  Array.fromList 
    [{ name = "start"
     , elements =
         [ Text "You are in a locked room"
         , Link "forest" "goto forest"
         ]
    },
     { name = "forest"
     , elements =
         [ Text "You are in a forset"
         , Link "start" "goto start" 
         ]
    }]

getElements : String -> List Element
getElements loc =
  case Dict.get loc nodes of
    Just node -> node.elements
    Nothing -> []

makeNodeDict : Array Node -> Dict String Node
makeNodeDict nodes =
  Array.foldl (\node dict -> Dict.insert node.name node dict ) Dict.empty nodes

nodes : Dict String Node
nodes = makeNodeDict nodeArr


-- INIT
init : (Model, Cmd Msg)
init = ({location = "start", log = [] }, Cmd.none)


-- UPDATE

type Msg
  = Show
  | Go String

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

view : Model -> Html Msg
view model = 
  div [mainDivStyle] 
    [ div [storyDivStyle, id "story"]
      [ div [] <| getLogHtml model
      , div [] <| getLocStr model.location
      ]]

getLogHtml : Model -> List (Html Msg)
getLogHtml model = 
  List.map getElementHtml <| List.filter showInLog  model.log

showInLog : Element -> Bool
showInLog element =
  case element of
    Text _   -> True
    Link _ _ -> False

getLocStr : String -> List (Html Msg)
getLocStr str =
  case Dict.get str nodes of
    Just node -> getNodeHtml node
    Nothing   -> [text "Not today"]

getNodeHtml : Node -> List (Html Msg)
getNodeHtml node = List.map (getElementHtml) node.elements

getElementHtml : Element -> Html Msg
getElementHtml element =
  case element of
    Text txt -> div [textStyle] [text(txt)]
    Link lnk txt -> div [] [a [ linkStyle, onClick <| Go lnk] [text(txt)]]

mainDivStyle : Attribute Msg
mainDivStyle = style
  [ ("height", "100%")
  , ("width",  "100%")
  ]

storyDivStyle : Attribute Msg
storyDivStyle = style
  [ ("height", "50%")
  , ("background", "red")
  , ("overflow", "auto")
  ]

textStyle : Attribute Msg
textStyle = style
  [ ("font-size", "200%") ]


linkStyle : Attribute Msg
linkStyle = style
  [ ("cursor", "pointer")
  , ("color", "blue")
  , ("text-decoration", "underline")
  , ("font-size", "200%")
  ]

