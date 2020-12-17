module ElmUITest exposing (main)

import Browser
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Element.Region as Region
import Html as Html
import Html.Attributes as HA
import Http


type GetLogin
    = NotStarted
    | Failure String
    | Loading
    | Success String


type Msg
    = ChangeUsername String
    | ClickLogin
    | GotLogin (Result Http.Error String)
    | ChangePassword String
    | ToggleRememberMe


type alias Model =
    { username : String, password : String, rememberMe : Bool, status : GetLogin }


style name value =
    Element.htmlAttribute <| HA.style name value


init : () -> ( Model, Cmd Msg )
init _ =
    ( { username = "", password = "", rememberMe = False, status = NotStarted }, Cmd.none )


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
        ChangePassword pass ->
            ( { model | password = pass }, Cmd.none )

        ChangeUsername user ->
            ( { model | username = user }, Cmd.none )

        ClickLogin ->
            ( { model | status = Loading }
            , Http.request
                { method = "Get"
                , headers = []
                , url = "https://github.com"
                , body = Http.emptyBody
                , expect = Http.expectString GotLogin
                , timeout = Just 2000.0
                , tracker = Nothing
                }
            )

        GotLogin result ->
            case result of
                Ok fullText ->
                    ( { model | status = Success fullText }, Cmd.none )

                Err err ->
                    ( { model | status = Failure (getErrorString err) }, Cmd.none )

        ToggleRememberMe ->
            ( { model | rememberMe = not model.rememberMe }, Cmd.none )


renderTitle =
    paragraph
        [ Font.bold
        , Font.size 34
        , width fill
        , paddingXY 20 0
        , Border.width 10
        , Border.solid
        , Border.color <| Element.rgb 120 120 120
        , Border.shadow { color = Element.rgba 0 0 0 0.5, offset = ( 0, 0 ), blur = 5, size = 5 }
        ]
        [ text "Elm AWS" ]


renderPage model =
    row
        [ spacing 40
        , height fill
        , width fill
        , explain Debug.todo
        ]
        [ leftMenu
        , loginPage model
        ]


leftMenu =
    row
        [ padding 20
        ]
        [ column
            [ height fill
            , spacing 20
            , padding 20
            , Border.width 10
            , Border.rounded 6
            , Border.solid
            , Border.color <| Element.rgb 120 120 120
            , Border.shadow { color = Element.rgba 0 0 0 0.5, offset = ( 0, 0 ), blur = 3, size = 1 }
            ]
            [ text "Home"
            , text "Photos"
            , text "Videos"
            , text "Contacts"
            , paragraph []
                [ el [ Font.italic ] (text "N")
                , text "Subs!"
                ]
            , text "About"
            ]
        ]


defaultCheckbox : Bool -> Element msg
defaultCheckbox checked =
    Element.el
        [ Element.htmlAttribute <| HA.class "focusable"
        , Element.width
            (Element.px 14)
        , Element.height (Element.px 14)
        , Font.color white
        , Element.centerY
        , Font.size 9
        , Font.center
        , Border.rounded 3
        , Border.color <|
            if checked then
                Element.rgb (59 / 255) (153 / 255) (252 / 255)

            else
                Element.rgb (211 / 255) (211 / 255) (211 / 255)
        , Border.shadow
            { offset = ( 0, 0 )
            , blur = 1
            , size = 1
            , color =
                if checked then
                    Element.rgba (238 / 255) (238 / 255) (238 / 255) 0

                else
                    Element.rgb (238 / 255) (238 / 255) (238 / 255)
            }
        , Background.color <|
            if checked then
                Element.rgb (59 / 255) (153 / 255) (252 / 255)

            else
                white
        , Border.width <|
            if checked then
                0

            else
                1
        , Element.inFront
            (Element.el
                [ Border.color white
                , Element.height (Element.px 6)
                , Element.width (Element.px 9)
                , Element.rotate (degrees -45)
                , Element.centerX
                , Element.centerY
                , Element.moveUp 1
                , Element.transparent (not checked)
                , Border.widthEach
                    { top = 0
                    , left = 2
                    , bottom = 2
                    , right = 0
                    }
                ]
                Element.none
            )
        ]
        Element.none


toggleCheckboxWidget : { offColor : Color, onColor : Color, sliderColor : Color, toggleWidth : Int, toggleHeight : Int } -> Bool -> Element msg
toggleCheckboxWidget { offColor, onColor, sliderColor, toggleWidth, toggleHeight } checked =
    let
        pad =
            3

        sliderSize =
            toggleHeight - 2 * pad

        translation =
            (toggleWidth - sliderSize - pad)
                |> String.fromInt
    in
    el
        [ Background.color <|
            if checked then
                onColor

            else
                offColor
        , width <| px <| toggleWidth
        , height <| px <| toggleHeight
        , Border.rounded 14
        , inFront <|
            el [ height fill ] <|
                el
                    [ Background.color sliderColor
                    , Border.rounded <| sliderSize // 2
                    , width <| px <| sliderSize
                    , height <| px <| sliderSize
                    , centerY
                    , moveRight pad
                    , htmlAttribute <|
                        HA.style "transition" ".4s"
                    , htmlAttribute <|
                        if checked then
                            HA.style "transform" <| "translateX(" ++ translation ++ "px)"

                        else
                            HA.class ""
                    ]
                <|
                    text ""
        ]
    <|
        text ""


lightGrey : Color
lightGrey =
    rgb255 187 187 187


green : Color
green =
    rgb255 39 203 139


white : Color
white =
    rgb255 255 255 255


myTooltip : String -> Element msg
myTooltip str =
    el
        [ Background.color (rgb 0 0 0)
        , Font.color (rgb 1 1 1)
        , padding 4
        , Border.rounded 5
        , Font.size 14
        , Border.shadow
            { offset = ( 0, 3 ), blur = 6, size = 0, color = rgba 0 0 0 0.32 }
        ]
        (text str)


