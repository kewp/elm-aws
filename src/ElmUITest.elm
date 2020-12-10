module ElmUITest exposing (main)

import Element exposing (..)
import Element.Font as Font
import Element.Region as Region


view =
    column [ height fill, width fill ]
        [ renderTitle
        , renderPage
        ]


renderTitle =
    paragraph
        [ Font.bold
        , Region.heading 1
        , Font.size 36
        , width fill
        , paddingXY 0 40
        ]
        [ text "Title" ]


renderPage =
    row
        [ spacing 40
        , height fill
        , width fill
        , explain Debug.todo
        ]
        [ leftMenu
        , pageContent
        ]


leftMenu =
    column
        [ width fill
        , height fill
        , spacing 20
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


pageContent =
    column
        [ width (fillPortion 3)
        , alignTop
        ]
        [ el [] (text "Latest stuff lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum....")
        ]


main =
    layout [] view
