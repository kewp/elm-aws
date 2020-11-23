module LoadTest exposing (..)

-- Make a GET request to load a book called "Public Opinion"
--
-- Read how it works:
--   https://guide.elm-lang.org/effects/http.html
--

import Browser
import Html exposing (Html, button, div, input, pre, text)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Http



-- MAIN


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }



-- MODEL


type alias Model =
    { data : Data
    , url : String
    }


type Data
    = NotStarted
    | Failure String
    | Loading
    | Success String


init : () -> ( Model, Cmd Msg )
init _ =
    ( { data = NotStarted, url = "https://elm-lang.org/assets/public-opinion.txt" }, Cmd.none )



-- UPDATE


type Msg
    = GetText
    | GotText (Result Http.Error String)
    | UpdateUrl String


getErrorString : Http.Error -> String
getErrorString err =
    case err of
        Http.BadUrl string ->
            "Bad url"

        Http.Timeout ->
            "Timeout"

        Http.NetworkError ->
            "Network error"

        Http.BadStatus int ->
            "Bad status"

        Http.BadBody string ->
            "Bad body"


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UpdateUrl value ->
            ( { model | url = value }, Cmd.none )

        GetText ->
            ( { model | data = Loading }
            , Http.request
                { method = "Get"
                , headers = []
                , url = model.url
                , body = Http.emptyBody
                , expect = Http.expectString GotText
                , timeout = Just 2000.0
                , tracker = Nothing
                }
            )

        GotText result ->
            case result of
                Ok fullText ->
                    ( { model | data = Success fullText }, Cmd.none )

                Err err ->
                    ( { model | data = Failure (getErrorString err) }, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ input [ style "width" "100%", placeholder "Text to reverse", value model.url, onInput UpdateUrl ] []
        , button
            [ onClick GetText ]
            [ text "get" ]
        , case model.data of
            NotStarted ->
                text "Not started"

            Failure value ->
                text ("Http error: " ++ value)

            Loading ->
                text "Loading..."

            Success fullText ->
                pre [] [ text fullText ]
        ]
