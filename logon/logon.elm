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


-- MAIN
main =
  Browser.element
    {init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }


-- VARIBALES
type alias Model =
  { clientCreateUsername : String
  , clientCreatePassword : String
  , creatErrorMessage : String
  , createStatus : String
  , clientLoginUsername : String
  , clientLoginPassword : String
  , loginErrorMessage : String
  , loginStatus : Int
  , loggedIn : Bool}

type alias LogonInformation =
  {username : String
  , password : String}

-- INITIALIZE
init : () -> (Model, Cmd Msg)
init _ =
  (Model "" "" "" "Create_status" "" "" "" 0 False, Cmd.none)

initlogon : () -> (LogonInformation, Cmd Msg)
initlogon _ =
  (LogonInformation "" "", Cmd.none)


-- MSG
type Msg
  = Create
  | Login
  | CreateResponse (Result Http.Error String)
  | LoginResponse (Result Http.Error Int)
  | ChangeCreateUsername String
  | ChangeCreatePassword String
  | ChangeLoginUsername String
  | ChangeLoginePassword String


-- Update
update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Create ->
      ({model | createStatus = model.clientCreateUsername}, sendCreateRequest "test" model)
    Login ->
      (model, sendLoginRequest "test" model)
    CreateResponse result ->
      case result of
        Ok newvar ->
          ({model | createStatus = newvar}, Cmd.none)
        Err error ->
          ({model | creatErrorMessage = (Debug.toString error)}, Cmd.none)
    LoginResponse result ->
      case result of
        Ok newvar ->
          ({model | loginStatus = newvar}, Cmd.none)
        Err error ->
          ({model | loginErrorMessage = (Debug.toString error)}, Cmd.none)
    ChangeCreateUsername newContent ->
      ({model | clientCreateUsername = newContent}, Cmd.none)
    ChangeCreatePassword newContent ->
      ({model | clientCreatePassword = newContent}, Cmd.none)
    ChangeLoginUsername newContent ->
      ({model | clientLoginUsername = newContent}, Cmd.none)
    ChangeLoginePassword newContent ->
      ({model | clientLoginPassword = newContent}, Cmd.none)

-- SUBS
subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none

-- Decoder
responseDecoder : Decoder String
responseDecoder =
  field "response" string

loginDecoder : Decoder Int
loginDecoder =
  field "response" int

-- Encoder
createEncoder : Model -> Encode.Value
createEncoder model =
  Encode.object
    [ ( "username", Encode.string model.clientCreateUsername )
    , ( "password", Encode.string model.clientCreatePassword )
    ]

loginEncoder : Model -> Encode.Value
loginEncoder model =
  Encode.object
    [("username", Encode.string model.clientLoginUsername)
    , ("password", Encode.string model.clientLoginPassword)
    ]

-- HTTP functions
makeCreateRequest : String -> Decoder String -> Model -> Http.Request String
makeCreateRequest myurl decoder model =
  Http.request
    { method = "POST"
    , headers = []
    , url = myurl
    , body = Http.jsonBody (createEncoder model)
    , expect = Http.expectJson decoder
    , timeout = Nothing
    , withCredentials = False
    }

makeLoginRequest : String -> Decoder Int -> Model -> Http.Request Int
makeLoginRequest myurl decoder model =
  Http.request
    { method = "POST"
    , headers = []
    , url = myurl
    , body = Http.jsonBody (loginEncoder model)
    , expect = Http.expectJson decoder
    , timeout = Nothing
    , withCredentials = False
    }

--
sendCreateRequest : String -> Model -> Cmd Msg
sendCreateRequest topic model =
  Http.send CreateResponse (makeCreateRequest "http://127.0.0.1:5000/CreateUser/" responseDecoder model)

sendLoginRequest : String -> Model -> Cmd Msg
sendLoginRequest topic model =
  Http.send LoginResponse (makeLoginRequest "http://127.0.0.1:5000/Login/" loginDecoder model)

-- VIEW
view : Model -> Html Msg
view model =
  div []
  [
  div [] [text "-- Create User --"]
  ,div [] [input [placeholder "Username", onInput ChangeCreateUsername][]]
  ,div [] [input [placeholder "Password", onInput ChangeCreatePassword][]]
  ,div []  [button [onClick Create] [text "Create User"]]
  ,div []  [text model.createStatus]
  -- ,div [] [text model.creatErrorMessage]
  ,div [] [text "-- Login --"]
  ,div [] [input [placeholder "Username", onInput ChangeLoginUsername][]]
  ,div [] [input [placeholder "Password", onInput ChangeLoginePassword][]]
  ,div []  [button [onClick Login] [text "Login"]]
  ,div []  [text (Debug.toString model.loginStatus)]
  ]
