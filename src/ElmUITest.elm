module ElmUITest exposing (main)

import Browser
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Element.Region as Region
import Html.Attributes as HA


type alias Model =
    { toggle : Bool }


initialModel : Model
initialModel =
    { toggle = False }


update : Msg -> Model -> Model
update msg model =
    case msg of
        Change _ ->
            model

        Toggle ->
            { model | toggle = not model.toggle }


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
    = Change String
    | Toggle


defaultCheckbox : Bool -> Element msg
defaultCheckbox checked =
    Element.el
        [ --Internal.htmlClass "focusable"
          Element.width
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


pageContent model =
    column
        [ width fill
        , height fill
        ]
        [ column [ centerX, centerY ]
            [ paragraph [] [ el [] (text "Latest stuff lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum....") ]
            , paragraph []
                [ Input.text []
                    { onChange = Change
                    , text = "hello"
                    , placeholder =
                        Just
                            (Input.placeholder []
                                (text "type some text here and press enter")
                            )
                    , label = Input.labelAbove [] (text "Hello")
                    }
                ]
            , Input.checkbox [] <|
                { onChange = always Toggle
                , label = Input.labelHidden "Activer/Désactiver le partage"
                , checked = model.toggle
                , icon =
                    toggleCheckboxWidget
                        { offColor = lightGrey
                        , onColor = green
                        , sliderColor = white
                        , toggleWidth = 60
                        , toggleHeight = 28
                        }
                }
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
