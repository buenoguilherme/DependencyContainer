import Foundation

public final class Environment {
    public private(set) static var shared: DependencyContainer!
    
    private init() {}

    public static func initialize(container: DependencyContainer = .init()) {
        Environment.shared = container
    }
}
