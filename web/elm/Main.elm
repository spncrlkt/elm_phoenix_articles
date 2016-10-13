module Main exposing (..)

import Html exposing (Html, div, h1, h2, text, a, li, ul)
import Html.App as App
import Html.Attributes exposing (class, href)
import Html.Events exposing (onClick)

import Components.ArticleList as ArticleList
import Components.ArticleShow as ArticleShow
import Components.Article as Article

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
  , currentView : Page
  }

type Page
  = RootView
  | ArticleListView
  | ArticleShowView Article.Model


initModel : Model
initModel =
  { articleListModel = ArticleList.initModel
  , currentView = RootView
  }

init : (Model, Cmd Msg)
init =
  (initModel , Cmd.none)


-- UPDATE
type Msg
  = ArticleListMsg ArticleList.Msg
  | UpdateView Page
  | ArticleShowMsg ArticleShow.Msg

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    ArticleListMsg articleMsg ->
      case articleMsg of
        ArticleList.RouteToNewPage page ->
          case page of
            ArticleList.ShowView article ->
              ({ model | currentView = (ArticleShowView article) }, Cmd.none)
            _ ->
              (model, Cmd.none)
        _ ->
          let (updatedModel, cmd) = ArticleList.update articleMsg model.articleListModel
          in ( { model | articleListModel = updatedModel }, Cmd.map ArticleListMsg cmd )


    UpdateView page ->
      let
        newModel = { model | currentView = page }
      in
        case page of
          ArticleListView ->
            (newModel, Cmd.map ArticleListMsg ArticleList.fetchArticles)

          _ ->
            (newModel, Cmd.none )

    ArticleShowMsg articleMsg ->
      (model, Cmd.none )


-- VIEW
view : Model -> Html Msg
view model =
  div [ class "elm-app" ]
    [ header
    , pageView model 
    ]

header : Html Msg
header =
  div []
    [ h1 [] [ text "Elm Articles" ]
    , ul []
      [ li []
        [ a [href "#", onClick (UpdateView RootView)] [ text "Home" ]
        ]
      , li []
        [ a [href "#articles", onClick (UpdateView ArticleListView)] [ text "Articles" ]
        ]
      ]
    ]

pageView : Model -> Html Msg
pageView model =
  case model.currentView of
    RootView ->
      welcomeView

    ArticleListView ->
      articleListView model

    ArticleShowView article ->
      articleShowView article

welcomeView : Html Msg
welcomeView =
  h2 [] [ text "Welcome to Elm Articles" ]

articleListView : Model -> Html Msg
articleListView model =
  App.map ArticleListMsg (ArticleList.view model.articleListModel)

articleShowView : Article.Model -> Html Msg
articleShowView article =
  App.map ArticleShowMsg (ArticleShow.view article)

-- SUBSRCRIPTIONS
subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none


