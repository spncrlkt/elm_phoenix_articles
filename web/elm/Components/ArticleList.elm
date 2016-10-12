module Components.ArticleList exposing (..)

import Html exposing (Html, text, ul, li, div, h2, button)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import List
import Article

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

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Noop ->
      (model, Cmd.none)

    Fetch ->
      (articles, Cmd.none)

-- VIEW

viewArticle : Article.Model -> Html a
viewArticle article =
  li [] [ Article.view article ]

viewArticles : Model -> List (Html a)
viewArticles model =
  List.map viewArticle model.articles


view : Model -> Html Msg
view model =
  div [ class "article-list"]
    [ h2 [] [text "Article List" ]
    , button [ onClick Fetch, class "btn btn-primary" ] [ text "Fetch Articles" ]
    , ul [] (viewArticles model)
    ]
