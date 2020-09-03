@propertyWrapper public struct Injected<Value> {
    let container: DependencyContainer
    public var wrappedValue: Value?
    
    public init(key: String? = nil, container: DependencyContainer = Environment.shared) {
        self.container = container
        wrappedValue = try? container.resolve(identifier: key, Value.self)
    }
}
