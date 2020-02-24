import XCTest
@testable import Restler

class NetworkingTests: XCTestCase {
    static var allTests = [
        ("testMakeRequest_makesProperRequest", testMakeRequest_makesProperRequest),
        ("testMakeRequest_successfulResponse", testMakeRequest_successfulResponse),
        ("testMakeRequest_noResponse", testMakeRequest_noResponse),
        ("testMakeRequest_notFoundResponse", testMakeRequest_notFoundResponse),
        ("testMakeRequest_responseNotNil", testMakeRequest_responseNotNil),
        ("testMakeRequest_noDataInResponse", testMakeRequest_noDataInResponse)
    ]
    
    private var session: URLSessionMock!
    
    // MARK: - Setup
    override func setUp() {
        super.setUp()
        self.session = URLSessionMock()
    }
}

// MARK: - makeRequest(url:method:completion:)
extension NetworkingTests {
    func testMakeRequest_makesProperRequest() throws {
        //Arrange
        let sut = self.buildSUT()
        let url = try XCTUnwrap(URL(string: "https://www.example.com"))
        let queryParameters = ["some": "key", "another": "key1"]
        var completionResult: Result<Data, Error>?
        //Act
        sut.makeRequest(url: url, method: .get(query: queryParameters)) { result in
            completionResult = result
        }
        //Assert
        XCTAssertEqual(self.session.dataTaskParams.count, 1)
        XCTAssertTrue(try XCTUnwrap(self.session.dataTaskParams.last?.request.url?.query?.contains("some=key")))
        XCTAssertTrue(try XCTUnwrap(self.session.dataTaskParams.last?.request.url?.query?.contains("another=key1")))
        XCTAssertTrue(try XCTUnwrap(self.session.dataTaskParams.last?.request.url?.absoluteString.starts(with: "https://www.example.com")))
        XCTAssertNil(completionResult)
        XCTAssertEqual(self.session.dataTaskReturnValue.resumeParams.count, 1)
    }
    
    func testMakeRequest_successfulResponse() throws {
        //Arrange
        let sut = self.buildSUT()
        let url = try XCTUnwrap(URL(string: "https://www.example.com"))
        let mockResponse = HTTPURLResponseMock()
        mockResponse.isSuccessfulReturnValue = true
        let responseData = Data()
        var completionResult: Result<Data, Error>?
        //Act
        sut.makeRequest(url: url, method: .get(query: [:])) { result in
            completionResult = result
        }
        try XCTUnwrap(self.session.dataTaskParams.last).completion(HTTPRequestResponse(data: responseData, response: mockResponse, error: nil))
        //Assert
        XCTAssertEqual(try XCTUnwrap(completionResult).get(), responseData)
    }
    
    func testMakeRequest_noResponse() throws {
        //Arrange
        let sut = self.buildSUT()
        let url = try XCTUnwrap(URL(string: "https://www.example.com"))
        let responseData = Data()
        var completionResult: Result<Data, Error>?
        //Act
        sut.makeRequest(url: url, method: .get(query: [:])) { result in
            completionResult = result
        }
        try XCTUnwrap(self.session.dataTaskParams.last).completion(HTTPRequestResponse(data: responseData, response: nil, error: nil))
        //Assert
        AssertResult(try XCTUnwrap(completionResult), errorCaseIs: Restler.Error.noInternetConnection)
    }
    
    func testMakeRequest_notFoundResponse() throws {
        //Arrange
        let sut = self.buildSUT()
        let url = try XCTUnwrap(URL(string: "https://www.example.com"))
        let mockResponse = HTTPURLResponseMock()
        mockResponse.isSuccessfulReturnValue = false
        mockResponse.statusCodeReturnValue = 404
        let responseData = Data()
        var completionResult: Result<Data, Error>?
        //Act
        sut.makeRequest(url: url, method: .get(query: [:])) { result in
            completionResult = result
        }
        try XCTUnwrap(self.session.dataTaskParams.last).completion(HTTPRequestResponse(data: responseData, response: mockResponse, error: nil))
        //Assert
        AssertResult(try XCTUnwrap(completionResult), errorCaseIs: Restler.Error.notFound)
    }
    
    func testMakeRequest_responseNotNil() throws {
        //Arrange
        let sut = self.buildSUT()
        let url = try XCTUnwrap(URL(string: "https://www.example.com"))
        let mockResponse = HTTPURLResponseMock()
        mockResponse.isSuccessfulReturnValue = true
        let responseData = Data()
        var completionResult: Result<Data, Error>?
        //Act
        sut.makeRequest(url: url, method: .get(query: [:])) { result in
            completionResult = result
        }
        try XCTUnwrap(self.session.dataTaskParams.last).completion(HTTPRequestResponse(data: responseData, response: mockResponse, error: TestError()))
        //Assert
        AssertResult(try XCTUnwrap(completionResult), errorCaseIs: Restler.Error.unknownError)
    }
    
    func testMakeRequest_noDataInResponse() throws {
        //Arrange
        let sut = self.buildSUT()
        let url = try XCTUnwrap(URL(string: "https://www.example.com"))
        let mockResponse = HTTPURLResponseMock()
        mockResponse.isSuccessfulReturnValue = true
        var completionResult: Result<Data, Error>?
        //Act
        sut.makeRequest(url: url, method: .get(query: [:])) { result in
            completionResult = result
        }
        try XCTUnwrap(self.session.dataTaskParams.last).completion(HTTPRequestResponse(data: nil, response: mockResponse, error: nil))
        //Assert
        AssertResult(try XCTUnwrap(completionResult), errorCaseIs: Restler.Error.unknownError)
    }
}

// MARK: - Private
extension NetworkingTests {
    private func buildSUT() -> Networking {
        return Networking(session: self.session)
    }
}
