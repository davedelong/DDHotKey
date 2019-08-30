import XCTest
import Carbon
@testable import DDHotKey

final class DDHotKeyTests: XCTestCase {
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        let s = string(for: kVK_ANSI_A)
        print("\(s)")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
