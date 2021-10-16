module Main exposing (main)

import Browser
import Html
import Html.Styled exposing (Html, div, img, text, toUnstyled)
import Html.Styled.Attributes exposing (class, src, style)
import Stylesheet
import Time exposing (Posix)



-- MAIN --


main =
    Browser.element
        -- https://package.elm-lang.org/packages/elm/browser/latest/Browser#element
        { init = init_rover
        , update = update
        , view = view
        , subscriptions = subscriptions
        }



-- MESSAGES --


type Msg
    = Tick Posix



-- MODEL --


type Orientation
    = North
    | South
    | East
    | West


type alias Model =
    { posX : Int
    , posY : Int
    , orientation : Orientation
    , mission : String
    , originalMission : String
    }



-- commands will be defined by an hardcoded string in the init function
-- F = Forward
-- B = Backward
-- L = Turn Left (don't move)
-- R = Turn Right (don't move)
-- Don't care with the map size to start


init_rover : () -> ( Model, Cmd Msg )
init_rover () =
    let
        mission =
            "FFFFLFFRBLFFF"
    in
    ( { posX = 0
      , posY = 0
      , orientation = South
      , mission = mission
      , originalMission = mission
      }
    , Cmd.none
    )



-- UPDATE --


orientationToInt : Orientation -> Int
orientationToInt orientation =
    case orientation of
        North ->
            0

        East ->
            90

        West ->
            270

        South ->
            180


orientationFromInt : Int -> Orientation
orientationFromInt angle =
    let
        positiveAngle =
            modBy 360 (angle + 360)
    in
    case positiveAngle of
        0 ->
            North

        90 ->
            East

        270 ->
            West

        _ ->
            South


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Tick epoch ->
            let
                nextStep =
                    String.left 1 model.mission

                remainingMission =
                    String.dropLeft 1 model.mission

                rotation =
                    case nextStep of
                        "L" ->
                            -90

                        "R" ->
                            90

                        _ ->
                            0

                newOrientation =
                    rotation
                        + orientationToInt model.orientation
                        |> Debug.log "New orientation"
                        |> orientationFromInt

                deltaY =
                    case ( model.orientation, nextStep ) of
                        ( North, "F" ) ->
                            -1

                        ( North, "B" ) ->
                            1

                        ( South, "F" ) ->
                            1

                        ( South, "B" ) ->
                            -1

                        _ ->
                            0

                deltaX =
                    case ( model.orientation, nextStep ) of
                        ( East, "F" ) ->
                            1

                        ( East, "B" ) ->
                            -1

                        ( West, "F" ) ->
                            -1

                        ( West, "B" ) ->
                            1

                        _ ->
                            0
            in
            ( { model
                | -- we could loop on the mission, although it was not required
                  -- mission = if String.isEmpty remainingMission then model.originalMission else remainingMission
                  mission = remainingMission
                , orientation = newOrientation
                , posX = model.posX + deltaX + 10 |> modBy 10
                , posY = model.posY + deltaY + 10 |> modBy 10
              }
            , Cmd.none
            )



-- VIEW --


view : Model -> Html.Html Msg
view model =
    toUnstyled <|
        div [ class "main" ]
            [ Stylesheet.styles
            , viewGrid
            , viewRover model
            ]


viewGrid : Html Msg
viewGrid =
    div [ class "horizontal" ] (List.repeat 10 viewColumn)


viewColumn : Html Msg
viewColumn =
    -- https://package.elm-lang.org/packages/elm/core/latest/List#repeat
    div [ class "vertical" ] (List.repeat 10 viewSquare)


viewSquare : Html Msg



-- https://package.elm-lang.org/packages/elm/html/latest/Html


viewSquare =
    div [ class "square large" ] []


viewRover : Model -> Html Msg
viewRover model =
    let
        xIndex =
            model.posX

        yIndex =
            model.posY

        -- N : 180, S : 0, E : 270, W : 90
        orientation =
            orientationToInt model.orientation

        x =
            String.fromInt (xIndex * 64)

        y =
            (yIndex * 64)
                |> String.fromInt

        rotation =
            String.fromInt orientation
    in
    img
        [ src "https://cdn.glitch.com/830a98ce-de36-423e-ac26-b4d5f23b5647%2Frover.png?v=1632642475927"
        , class "rover"
        , style "left" <| x ++ "px"
        , style "top" (y ++ "px")
        , "rotate("
            ++ rotation
            ++ "deg)"
            |> style "transform"
        ]
        []



-- SUBSCRIPTIONS --


subscriptions : Model -> Sub Msg
subscriptions model =
    -- subscription(model:Model) → Sub Msg
    Time.every 500 Tick



-- https://package.elm-lang.org/packages/elm/time/latest/Time#every
