import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Decode as D
import Html.Events exposing (onClick)
import Http
import Json.Decode exposing (Decoder, field, int, string, list)
import Debug

-- http://echo.jsontest.com/key/value
-- MAIN
main =
  Browser.element
    {init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }


-- VAR
type alias Model =
  { val : Int
  , errorMessage : String}


-- INIT
init : () -> (Model, Cmd Msg)
init _ =
  (Model 0 "", Cmd.none)

-- request
-- type alias Request =
--     { method : String
--     , headers : List ( String, String )
--     , url : String
--     }

-- MSG
type Msg
  = Reset
  | Python
  | NewJson (Result Http.Error Int)


-- UPDATE
update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Reset ->
      ({model | val = 0}, Cmd.none)
    Python ->
      (model, getValueHttp "test")
    NewJson result ->
      case result of
        Ok newvar ->
          ({model | val = newvar} , Cmd.none)
        Err error ->
          ({model | errorMessage = (Debug.toString error)}, Cmd.none)

-- SUBS
subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none

-- Decoder
valueDecoder : Decoder Int
valueDecoder =
  field "value" int

getValueHttp : String -> Cmd Msg
getValueHttp topic =
  -- Http.send NewJson (Http.get "http://127.0.0.1:8000/httpTest.json" valueDecoder)
  -- Http.send NewJson (Http.get "http://echo.jsontest.com/lets/go" valueDecoder)
  Http.send NewJson (myget "http://127.0.0.1:5000/return1" valueDecoder)

-- custom request

myget : String -> Decoder Int -> Http.Request Int
myget myurl decoder =
  Http.request
    { method = "GET"
    , headers = []
    , url = myurl
    , body = Http.emptyBody
    , expect = Http.expectJson decoder
    , timeout = Nothing
    , withCredentials = False
    }

-- VIEW
view : Model -> Html Msg
view model =
  div []
  [ text (Debug.toString model.val)
  , button [onClick Python] [text "SEND HTTP REQUEST"]
  , b [] [text (model.errorMessage)]]
