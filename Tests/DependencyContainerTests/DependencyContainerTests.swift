import XCTest
@testable import DependencyContainer

final class DependencyContainerTests: XCTestCase {
    var sut: DependencyContainer!
    
    override func setUp() {
        sut = DependencyContainer()
        super.setUp()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func test_register_and_resolve() {
        let expectedDependency = UUID().uuidString
        let factory: () -> String = {
            return expectedDependency
        }
        sut.register(factory)
        let returnedDependency = try! sut.resolve(String.self)
        
        XCTAssertEqual(expectedDependency, returnedDependency)
    }
    
    func test_resolve_without_register() {
        XCTAssertThrowsError(try sut.resolve(Int.self))
        XCTAssertThrowsError(try sut.resolve(String.self))
        XCTAssertThrowsError(try sut.resolve(Double.self))
        XCTAssertThrowsError(try sut.resolve(DependencyContainer.self))
    }
    
    func test_injection() {
        let expectedDependency = UUID().uuidString
        let factory: () -> String = {
            return expectedDependency
        }
        
        Enviroment.initialize(container: sut)
        sut.register(factory)
        
        XCTAssertEqual(expectedDependency, SomeClass().someString)
    }
    
    func test_prototypeRegistering_shouldReturnANewInstanceOnEachUsage() {
        let factory: () -> SomeClass = {
            return SomeClass()
        }
        
        Enviroment.initialize(container: sut)
        sut.register(factory, scope: .prototype)
        
        let firstResolvedDependency = try! sut.resolve(SomeClass.self)
        let secondResolvedDependency = try! sut.resolve(SomeClass.self)
        XCTAssert(firstResolvedDependency !== secondResolvedDependency)
    }
    
    func test_singletonRegistering_shouldReturnTheSameInstanceEveryTime() {
        let factory: () -> SomeClass = {
            return SomeClass()
        }
        
        Enviroment.initialize(container: sut)
        sut.register(factory, scope: .singleton)
        
        let firstResolvedDependency = try! sut.resolve(SomeClass.self)
        let secondResolvedDependency = try! sut.resolve(SomeClass.self)
        XCTAssert(firstResolvedDependency === secondResolvedDependency)
    }
    
    func test_injected_without_register() {
        Enviroment.initialize(container: sut)
        XCTAssertNil(SomeClass().someString)
    }
    
    static var allTests = [
        ("test_register_and_resolve", test_register_and_resolve),
        ("test_resolve_without_register", test_resolve_without_register),
        ("test_injection", test_injection),
        ("test_injected_without_register", test_injected_without_register)
    ]
    
}

// MARK: - helpers
final class SomeClass {
    @Injected
    var someString: String?
}
