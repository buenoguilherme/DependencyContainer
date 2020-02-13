import XCTest
@testable import DependencyContainer

final class DependencyContainerTests: XCTestCase {
    func test_register() {
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

    static var allTests = [
        ("test_register", test_register),
        ("test_resolve_without_register", test_resolve_without_register),
    ]
}
