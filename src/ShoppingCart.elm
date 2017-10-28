module ShoppingCart exposing (..)

import Html exposing (..)
import Html.Events exposing (onClick)
import Html.Attributes exposing (..)
import Http
import Json.Decode as Decode

main =
  Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }

-- MODEL
type alias Product =
  { id : Int
  , name : String
  , price : Float
  , image: String
  }

type alias Model =
  { products : List Product
  , cart : List Product
  }

init : (Model, Cmd Msg)
init =
  (model, getProducts)

model : Model
model =
  { products = []
  , cart = []
  }

-- SUBSCRIPTIONS
subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none

-- CMD
getProducts : Cmd Msg
getProducts =
  let
    request =
      Http.get "products.json" decodeProducts
  in
    Http.send NewProducts request

-- JSON
decodeProducts : Decode.Decoder (List Product)
decodeProducts =
  Decode.list decodeProduct

decodeProduct : Decode.Decoder Product
decodeProduct =
  Decode.map4 Product
    (Decode.field "id" Decode.int)
    (Decode.field "name" Decode.string)
    (Decode.field "price" Decode.float)
    (Decode.field "image" Decode.string)

-- UPDATE
type Msg
  = AddToCart Int
  | RemoveFromCart Int
  | NewProducts (Result Http.Error (List Product))

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    NewProducts (Ok newProducts) ->
      ({ model | products = newProducts }, Cmd.none)

    NewProducts (Err _) ->
      (model, Cmd.none)

    AddToCart productId ->
      let
        products = List.filter (\{ id } -> id == productId) model.products
      in
        ({ model | cart = model.cart ++ products }, Cmd.none)

    RemoveFromCart productId ->
      let
        cart = List.filter (\{ id } -> id /= productId) model.cart
      in
        ({ model | cart = cart }, Cmd.none)

-- VIEW
productPrice : Float -> String
productPrice price =
  toString price ++ " EUR"

isInCart : Product -> List Product -> Bool
isInCart product cart =
  let
    cartOfOneItem = List.filter (\{ id } -> id == product.id) cart
  in
    not (List.isEmpty cartOfOneItem)

view : Model -> Html Msg
view model =
  div [ class "container" ]
    [ div [ class "row" ]
      [ div [ class "col-md-12" ]
        [ h1 []
          [ text "Elm Shopping Cart Example" ]
        ]
      ]
    , div [ class "row" ]
      [ div [ class "col-md-8" ]
        [ h3 [] [text "Products"]
        , div [ class "product-list" ]
          (List.map (\product -> productItemView product model.cart) model.products)
        ]
      , div [ class "col-md-4" ]
        [ h3 [] [text "Shopping cart"]
        , cartView model.cart
        ]
      ]
    , footer []
      [ small []
        [ text "made by "
        , a [ href "https://twitter.com/krzysu" ]
          [ text "Kris Urbas" ]
        , text ", source code available on "
        , a [ href "https://github.com/krzysu/elm-shopping-cart" ]
          [ text "github" ]
        ]
      ]
    ]

productItemView : Product -> List Product -> Html Msg
productItemView product cart =
  let
    inCart = isInCart product cart
  in
    div [ class "product-list__item" ]
      [ div [ class "product thumbnail" ]
        [ img [ src product.image ] []
        , div [ class "caption" ]
          [ h3 [] [text product.name]
          , div [ class "product__price" ]
            [ text (productPrice product.price) ]
          , div [ class "product__button-wrap" ]
            [ button
              [ class (if inCart then "btn btn-danger" else "btn btn-primary")
              , onClick (if inCart then RemoveFromCart product.id else AddToCart product.id)
              ]
              [ text (if inCart then "Remove" else "Add to cart") ]
            ]
          ]
        ]
      ]

cartView : List Product -> Html Msg
cartView products =
  div [ class "cart" ]
    [ div [ class "panel panel-default" ]
      [ div [ class "panel-body" ]
        [ div [] (List.map cartItemView products)
        , if List.isEmpty products then
            div [ class "alert alert-info" ]
              [ text "Cart is empty" ]
          else
            text ""
        , cartTotalView products
        ]
      ]
    ]

cartItemView : Product -> Html Msg
cartItemView productInCart =
  div [ class "cart-item"]
    [ div []
      [ button [ class "btn btn-danger btn-xs", onClick (RemoveFromCart productInCart.id) ] [ text "X" ]
      , span [ class "cart-item__name" ] [ text productInCart.name ]
      ]
    , div [ class "cart-item__price" ] [ text (productPrice productInCart.price) ]
    ]

cartTotalView : List Product -> Html Msg
cartTotalView cart =
  let
    total = List.foldr (+) 0 (List.map (\{ price } -> price) cart)
  in
    div [ class "cart__total" ] [text ("Total: " ++ productPrice total)]
