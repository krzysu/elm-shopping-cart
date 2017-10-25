module Tests exposing (..)

import Test exposing (..)
import Expect

import ShoppingCart

-- test helper
mockProduct : Int -> ShoppingCart.Product
mockProduct id =
  ShoppingCart.Product id ("product " ++ toString id) ((toFloat id) * 8) ("images/0" ++ toString id ++ ".jpg")

-- tests
viewHelpers : Test
viewHelpers =
    describe "ShoppingCart view helpers"
        [ test "Renders price with currency" <|
            \_ ->
                Expect.equal "10 EUR" (ShoppingCart.productPrice 10)
        , test "Tests if product is in cart" <|
            \_ ->
                let
                    productInCart = mockProduct 1
                    cart = [ productInCart ]
                in
                    Expect.equal True (ShoppingCart.isInCart productInCart cart)
        , test "Tests if product is in cart, for False value" <|
            \_ ->
                let
                    productInCart = mockProduct 1
                    productNotCart = mockProduct 2
                    cart = [ productInCart ]
                in
                    Expect.equal False (ShoppingCart.isInCart productNotCart cart)
        ]

updateMsg : Test
updateMsg =
    describe "ShoppingCart update messages"
        [ test "AddToCart" <|
            \_ ->
                let
                    product1 = mockProduct 1
                    product2 = mockProduct 2
                    rest = List.range 3 6 |> List.map ShoppingCart.mockProduct
                    model =
                        { products = [ product1 ] ++ [ product2 ] ++ rest
                        , cart = []
                        }

                    newModel = ShoppingCart.update (ShoppingCart.AddToCart 2) model
                in
                    Expect.equalLists [ product2 ] newModel.cart
        , test "RemoveFromCart" <|
            \_ ->
                let
                    product1 = mockProduct 1
                    product2 = mockProduct 2
                    rest = List.range 3 6 |> List.map ShoppingCart.mockProduct
                    model =
                        { products = [ product1 ] ++ [ product2 ] ++ rest
                        , cart = [ product1, product2 ]
                        }

                    newModel = ShoppingCart.update (ShoppingCart.RemoveFromCart 2) model
                in
                    Expect.equalLists [ product1 ] newModel.cart
        ]
