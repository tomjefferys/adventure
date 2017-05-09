module View exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)

import Types exposing (..)


view : Model -> Html Msg
view model = 
  div [mainDivStyle] 
    [ div [] [text("Adventure")]
    , div [storyDivStyle, id "story"]
      [ div [] <| getLogHtml model
      , div [] <| getDisplayHtml model
      , div [] <| getControlsHtml model
      ]]

getLogHtml : Model -> List (Html Msg)
getLogHtml model = 
  List.map getElementHtml <| List.reverse model.log

getDisplayHtml : Model -> List (Html Msg)
getDisplayHtml model =
  List.map getElementHtml <| List.reverse model.view

getControlsHtml : Model -> List (Html Msg)
getControlsHtml model =
  List.map getElementHtml <| List.reverse model.controls

getElementHtml : ViewElement -> Html Msg
getElementHtml element =
  case element of
    VText txt -> div [textStyle] [text(txt)]
    VLink act txt -> div [] [a [ linkStyle, onClick <| Do act] [text(txt)]]

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
