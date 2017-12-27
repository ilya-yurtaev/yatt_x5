module Main exposing (..)

import Dict exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode as JsonDecode


type alias Record =
    { full_name : String
    , address : String
    , value : String
    , contact_id : String
    }


baseUrl =
    "http://localhost:8080"



---- MODEL ----


type alias Model =
    { records : Dict String Record
    }


init : ( Model, Cmd Msg )
init =
    ( { records = Dict.empty }, preloadRecords )



---- UPDATE ----


type Msg
    = RecordsFetched (Result Http.Error (List Record))
    | NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        RecordsFetched (Ok records) ->
            ( { model | records = mergeRecords model.records records }, Cmd.none )

        RecordsFetched (Err _) ->
            ( model, Cmd.none )

        NoOp ->
            ( model, Cmd.none )



---- VIEW ----


view : Model -> Html Msg
view model =
    div []
        [ h1 []
            [ text "Das Addressbuch" ]
        , table [ class "table" ]
            [ tbody [] (recordList (Dict.values model.records)) ]
        ]


recordList records =
    List.map recordView records


recordView record =
    tr []
        [ td [] [ Html.text record.full_name ]
        , td [] [ Html.text record.address ]
        , td [] [ Html.text record.value ]
        ]



---- PROGRAM ----


main : Program Never Model Msg
main =
    Html.program
        { view = view
        , init = init
        , update = update
        , subscriptions = always Sub.none
        }



--- DECODERS ---


recordDecode =
    JsonDecode.map4 Record
        (JsonDecode.field "full_name" JsonDecode.string)
        (JsonDecode.field "address" JsonDecode.string)
        (JsonDecode.field "value" JsonDecode.string)
        (JsonDecode.field "contact_id" JsonDecode.string)


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


preloadRecords =
    Http.send RecordsFetched (fetch "/api/v1/phonebook/" recordsDecode)



--- UTILS ---


mergeRecords d l =
    case l of
        x :: xs ->
            case Dict.get x.contact_id d of
                Just r ->
                    mergeRecords (Dict.insert x.contact_id { r | value = r.value ++ ", " ++ x.value } d) xs

                Nothing ->
                    mergeRecords (Dict.insert x.contact_id x d) xs

        [] ->
            d
