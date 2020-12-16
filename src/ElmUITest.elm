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
import String exposing (right)


type alias Model =
    { username : String, password : String, rememberMe : Bool }


style name value =
    Element.htmlAttribute <| HA.style name value


initialModel : Model
initialModel =
    { username = "", password = "", rememberMe = False }


update : Msg -> Model -> Model
update msg model =
    case msg of
        ChangePassword pass ->
            { model | password = pass }

        ChangeUsername user ->
            { model | username = user }

        ClickLogin ->
            model

        ToggleRememberMe ->
            { model | rememberMe = not model.rememberMe }


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
        [ text "Title" ]


renderPage model =
    row
        [ spacing 40
        , height fill
        , width fill
        , explain Debug.todo
        ]
        [ leftMenu
        , pageContent model
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


type Msg
    = ChangeUsername String
    | ClickLogin
    | ChangePassword String
    | ToggleRememberMe


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
text : String -> Element msg
text text_ =
    Element.html <| Html.span [ HA.style "white-space" "pre-wrap" ] [ Html.text text_ ]


{-| Create a paragraph from a single string. This also preserves line breaks, tabs, and extra white space within the string.
-}
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


pageContent model =
    column
        [ width fill
        , height fill
        ]
        [ column [ centerX, centerY ]
            [ paragraph [] [ el [] (text "Latest stuff lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum....") ]
            , paragraph []
                [ Input.text []
                    { onChange = ChangeUsername
                    , text = model.username
                    , placeholder =
                        Just
                            (Input.placeholder []
                                (text "user@email.com")
                            )
                    , label = Input.labelAbove [] (text "Username")
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
                , label = Input.labelAbove [] (text "Password")
                }
            , row [ alignRight ]
                [ Input.checkbox [] <|
                    { onChange = always ToggleRememberMe
                    , label = Input.labelRight [] <| text "Remember me"
                    , checked = model.rememberMe
                    , icon =
                        toggleCheckboxWidget
                            { offColor = lightGrey
                            , onColor = green
                            , sliderColor = white
                            , toggleWidth = 60
                            , toggleHeight = 28
                            }
                    }
                , myButton "Login"
                ]
            , defaultCheckbox True
            , el [ tooltip above (myTooltip "foo") ] (text "foo")
            , el [ tooltip below (myTooltip "bar") ] (text "bar")
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
        column [ height fill, width fill, spacing 20 ]
            [ renderTitle
            , renderPage model
            ]


main : Program () Model Msg
main =
    Browser.sandbox
        { init = initialModel
        , view = view
        , update = update
        }