blue =
    Element.rgb255 238 238 238


purple =
    Element.rgb255 238 238 23


{-| This is the same as Element.text but it preserves line breaks, tabs, and extra whitespace.
This isn't exposed because if you forget to place it in a paragraph, it will have weird behavior (for example, it will ignore column spacing and the line spacing will be too small).
It's best to just us `textParagraph`.
-}



--text : String -> Element msg
--text text_ =
--   Element.html <| Html.span [ HA.style "white-space" "pre-wrap" ] [ Html.text text_ ]
--| Create a paragraph from a single string. This also preserves line breaks, tabs, and extra white space within the string.--}


textParagraph : List (Element.Attribute msg) -> String -> Element msg
textParagraph attributes text_ =
    Element.paragraph attributes [ text text_ ]


myButton label =
    Input.button
        [ Background.color <| Element.rgb255 254 248 250
        , Background.gradient
            { angle = 0
            , steps = [ Element.rgba255 255 255 255 0, Element.rgba255 255 255 255 0.8 ]
            }

        {- }, Border.innerShadow
               { blur = 0
               , color = Element.rgba255 16 22 26 0.2
               , offset = ( 0, 0 )
               , size = 1
               }
           , Border.innerShadow
               { blur = 0
               , color = Element.rgba255 16 22 26 0.1
               , offset = ( 0, -1 )
               , size = 0
               }
        -}
        --, style "background-image" "linear-gradient(180deg,hsla(0,0%,100%,.8),hsla(0,0%,100%,0))"
        , style "box-shadow" "inset 0 0 0 1px rgba(16,22,26,.2),inset 0 -1px 0 rgba(16,22,26,.1)"
        , Border.rounded 3
        , width <| px 150
        , height <| px 40
        , centerX
        , paddingXY 10 10
        , Font.size 14
        , Font.family
            [ Font.typeface "-apple-system"
            , Font.typeface "Segoe UI"
            , Font.typeface "Roboto"
            , Font.sansSerif
            ]
        , mouseDown [ Background.gradient { angle = 0, steps = [ Element.rgb255 216 225 232 ] } ]
        , mouseOver [ Background.color <| Element.rgb255 235 241 245 ]

        --, mouseDown [ Background.color <| Element.rgb255 216 225 232 ]
        {--, Element.focused
            [ Background.color <| Element.rgb255 235 241 245 ]
        --}
        ]
        { onPress = Just ClickLogin
        , label = text label
        }


loginPage model =
    column
        [ width fill
        , height fill
        ]
        [ column
            [ centerX
            , centerY
            , spacing 30
            , padding 30
            , Border.rounded 3
            , Background.gradient
                { angle = Basics.pi / 4
                , steps =
                    [ Element.rgba255 150
                        255
                        255
                        0.2
                    , Element.rgba255
                        255
                        255
                        255
                        0.8
                    ]
                }
            , Border.shadow
                { blur = 5
                , color = Element.rgba255 16 22 26 0.2
                , offset = ( 0, 0 )
                , size = 1
                }
            ]
            [ paragraph [] [ el [ Font.size 30 ] (text "Login") ]
            , paragraph []
                [ Input.text []
                    { onChange = ChangeUsername
                    , text = model.username
                    , placeholder =
                        Just
                            (Input.placeholder []
                                (text "user@email.com")
                            )
                    , label = Input.labelAbove [ Font.size 16 ] (text "Username")
                    }
                ]
            , Input.text []
                { onChange = ChangePassword
                , text = model.password
                , placeholder =
                    Just
                        (Input.placeholder []
                            (text "enter password")
                        )

                --, label = Input.labelHidden "Password"
                , label =
                    Input.labelAbove [ Font.size 16, width fill ] <|
                        row [ width fill ]
                            [ text "Password"
                            , link
                                [ alignRight
                                , Font.color <| rgb 0 0 255
                                , Border.color <| rgba255 255 255 255 255
                                , Border.widthEach
                                    { bottom = 1
                                    , left = 0
                                    , top = 0
                                    , right = 0
                                    }
                                , mouseOver [ Border.color <| rgb255 0 0 200 ]
                                ]
                                { url = "/forgot", label = text "Forgot password" }
                            ]
                }
            , Input.checkbox [] <|
                { onChange = always ToggleRememberMe
                , label = Input.labelRight [] <| el [ Font.size 15 ] (text "Remember me")
                , checked = model.rememberMe
                , icon =
                    toggleCheckboxWidget
                        { offColor = lightGrey
                        , onColor = green
                        , sliderColor = white
                        , toggleWidth = 40
                        , toggleHeight = 20
                        }
                }
            , case model.status of
                NotStarted ->
                    Element.none

                Failure str ->
                    el [] (text str)

                Loading ->
                    el [] (text "Loading")

                Success str ->
                    el [] (text str)
            , myButton "Login"
            ]
        ]


tooltip : (Element msg -> Attribute msg) -> Element Never -> Attribute msg
tooltip usher tooltip_ =
    inFront <|
        el
            [ width fill
            , height fill
            , transparent True
            , mouseOver [ transparent False ]
            , (usher << Element.map never) <|
                el [ htmlAttribute (HA.style "pointerEvents" "none") ]
                    tooltip_
            ]
            none


view model =
    layout [] <|
        column
            [ height fill
            , width fill
            , spacing 20
            , Font.family
                [ Font.typeface "-apple-system"
                , Font.typeface "Segoe UI"
                , Font.typeface "Roboto"
                , Font.sansSerif
                ]
            ]
            [ renderTitle
            , renderPage model
            ]


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
