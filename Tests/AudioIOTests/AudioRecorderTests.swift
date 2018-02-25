import XCTest
import Observe
import Focus
@testable import AudioIO


class AudioRecorderTests: XCTestCase {
  
  override class func setUp() {
    Focus.defaultReporter().failBlock = XCTFail
  }
  
  func testSpec() {
  }
  
  static var allTests = [("testSpec", testSpec),]
}


