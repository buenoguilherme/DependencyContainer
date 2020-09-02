@propertyWrapper struct Injected<Value> {
    let container: DependencyContainer
    var wrappedValue: Value?
    
    init(container: DependencyContainer = .shared) {
        self.container = container
        wrappedValue = try? container.resolve(Value.self)
    }
}
