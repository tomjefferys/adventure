module Adventure exposing (..)

import Array exposing (Array, get)
import Dict exposing (Dict, insert, get)

import Types exposing (..)

defaultNode : Node
defaultNode =
  { name      = "default"
  , view      = [ Text "Node not found" ]
  , controls  = []
  }

nodeArr : Array Node
nodeArr = 
  Array.fromList 
    [{ name = "start"
     , view  =
         [ Text "You are in a locked room"
         , Cond (IfNotSet "key") [ Text "You see a key"]
         ]
     , controls = 
         [ Cond (IfNotSet "key")
                [ Link 
                  (Comp [Set "key" , Print [Text "You pick up the key"]])
                  "Get key"]
         , Link (MoveTo "forest") "goto forest"]
    },
     { name = "forest"
     , view  =
         [ Text "You are in a forset" ]
     , controls = 
         [ Link (MoveTo "start") "goto start" ]
    }]

makeNodeDict : Array Node -> Dict String Node
makeNodeDict nodes =
  Array.foldl (\node dict -> Dict.insert node.name node dict ) Dict.empty nodes

nodes : Dict Location Node
nodes = makeNodeDict nodeArr

getNode : Location -> Node
getNode loc = Maybe.withDefault defaultNode <| Dict.get loc nodes

