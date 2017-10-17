import Html exposing (..)
import Html.Events exposing (onClick)
import Html.Attributes exposing (..)

main =
  Html.beginnerProgram { model = model, view = view, update = update }

-- MODEL
type alias Product =
  { id : Int
  , name : String
  , price : Float
  , inCart : Bool
  }

type alias Model =
  { products : List Product -- read only
  , cart : List Product
  }

model : Model
model =
  { products = List.range 1 10 |> List.map mockProduct
  , cart = []
  }

mockProduct : Int -> Product
mockProduct id =
  Product id ("product " ++ toString id) ((toFloat id) * 8) False

-- UPDATE
type Msg
  = AddToCart Int
  | RemoveFromCart Int

update : Msg -> Model -> Model
update msg model =
  case msg of
    AddToCart productId ->
      let
        products = List.filter (\{ id } -> id == productId) model.products
      in
        { model | cart = model.cart ++ products }

    RemoveFromCart productId ->
      let
        cart = List.filter (\{ id } -> id /= productId) model.cart
      in
        { model | cart = cart }

-- VIEW
view : Model -> Html Msg
view model =
  div [style [("display", "flex"), ("justifyContent", "space-around")]]
    [ div [] [
        h2 [] [text "Products"]
        , div [] (List.map productView model.products)
      ]
    , div [] [
        h2 [] [text "Shopping cart"]
        , div [] (List.map cartView model.cart)
        , cartTotalView model.cart
      ]
    ]

productView : Product -> Html Msg
productView product =
  div [style [("border", "1px solid grey"), ("margin", "0 0 10px")]]
    [ div [] [text product.name]
    , div [] [text ("price: " ++ toString product.price)]
    , button
        [onClick (AddToCart product.id)]
        [text (if product.inCart then "Remove" else "Add")]
    ]

cartView : Product -> Html Msg
cartView product =
  div [style [("display", "flex"), ("justifyContent", "space-between")]]
    [ div [] [text product.name]
    , div [] [text ("price: " ++ toString product.price)]
    ]

cartTotalView : List Product -> Html Msg
cartTotalView cart =
  let
    total = List.foldr (+) 0 (List.map (\{ price } -> price) cart)
  in
    div [] [text ("Total: " ++ toString total)]
