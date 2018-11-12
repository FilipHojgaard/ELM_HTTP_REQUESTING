import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Decode as D
import Html.Events exposing (onClick)
import Http
import Json.Decode exposing (Decoder, field, int, string, list)
import Json.Encode as Encode
import Debug


main =
  Browser.element
    {init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }



-- VAR
type alias Model =
  { question : String
  , answer : Int
  , errorMessage : String}


-- INIT
init : () -> (Model, Cmd Msg)
init _ =
  (Model "" 0 "", Cmd.none)

-- MSG
type Msg
  = SendPost
  | Reset
  | NewJson (Result Http.Error Int)


-- UPDATE
update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Reset ->
      ({model | answer = 0}, Cmd.none)
    SendPost ->
      (model, getValueHttp "test" model)
    NewJson result ->
      case result of
        Ok newvar ->
          ({model | answer = newvar} , Cmd.none)
        Err error ->
          ({model | errorMessage = (Debug.toString error)}, Cmd.none)

-- SUBS
subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none

-- Decoder
valueDecoder : Decoder Int
valueDecoder =
  field "answer" int

postEncoder : Model -> Encode.Value
postEncoder model =
  Encode.object
    [("question", Encode.string model.question)]

getValueHttp : String -> Model -> Cmd Msg
getValueHttp topic model =
  -- Http.send NewJson (Http.get "http://127.0.0.1:8000/httpTest.json" valueDecoder)
  -- Http.send NewJson (Http.get "http://echo.jsontest.com/lets/go" valueDecoder)
  Http.send NewJson (mypost "http://127.0.0.1:5000/post1/" valueDecoder model)


mypost : String -> Decoder Int -> Model -> Http.Request Int
mypost myurl decoder model =
  Http.request
    { method = "POST"
    , headers = []
    , url = myurl
    , body = Http.jsonBody (postEncoder model)
    , expect = Http.expectJson decoder
    , timeout = Nothing
    , withCredentials = False
    }

-- VIEW
view : Model -> Html Msg
view model =
  div []
  [ text (Debug.toString model.answer)
  , button [onClick SendPost] [text "SEND POST REQUEST"]
  , b [] [text (model.errorMessage)]]
