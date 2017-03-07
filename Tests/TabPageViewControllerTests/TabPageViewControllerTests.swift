import XCTest
@testable import TabPageViewController

class TabPageViewControllerTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertEqual(TabPageViewController().text, "Hello, World!")
    }


    static var allTests : [(String, (TabPageViewControllerTests) -> () throws -> Void)] {
        return [
            ("testExample", testExample),
        ]
    }
}
