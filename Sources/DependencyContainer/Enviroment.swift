import Foundation

public final class Enviroment {
    public private(set) static var shared: DependencyContainer!
    
    private init() {}

    public static func initialize(container: DependencyContainer = .init()) {
        Enviroment.shared = container
    }
}
