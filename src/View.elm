module View exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)

import Dict exposing (Dict, get)

import Dom.Scroll exposing (..)

import Types exposing (..)
import Adventure exposing (..)
import Debug exposing (crash)

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
    Set _ -> False
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
    Set  flag -> crash ("undefined")
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
