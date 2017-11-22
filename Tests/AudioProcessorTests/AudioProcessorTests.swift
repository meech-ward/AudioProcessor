import XCTest
import Observe
import Focus
@testable import AudioProcessor

class AudioProcessorTests: XCTestCase {
    
    override class func setUp() {
        Focus.defaultReporter().failBlock = XCTFail
    }
    
    func testSpec() {
        describe("Person") {
            expect(false).to.be.true();
        }
    }


    static var allTests = [
        ("testSpec", testSpec),
    ]
}
