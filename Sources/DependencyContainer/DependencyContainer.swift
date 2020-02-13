enum DependencyContainerError: Error {
    case dependencyDoesNotExist
    case typeConversion
}

enum Scope {
    case singleton
    case prototype
}

class DependencyContainer {
    typealias DependencyFactory = () -> Any
    
    public static let shared = DependencyContainer()
    
    internal init() {}
    
    var dependencies = [Any]()
    var dependencyFactories = [String: (Scope, DependencyFactory)]()
    
    public func register<T>(
        _ factory: @escaping () -> T,
        forIdentifier identifier: String? = nil,
        scope: Scope = .prototype
    ) {
        let key = identifier ?? String(describing: T.self)
        dependencyFactories[key] = (scope, factory)
    }
    
    public func resolve<T>(identifier: String? = nil, _ typeToResolve: T.Type) throws -> T {
        let key = identifier ?? String(describing: T.self)
        
        guard let (scope, factory) = dependencyFactories[key] else {
            throw DependencyContainerError.dependencyDoesNotExist
        }
        
        let dependency: Any?
        
        switch scope {
        case .prototype:
            dependency = factory()
        default:
            dependency = dependencies.first { $0.self is T.Type }
        }
        
        if let dependency = dependency {
            if let dependency = dependency as? T {
                return dependency
            } else {
                throw DependencyContainerError.typeConversion
            }
        } else {
            throw DependencyContainerError.dependencyDoesNotExist
        }
    }
}

@propertyWrapper
struct Injected<Value> {
    var wrappedValue: Value

    init() {
        wrappedValue = try! DependencyContainer.shared.resolve(Value.self)
    }
}
