import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(RestlerTests.allTests),
        testCase(NetworkingTests.allTests)
    ]
}
#endif
