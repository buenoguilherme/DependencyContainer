@propertyWrapper struct Injected<Value> {
    let container: DependencyContainer
    var wrappedValue: Value?
    
    init(key: String? = nil, container: DependencyContainer = Enviroment.shared) {
        self.container = container
        wrappedValue = try? container.resolve(identifier: key, Value.self)
    }
}
