# elm shopping cart

example of shopping cart implemented in elm

~for demo [click here](http://krzysu.github.io/elm-shopping-cart/)~ (not yet available)

## getting started

- [install elm](https://guide.elm-lang.org/install.html)
- install dependencies

```sh
elm-package install
```

- start local development server

```sh
elm reactor
```

- build elm to js

```sh
elm-make src/ShoppingCart.elm --output=public/shopping-cart.js
```

- open app after build from `public/index.html`

## TODO
- load products from json
- scripts for
   - build
   - deploy to github pages
- solve loading css for dev and after build
- add unit tests

* * *
author: Kris Urbas [@krzysu](https://twitter.com/krzysu)   
licence: MIT
