public class DependencyContainer {
    public typealias DependencyFactory = () -> Any
    
    public enum Error: Swift.Error {
        case dependencyDoesNotExist
        case typeConversion
    }

    public enum Scope {
        case singleton
        case prototype
    }
    
    public static var shared: () -> DependencyContainer = { DependencyContainer() }
    
    internal init() {}
    
    private var dependencies = [Any]()
    private var dependencyFactories = [String: (Scope, DependencyFactory)]()
    
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
            throw Error.dependencyDoesNotExist
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
                throw Error.typeConversion
            }
        } else {
            throw Error.dependencyDoesNotExist
        }
    }
}
