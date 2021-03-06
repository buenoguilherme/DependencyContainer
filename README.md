# DependencyContainer

## Usage

First of all you will need to initialize the shared environment:
```swift
let container = DependencyContainer()
Environment.initialize(container: container)
```

Then you register what you want to be injected:
```swift
let factory: () -> String = {
    return "some string"
}

container.register(factory)
```

Finally you can use the ```@Injected``` property wrapper to automatically inject that dependency in your code.
```swift
final class SomeClass {
    @Injected
    var someString: String?
}

let someClass = SomeClass()
someClass.someString // "some string"
```



