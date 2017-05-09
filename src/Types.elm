module Types exposing (..)

import Set exposing (Set)

type alias Flag     = String
type alias Location = String

{- The main model type, 
   contains all the game state -}
type alias Model = 
  { location : Location
  , flags    : Set Flag
  , view     : List ViewElement
  , controls : List ViewElement
  , log      : List ViewElement
  }

type Msg
  = Show
  | Do Action

type Action
  = Set Flag
  | UnSet Flag
  | MoveTo Location
  | Print (List Element)
  | Comp (List Action)


type Condition
  = IfSet Flag
  | IfNotSet Flag

type Element
  = Text String
  | Link Action String 
  | Cond Condition (List Element)

type ViewElement
  = VText String
  | VLink Action String

type alias Node =
  { name     : Location
  , view     : List Element
  , controls : List Element
  }

