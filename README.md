# SwiftyShakespeareanPokemon

A lightweight Swift client to:
- Fetch the description of a given Pokemon name
- Fetch the image URL of a given Pokemon name
- Translate a given String to a Shakespeare-style sentence
- A `ViewController` to display the relevant Pokemon information.

# Setup

You can integrate this package using Swift Package Manager. Simply add the following to your `Package.swift`:

```
dependencies: [
    .package(url: "https://github.com/WunDaii/SwiftyShakespeareanPokemon.git", .upToNextMajor(from: "1.0.0"))
]
```

# Usage

## Fetch Pokemon Description

```
let pokeAPIClient = PokeAPIClient()
pokeAPIClient.getDescription(
    for: "pikachu") { result in
        
        switch result {
        case .success(let description):
            print(description)
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
```

## Fetch Pokemon Sprite URL

```
let pokeAPIClient = PokeAPIClient()
pokeAPIClient.getSprite(
    for: "pikachu") { result in
        
        switch result {
        case .success(let spriteURL):
            print(spriteURL)
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
```

## Translate text to Shakespearean

```
let shakespeareAPIClient = ShakespeareAPIClient()
shakespeareAPIClient.translate(
    "Hello my name is John Doe") { result in
        
        switch result {
        case .success(let translation):
            print(translation)
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
```

## Displaying the Pokemon Information

You can use the `PokeShakespeareDetailViewController` class to display information about a Pokemon. You can create the class and use it as follows:

```
let pokeShakespeareDetailViewController = SwiftyShakespeareanPokemon.makePokemonDetailView()

pokeShakespeareDetailViewController.titleLabel.text = "pikachu"
pokeShakespeareDetailViewController.detailLabel.text = "Some shakespearean translation."
pokeShakespeareDetailViewController.imageView.image = // UIImage created from the sprite URL.
```

# Dependencies Used
None.

# Architecture

This is a very lightweight client, where the code features the following:
- Dependency injection throughout the classes.
- Separate API client classes to fetch information from different services.
- Human-readable error descriptions using `PokeShakespeareError.localizedDescription`.
- 82% code coverage with unit tests.
- Follows the [Swift API Design Guidelines](https://swift.org/documentation/api-design-guidelines/).

# Future Improvements
With more time, I would:
- Add more unit tests to cover `PokeShakespeareError` - asserting the `errorDescription` value. This would dramatically increate the code coverage.
- Refactor to create a `NetworkingManager` class to handle making network requests rather than have the API client classes use `URLSession` directly.
