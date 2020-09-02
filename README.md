# DependencyContainer

Usage: 

```swift
let container = DependencyContainer()
DependencyContainer.initializeEnvironment(container: container)

let factory: () -> String = {
    return "some string"
}

container.register(factory)

final class SomeClass {
    @Injected()
    var someString: String?
}

let someClass = SomeClass()
someClass.someString // prints "some string"
```



