import XCTest
@testable import DependencyContainer

final class InjectedTests: XCTestCase {
    var sut: DependencyContainer!
    
    override func setUp() {
        sut = DependencyContainer()
        super.setUp()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func test_injectedPropertyWithoutRegister_shouldReturnNil() {
        Enviroment.initialize(container: sut)
        XCTAssertNil(SomeClass().someString)
    }
    
    func test_injectedPropertyWithRegister_shouldReturnRegisteredValue() {
        let expectedDependency = UUID().uuidString
        let factory: () -> String = {
            return expectedDependency
        }
        
        Enviroment.initialize(container: sut)
        sut.register(factory)
        
        XCTAssertEqual(expectedDependency, SomeClass().someString)
    }
    
    func test_injectedPropertyWithDifferentRegisters_shouldReturnRightRegisteredValueByKey() {
        let dependency1 = UUID().uuidString
        let factory1: () -> String = {
            return dependency1
        }
        
        let dependency2 = UUID().uuidString
        let factory2: () -> String = {
            return dependency2
        }
        
        Enviroment.initialize(container: sut)
        sut.register(factory1, forIdentifier: "key1")
        sut.register(factory2, forIdentifier: "key2")
        
        XCTAssertEqual(dependency1, SomeClassWithKey1().someString)
        XCTAssertEqual(dependency2, SomeClassWithKey2().someString)
    }
    
    static var allTests = [
        ("test_injectedPropertyWithoutRegister_shouldReturnNil", test_injectedPropertyWithoutRegister_shouldReturnNil),
        ("test_injectedPropertyWithRegister_shouldReturnRegisteredValue", test_injectedPropertyWithRegister_shouldReturnRegisteredValue)
    ]
    
}

// MARK: - helpers
private final class SomeClass {
    @Injected
    var someString: String?
}

private final class SomeClassWithKey1 {
    @Injected(key: "key1")
    var someString: String?
}

private final class SomeClassWithKey2 {
    @Injected(key: "key2")
    var someString: String?
}
