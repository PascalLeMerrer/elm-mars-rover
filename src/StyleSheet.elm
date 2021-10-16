module Stylesheet exposing (..)

import Css exposing (absolute, alignItems, backgroundColor, backgroundImage, backgroundRepeat, bold, border3, center, color, column, displayFlex, flexDirection, fontSize, fontWeight, height, justifyContent, margin, padding, position, px, rem, repeat, rgb, rgba, row, solid, url, width)
import Css.Global exposing (class, global, typeSelector)
import Html.Styled


styles : Html.Styled.Html msg
styles =
    global
        [ typeSelector "body"
            [ backgroundImage (url "https://cdn.glitch.com/5e0e6389-c2da-4bfd-8866-f0405b6147b3%2FSand.jpg?v=1592913510684")
            , backgroundRepeat repeat
            , margin (px 0)
            , padding (px 0)
            ]
        , class "error"
            [ backgroundColor (rgba 255 255 255 0.8)
            , color (rgb 255 0 0)
            , fontWeight bold
            , fontSize (rem 1.5)
            , margin (px 20)
            , padding (px 5)
            ]
        , class
            "horizontal"
            [ displayFlex
            , flexDirection row
            ]
        , class "main"
            [ displayFlex
            , flexDirection column
            , margin (px 0)
            , padding (px 0)
            ]
        , class "rover"
            [ position absolute
            ]
        , class "square"
            [ displayFlex
            , justifyContent center
            , alignItems center
            , border3 (px 1) solid (rgba 252 245 215 0.8)
            , height (px 58)
            , width (px 58)
            , padding (px 2)
            ]
        , class "vertical"
            [ displayFlex
            , flexDirection column
            ]
        ]
