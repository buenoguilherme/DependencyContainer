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
    
    public init() {}
    
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
        
        var dependency: Any
        
        switch scope {
        case .singleton:
            if let dep = dependencies.first(where: { $0 is T }) {
                dependency = dep
            } else {
                dependency = factory()
                dependencies.append(dependency)
            }
        case .prototype:
            dependency = factory()
        }
        
        if let dependency = dependency as? T {
            return dependency
        } else {
            throw Error.typeConversion
        } 
    }
}
