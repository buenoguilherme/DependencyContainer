import XCTest
@testable import DependencyContainer

final class DependencyContainerTests: XCTestCase {
    func test_register_and_resolve() {
        let container = DependencyContainer()
        
        let expectedDependency = UUID().uuidString
        let factory: () -> String = {
            return expectedDependency
        }
        container.register(factory)
        let returnedDependency = try! container.resolve(String.self)
        
        XCTAssertEqual(expectedDependency, returnedDependency)
    }
    
    func test_resolve_without_register() {
        XCTAssertThrowsError(try DependencyContainer().resolve(Int.self))
        XCTAssertThrowsError(try DependencyContainer().resolve(String.self))
        XCTAssertThrowsError(try DependencyContainer().resolve(Double.self))
        XCTAssertThrowsError(try DependencyContainer().resolve(DependencyContainer.self))
    }
    
    func test_injection() {
        let expectedDependency = UUID().uuidString
        let factory: () -> String = {
            return expectedDependency
        }
        DependencyContainer.shared.register(factory)
        
        XCTAssertEqual(expectedDependency, SomeClass().getSomeString())
    }

    static var allTests = [
        ("test_register_and_resolve", test_register_and_resolve),
        ("test_resolve_without_register", test_resolve_without_register),
    ]
}

class SomeClass {
    @Injected
    private var someString: String
    
    func getSomeString() -> String {
        return someString
    }
}
