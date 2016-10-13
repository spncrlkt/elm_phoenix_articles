module Components.ArticleList exposing (..)

import Html exposing (Html, a, text, ul, li, div, h2, button)
import Html.Attributes exposing (class, href)
import Html.Events exposing (onClick)
import Http
import Task
import Json.Decode as Json exposing ((:=))


import List
import Components.Article as Article

-- MODEL 

type alias Model =
  { articles : List Article.Model }

initModel : Model
initModel =
    { articles = [] }

articles : Model
articles = 
  { articles = 
    [ { title = "Article 1"
      , url = "http://google.com"
      , postedBy = "Author"
      , postedOn = "6/9/16"
      }
    , { title = "Article 2"
      , url = "http://google.com"
      , postedBy = "Author"
      , postedOn = "6/9/16"
      }
    , { title = "Article 3"
      , url = "http://google.com"
      , postedBy = "Author"
      , postedOn = "6/9/16"
      }
    ]
  }

-- UPDATE
type Msg
  = Noop
  | Fetch
  | FetchSucceed (List Article.Model)
  | FetchFail Http.Error
  | RouteToNewPage SubPage

type SubPage
  = ListView
  | ShowView Article.Model

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Noop ->
      (model, Cmd.none)

    Fetch ->
      (articles, fetchArticles)

    FetchSucceed articleList ->
      (Model articleList, Cmd.none)

    FetchFail error ->
      case error of
        Http.UnexpectedPayload errorMsg ->
          Debug.log errorMsg
          (model, Cmd.none)
        _ ->
          Debug.log "Other Error"
          (model, Cmd.none)

    RouteToNewPage _ ->
      (model, Cmd.none)

-- HTTP
fetchArticles : Cmd Msg
fetchArticles = 
  let
    url = "/api/articles"
  in
    Task.perform FetchFail FetchSucceed (Http.get decodeArticleFetch url)

decodeArticleFetch : Json.Decoder (List Article.Model)
decodeArticleFetch =
  Json.at ["data"] decodeArticleList

decodeArticleList : Json.Decoder (List Article.Model)
decodeArticleList =
  Json.list decodeArticleData

decodeArticleData : Json.Decoder Article.Model
decodeArticleData =
  Json.object4 Article.Model
    ("title" := Json.string)
    ("url" := Json.string)
    ("posted_by" := Json.string)
    ("posted_on" := Json.string)

-- VIEW

view : Model -> Html Msg
view model =
  div [ class "article-list"]
    [ h2 [] [text "Article List" ]
    , button [ onClick Fetch, class "btn btn-primary" ] [ text "Fetch Articles" ]
    , ul [] (viewArticles model)
    ]

viewArticles : Model -> List (Html Msg)
viewArticles model =
  List.map viewArticle model.articles

viewArticle : Article.Model -> Html Msg
viewArticle article =
  li [] [ Article.view article, articleLink article ]

articleLink : Article.Model -> Html Msg
articleLink article =
  a
    [ href ("#article/" ++ article.title ++ "/show")
    , onClick (RouteToNewPage (ShowView article))
    ]
    [ text " (Show) "]
