import XCTest
import SwiftSequence

class TakeFirstTests: XCTestCase {
  
  var allTests : [(String, () -> ())] {
    return [
      ("testLazyTakeFirst", testLazyTakeFirst),
      ("testLazyTakeFirstN", testLazyTakeFirstN),
    ]
  }
  
  // MARK: Lazy
  
  func testLazyTakeFirst() {
    let taken = [1, 2, 3, 4, 5, 6, 7].lazy.takeFirst { $0 > 4 }
    let expectation = 5
    XCTAssertEqual(taken, expectation)
  }
  
  func testLazyTakeFirstN() {
    let dropped = [1, 2, 3, 4, 5, 6, 7].lazy.takeFirst_n({ $0 > 4 }, take: 2)
    let expectation = [5, 6, 7]
    XCTAssertEqualSeq(dropped, expectation)
  }
  
}