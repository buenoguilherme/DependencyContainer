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
    
    func test_resolveWithoutRegister_shouldThrowError() {
        XCTAssertThrowsError(try sut.resolve(Int.self))
        XCTAssertThrowsError(try sut.resolve(String.self))
        XCTAssertThrowsError(try sut.resolve(Double.self))
        XCTAssertThrowsError(try sut.resolve(DependencyContainer.self))
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
    
    func test_registerASingletonWithSameTypeAndDifferentKeys_shouldResolveDifferentInstances() {
        let factory: () -> SomeClass = {
            return SomeClass()
        }
        
        Enviroment.initialize(container: sut)
        let key1 = UUID().uuidString
        sut.register(factory, forIdentifier: key1, scope: .singleton)
        let key2 = UUID().uuidString
        sut.register(factory, forIdentifier: key2, scope: .singleton)
        
        let firstResolvedDependency = try! sut.resolve(identifier: key1, SomeClass.self)
        let secondResolvedDependency = try! sut.resolve(identifier: key2, SomeClass.self)
        XCTAssert(firstResolvedDependency !== secondResolvedDependency)
    }
    
    func test_registerAPrototypeWithSameTypeAndDifferentKeys_shouldCallDifferentFactories() {
        let factory1: () -> String = {
            return "factory1"
        }
        
        let factory2: () -> String = {
            return "factory2"
        }
        
        Enviroment.initialize(container: sut)
        let key1 = UUID().uuidString
        sut.register(factory1, forIdentifier: key1, scope: .singleton)
        let key2 = UUID().uuidString
        sut.register(factory2, forIdentifier: key2, scope: .singleton)
        

        XCTAssertEqual(try! sut.resolve(identifier: key1, String.self), "factory1")
        XCTAssertEqual(try! sut.resolve(identifier: key2, String.self), "factory2")
    }
    
    static var allTests = [
        ("test_register_and_resolve", test_register_and_resolve),
        ("test_resolveWithoutRegister_shouldThrowError", test_resolveWithoutRegister_shouldThrowError),
        ("test_prototypeRegistering_shouldReturnANewInstanceOnEachUsage", test_prototypeRegistering_shouldReturnANewInstanceOnEachUsage),
        ("test_singletonRegistering_shouldReturnTheSameInstanceEveryTime", test_singletonRegistering_shouldReturnTheSameInstanceEveryTime),
        ("test_registerASingletonWithSameTypeAndDifferentKeys_shouldResolveDifferentInstances", test_registerASingletonWithSameTypeAndDifferentKeys_shouldResolveDifferentInstances)
    ]
    
}

// MARK: - helpers
private final class SomeClass { }
