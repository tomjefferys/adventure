module Adventure exposing (..)

import Array exposing (Array, get)
import Dict exposing (Dict, insert, get)

import Types exposing (..)

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
