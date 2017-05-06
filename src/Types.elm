module Types exposing (..)

type alias Flag     = String
type alias Location = String

type alias Model = 
  { location : Location
  , flags    : List Flag
  , log      : List Element
  }

type Msg
  = Show
    | Go String

type Element
  = Text String
  | Set Flag
  | Link Location String


type alias Node =
  { name     : String
  , elements : List Element
  }

