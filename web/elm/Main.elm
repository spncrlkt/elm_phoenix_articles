module Main exposing (..)

import Html exposing (Html, div)
import Html.App as App
import Html.Attributes exposing (class)

import Components.ArticleList as ArticleList

-- MAIN
main : Program Never
main =
  App.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }


-- MODEL
type alias Model =
  { articleListModel : ArticleList.Model
  }

initModel : Model
initModel =
  { articleListModel = ArticleList.initModel
  }

init : (Model, Cmd Msg)
init =
  (initModel , Cmd.none)


-- UPDATE
type Msg
  = ArticleListMsg ArticleList.Msg

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    ArticleListMsg articleMsg ->
      let (updatedModel, cmd) =
        ArticleList.update articleMsg model.articleListModel
      in
        ( { model | articleListModel = updatedModel }, Cmd.map ArticleListMsg cmd)


-- VIEW
view : Model -> Html Msg
view model =
  div [ class "elm-app" ]
    [ App.map ArticleListMsg (ArticleList.view model.articleListModel)
    ]


-- SUBSRCRIPTIONS
subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none


