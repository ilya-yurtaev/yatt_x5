module Main exposing (..)

import Dict exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Http
import Json.Decode as JsonDecode
import Time exposing (Time)
import Date exposing (Date)
import Task exposing (Task)
import Date.Extra.Format exposing (utcIsoString)


type alias Record =
    { full_name : String
    , address : String
    , phone : String
    , contact_id : String
    , created_at : String
    }


baseUrl =
    "http://localhost:8080"



---- MODEL ----


type alias Model =
    { records : Dict String Record
    , last_dt : Maybe Date
    }


init : ( Model, Cmd Msg )
init =
    ( { records = Dict.empty
      , last_dt = Nothing
      }
    , fetchRecords Nothing
    )



---- UPDATE ----


type Msg
    = RecordsFetched (Result Http.Error (List Record))
    | SetDt Date
    | Tick Time
    | NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        RecordsFetched (Ok records) ->
            case records of
                x :: xs ->
                    ( { model | records = mergeRecords model.records records }, Task.perform SetDt Date.now )

                [] ->
                    ( model, Cmd.none )

        RecordsFetched (Err _) ->
            ( model, Cmd.none )

        SetDt newDate ->
            ( { model | last_dt = Just newDate }, Cmd.none )

        Tick _ ->
            ( model, fetchRecords model.last_dt )

        NoOp ->
            ( model, Cmd.none )



---- VIEW ----


view : Model -> Html Msg
view model =
    div [ class "container-fluid" ]
        [ div [ class "row" ]
            [ h1 []
                [ text "Das Addressbuch" ]
            , table [ class "table table-sm" ]
                [ tbody [] (recordList (Dict.values model.records)) ]
            ]
        ]


recordList =
    List.sortBy .created_at >> List.map recordView


recordView record =
    tr []
        [ td [] [ Html.text record.full_name ]
        , td [] [ Html.text record.address ]
        , td [] [ Html.text record.phone ]
        ]



---- PROGRAM ----


main : Program Never Model Msg
main =
    Html.program
        { view = view
        , init = init
        , update = update
        , subscriptions = subscriptions
        }


subscriptions model =
    Time.every (5 * Time.second) Tick



--- DECODERS ---


recordDecode =
    JsonDecode.map5 Record
        (JsonDecode.field "full_name" JsonDecode.string)
        (JsonDecode.field "address" JsonDecode.string)
        (JsonDecode.field "phone" JsonDecode.string)
        (JsonDecode.field "contact_id" JsonDecode.string)
        (JsonDecode.field "created_at" JsonDecode.string)


recordsDecode =
    JsonDecode.list recordDecode



--- NETWORK ---


fetch url decoder =
    Http.request
        { method = "GET"
        , headers = []
        , url = baseUrl ++ url
        , body = Http.emptyBody
        , expect = Http.expectJson decoder
        , timeout = Nothing
        , withCredentials = False
        }


fetchRecords mb_date =
    case mb_date of
        Nothing ->
            Http.send RecordsFetched (fetch "/api/v1/phonebook/" recordsDecode)

        Just date ->
            Http.send RecordsFetched (fetch ("/api/v1/phonebook/?created_at__gt=" ++ utcIsoString date) recordsDecode)



--- UTILS ---


mergeRecords d l =
    case l of
        x :: xs ->
            case Dict.get x.contact_id d of
                Just r ->
                    mergeRecords (Dict.insert x.contact_id { r | phone = r.phone ++ ", " ++ x.phone } d) xs

                Nothing ->
                    mergeRecords (Dict.insert x.contact_id x d) xs

        [] ->
            d
