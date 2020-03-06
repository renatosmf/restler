import XCTest
@testable import Restler

class InterfaceIntegrationTests: XCTestCase {
    private let baseURL = URL(string: "https://example.com")!
    private let endpoint = EndpointMock.mock
    private var networking: NetworkingMock!
    private var dispatchQueueManager: DispatchQueueManagerMock!
    
    private var mockURLString: String {
        return self.baseURL.absoluteString + "/mock"
    }

    override func setUp() {
        super.setUp()
        self.networking = NetworkingMock()
        self.dispatchQueueManager = DispatchQueueManagerMock()
    }
}

// MARK: - GET
extension InterfaceIntegrationTests {
    func testGetVoid_buildingRequest_encodingQuery() throws {
        //Arrange
        let sut = self.buildSUT()
        var completionResult: Restler.VoidResult?
        //Act
        _ = sut
            .get(self.endpoint)
            .query(SomeObject(id: 1, name: "name"))
            .decode(Void.self)
            .onCompletion({ completionResult = $0 })
            .start()
        //Assert
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        let requestParams = try XCTUnwrap(self.networking.makeRequestParams.first)
        XCTAssertEqual(requestParams.url.absoluteString, self.mockURLString)
        XCTAssertEqual(requestParams.method, .get(query: ["id": "1", "name": "name"]))
        XCTAssertNil(completionResult)
    }
    
    func testGetVoid_buildingRequest_encodingQueryFails() throws {
        //Arrange
        let sut = self.buildSUT()
        let object = ThrowingObject()
        let expectedError = TestError()
        object.thrownError = expectedError
        var returnedError: Error?
        var decodedObject: Void?
        var completionResult: Restler.VoidResult?
        //Act
        _ = sut
            .get(self.endpoint)
            .query(object)
            .decode(Void.self)
            .onFailure({ returnedError = $0 })
            .onSuccess({ decodedObject = $0 })
            .onCompletion({ completionResult = $0 })
            .start()
        self.dispatchQueueManager.performParams.forEach { $0.action() }
        //Assert
        XCTAssertEqual(self.dispatchQueueManager.performParams.count, 1)
        XCTAssertEqual(self.networking.makeRequestParams.count, 0)
        XCTAssertNil(decodedObject)
        try self.assertThrowsEncodingError(expected: expectedError, returnedError: returnedError, completionResult: completionResult)
    }
    
    func testGetVoid_buildingRequest_encodingBody() throws {
        //Arrange
        let sut = self.buildSUT()
        var completionResult: Restler.VoidResult?
        //Act
        _ = sut
            .get(self.endpoint)
            .body(SomeObject(id: 1, name: "name"))
            .decode(Void.self)
            .onCompletion({ completionResult = $0 })
            .start()
        //Assert
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        let requestParams = try XCTUnwrap(self.networking.makeRequestParams.first)
        XCTAssertEqual(requestParams.url.absoluteString, self.mockURLString)
        XCTAssertEqual(requestParams.method, .get(query: [:]))
        XCTAssertNil(completionResult)
    }
    
    func testGetVoid_buildingRequest_encodingBodyFails() throws {
        //Arrange
        let sut = self.buildSUT()
        let object = ThrowingObject()
        let expectedError = TestError()
        object.thrownError = expectedError
        var returnedError: Error?
        var decodedObject: Void?
        var completionResult: Restler.VoidResult?
        //Act
        _ = sut
            .get(self.endpoint)
            .body(object)
            .decode(Void.self)
            .onFailure({ returnedError = $0 })
            .onSuccess({ decodedObject = $0 })
            .onCompletion({ completionResult = $0 })
            .start()
        self.dispatchQueueManager.performParams.forEach { $0.action() }
        //Assert
        XCTAssertEqual(self.dispatchQueueManager.performParams.count, 1)
        XCTAssertEqual(self.networking.makeRequestParams.count, 0)
        XCTAssertNil(decodedObject)
        try self.assertThrowsEncodingError(expected: expectedError, returnedError: returnedError, completionResult: completionResult)
    }
    
    func testGetOptionalDecodable_buildingRequest_encodingQuery() throws {
        //Arrange
        let sut = self.buildSUT()
        var completionResult: Restler.DecodableResult<SomeObject?>?
        //Act
        _ = sut
            .get(self.endpoint)
            .query(SomeObject(id: 1, name: "name"))
            .decode(SomeObject?.self)
            .onCompletion({ completionResult = $0 })
            .start()
        //Assert
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        let requestParams = try XCTUnwrap(self.networking.makeRequestParams.first)
        XCTAssertEqual(requestParams.url.absoluteString, self.mockURLString)
        XCTAssertEqual(requestParams.method, .get(query: ["id": "1", "name": "name"]))
        XCTAssertNil(completionResult)
    }
    
    func testGetOptionalDecodable_buildingRequest_encodingQueryFails() throws {
        //Arrange
        let sut = self.buildSUT()
        let object = ThrowingObject()
        let expectedError = TestError()
        object.thrownError = expectedError
        var returnedError: Error?
        var decodedObject: SomeObject?
        var completionResult: Restler.DecodableResult<SomeObject?>?
        //Act
        _ = sut
            .get(self.endpoint)
            .query(object)
            .decode(SomeObject?.self)
            .onFailure({ returnedError = $0 })
            .onSuccess({ decodedObject = $0 })
            .onCompletion({ completionResult = $0 })
            .start()
        self.dispatchQueueManager.performParams.forEach { $0.action() }
        //Assert
        XCTAssertEqual(self.dispatchQueueManager.performParams.count, 1)
        XCTAssertEqual(self.networking.makeRequestParams.count, 0)
        XCTAssertNil(decodedObject)
        try self.assertThrowsEncodingError(expected: expectedError, returnedError: returnedError, completionResult: completionResult)
    }
    
    func testGetDecodable_buildingRequest_encodingQuery() throws {
        //Arrange
        let sut = self.buildSUT()
        var completionResult: Restler.DecodableResult<SomeObject>?
        //Act
        _ = sut
            .get(self.endpoint)
            .query(SomeObject(id: 1, name: "name"))
            .decode(SomeObject.self)
            .onCompletion({ completionResult = $0 })
            .start()
        //Assert
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        let requestParams = try XCTUnwrap(self.networking.makeRequestParams.first)
        XCTAssertEqual(requestParams.url.absoluteString, self.mockURLString)
        XCTAssertEqual(requestParams.method, .get(query: ["id": "1", "name": "name"]))
        XCTAssertNil(completionResult)
    }
    
    func testGetDecodable_buildingRequest_encodingQueryFails() throws {
        //Arrange
        let sut = self.buildSUT()
        let object = ThrowingObject()
        let expectedError = TestError()
        object.thrownError = expectedError
        var returnedError: Error?
        var decodedObject: SomeObject?
        var completionResult: Restler.DecodableResult<SomeObject>?
        //Act
        _ = sut
            .get(self.endpoint)
            .query(object)
            .decode(SomeObject.self)
            .onFailure({ returnedError = $0 })
            .onSuccess({ decodedObject = $0 })
            .onCompletion({ completionResult = $0 })
            .start()
        self.dispatchQueueManager.performParams.forEach { $0.action() }
        //Assert
        XCTAssertEqual(self.dispatchQueueManager.performParams.count, 1)
        XCTAssertEqual(self.networking.makeRequestParams.count, 0)
        XCTAssertNil(decodedObject)
        try self.assertThrowsEncodingError(expected: expectedError, returnedError: returnedError, completionResult: completionResult)
    }
}

// MARK: - POST
extension InterfaceIntegrationTests {
    func testPostVoid_buildingRequest_encodingQuery() throws {
        //Arrange
        let sut = self.buildSUT()
        var completionResult: Restler.VoidResult?
        //Act
        _ = sut
            .post(self.endpoint)
            .query(SomeObject(id: 1, name: "name"))
            .decode(Void.self)
            .onCompletion({ completionResult = $0 })
            .start()
        //Assert
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        let requestParams = try XCTUnwrap(self.networking.makeRequestParams.first)
        XCTAssertEqual(requestParams.url.absoluteString, self.mockURLString)
        XCTAssertEqual(requestParams.method, .post(content: nil))
        XCTAssertNil(completionResult)
    }
    
    func testPostVoid_buildingRequest_encodingQueryFails() throws {
        //Arrange
        let sut = self.buildSUT()
        let object = ThrowingObject()
        let expectedError = TestError()
        object.thrownError = expectedError
        var returnedError: Error?
        var decodedObject: Void?
        var completionResult: Restler.VoidResult?
        //Act
        _ = sut
            .post(self.endpoint)
            .query(object)
            .decode(Void.self)
            .onFailure({ returnedError = $0 })
            .onSuccess({ decodedObject = $0 })
            .onCompletion({ completionResult = $0 })
            .start()
        self.dispatchQueueManager.performParams.forEach { $0.action() }
        //Assert
        XCTAssertEqual(self.dispatchQueueManager.performParams.count, 1)
        XCTAssertEqual(self.networking.makeRequestParams.count, 0)
        XCTAssertNil(decodedObject)
        try self.assertThrowsEncodingError(expected: expectedError, returnedError: returnedError, completionResult: completionResult)
    }

    func testPostVoid_buildingRequest_encodingBody() throws {
        //Arrange
        let sut = self.buildSUT()
        let object = SomeObject(id: 1, name: "name")
        let data = try JSONEncoder().encode(object)
        var completionResult: Restler.VoidResult?
        //Act
        _ = sut
            .post(self.endpoint)
            .body(object)
            .decode(Void.self)
            .onCompletion({ completionResult = $0 })
            .start()
        //Assert
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        let requestParams = try XCTUnwrap(self.networking.makeRequestParams.first)
        XCTAssertEqual(requestParams.url.absoluteString, self.mockURLString)
        XCTAssertEqual(requestParams.method, .post(content: data))
        XCTAssertNil(completionResult)
    }

    func testPostVoid_buildingRequest_encodingBodyFails() throws {
        //Arrange
        let sut = self.buildSUT()
        let object = ThrowingObject()
        let expectedError = TestError()
        object.thrownError = expectedError
        var returnedError: Error?
        var decodedObject: Void?
        var completionResult: Restler.VoidResult?
        //Act
        _ = sut
            .post(self.endpoint)
            .body(object)
            .decode(Void.self)
            .onFailure({ returnedError = $0 })
            .onSuccess({ decodedObject = $0 })
            .onCompletion({ completionResult = $0 })
            .start()
        self.dispatchQueueManager.performParams.forEach { $0.action() }
        //Assert
        XCTAssertEqual(self.dispatchQueueManager.performParams.count, 1)
        XCTAssertEqual(self.networking.makeRequestParams.count, 0)
        XCTAssertNil(decodedObject)
        try self.assertThrowsEncodingError(expected: expectedError, returnedError: returnedError, completionResult: completionResult)
    }
    
    func testPostOptionalDecodable_buildingRequest_encodingBody() throws {
        //Arrange
        let sut = self.buildSUT()
        let object = SomeObject(id: 1, name: "name")
        let data = try JSONEncoder().encode(object)
        var completionResult: Restler.DecodableResult<SomeObject?>?
        //Act
        _ = sut
            .post(self.endpoint)
            .body(object)
            .decode(SomeObject?.self)
            .onCompletion({ completionResult = $0 })
            .start()
        //Assert
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        let requestParams = try XCTUnwrap(self.networking.makeRequestParams.first)
        XCTAssertEqual(requestParams.url.absoluteString, self.mockURLString)
        XCTAssertEqual(requestParams.method, .post(content: data))
        XCTAssertNil(completionResult)
    }
    
    func testPostOptionalDecodable_buildingRequest_encodingBodyFails() throws {
        //Arrange
        let sut = self.buildSUT()
        let object = ThrowingObject()
        let expectedError = TestError()
        object.thrownError = expectedError
        var returnedError: Error?
        var decodedObject: SomeObject?
        var completionResult: Restler.DecodableResult<SomeObject?>?
        //Act
        _ = sut
            .post(self.endpoint)
            .body(object)
            .decode(SomeObject?.self)
            .onFailure({ returnedError = $0 })
            .onSuccess({ decodedObject = $0 })
            .onCompletion({ completionResult = $0 })
            .start()
        self.dispatchQueueManager.performParams.forEach { $0.action() }
        //Assert
        XCTAssertEqual(self.dispatchQueueManager.performParams.count, 1)
        XCTAssertEqual(self.networking.makeRequestParams.count, 0)
        XCTAssertNil(decodedObject)
        try self.assertThrowsEncodingError(expected: expectedError, returnedError: returnedError, completionResult: completionResult)
    }
    
    func testPostDecodable_buildingRequest_encodingBody() throws {
        //Arrange
        let sut = self.buildSUT()
        let object = SomeObject(id: 1, name: "name")
        let data = try JSONEncoder().encode(object)
        var completionResult: Restler.DecodableResult<SomeObject>?
        //Act
        _ = sut
            .post(self.endpoint)
            .body(object)
            .decode(SomeObject.self)
            .onCompletion({ completionResult = $0 })
            .start()
        //Assert
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        let requestParams = try XCTUnwrap(self.networking.makeRequestParams.first)
        XCTAssertEqual(requestParams.url.absoluteString, self.mockURLString)
        XCTAssertEqual(requestParams.method, .post(content: data))
        XCTAssertNil(completionResult)
    }
    
    func testPostDecodable_buildingRequest_encodingBodyFails() throws {
        //Arrange
        let sut = self.buildSUT()
        let object = ThrowingObject()
        let expectedError = TestError()
        object.thrownError = expectedError
        var returnedError: Error?
        var decodedObject: SomeObject?
        var completionResult: Restler.DecodableResult<SomeObject>?
        //Act
        _ = sut
            .post(self.endpoint)
            .body(object)
            .decode(SomeObject.self)
            .onFailure({ returnedError = $0 })
            .onSuccess({ decodedObject = $0 })
            .onCompletion({ completionResult = $0 })
            .start()
        self.dispatchQueueManager.performParams.forEach { $0.action() }
        //Assert
        XCTAssertEqual(self.dispatchQueueManager.performParams.count, 1)
        XCTAssertEqual(self.networking.makeRequestParams.count, 0)
        XCTAssertNil(decodedObject)
        try self.assertThrowsEncodingError(expected: expectedError, returnedError: returnedError, completionResult: completionResult)
    }
}

// MARK: - PUT
extension InterfaceIntegrationTests {
    func testPutVoid_buildingRequest_encodingQuery() throws {
        //Arrange
        let sut = self.buildSUT()
        var completionResult: Restler.VoidResult?
        //Act
        _ = sut
            .put(self.endpoint)
            .query(SomeObject(id: 1, name: "name"))
            .decode(Void.self)
            .onCompletion({ completionResult = $0 })
            .start()
        //Assert
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        let requestParams = try XCTUnwrap(self.networking.makeRequestParams.first)
        XCTAssertEqual(requestParams.url.absoluteString, self.mockURLString)
        XCTAssertEqual(requestParams.method, .put(content: nil))
        XCTAssertNil(completionResult)
    }
    
    func testPutVoid_buildingRequest_encodingQueryFails() throws {
        //Arrange
        let sut = self.buildSUT()
        let object = ThrowingObject()
        let expectedError = TestError()
        object.thrownError = expectedError
        var returnedError: Error?
        var decodedObject: Void?
        var completionResult: Restler.VoidResult?
        //Act
        _ = sut
            .put(self.endpoint)
            .query(object)
            .decode(Void.self)
            .onFailure({ returnedError = $0 })
            .onSuccess({ decodedObject = $0 })
            .onCompletion({ completionResult = $0 })
            .start()
        self.dispatchQueueManager.performParams.forEach { $0.action() }
        //Assert
        XCTAssertEqual(self.dispatchQueueManager.performParams.count, 1)
        XCTAssertEqual(self.networking.makeRequestParams.count, 0)
        XCTAssertNil(decodedObject)
        try self.assertThrowsEncodingError(expected: expectedError, returnedError: returnedError, completionResult: completionResult)
    }
    
    func testPutVoid_buildingRequest_encodingBody() throws {
        //Arrange
        let sut = self.buildSUT()
        let object = SomeObject(id: 1, name: "name")
        let data = try JSONEncoder().encode(object)
        var completionResult: Restler.VoidResult?
        //Act
        _ = sut
            .put(self.endpoint)
            .body(object)
            .decode(Void.self)
            .onCompletion({ completionResult = $0 })
            .start()
        //Assert
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        let requestParams = try XCTUnwrap(self.networking.makeRequestParams.first)
        XCTAssertEqual(requestParams.url.absoluteString, self.mockURLString)
        XCTAssertEqual(requestParams.method, .put(content: data))
        XCTAssertNil(completionResult)
    }
    
    func testPutVoid_buildingRequest_encodingBodyFails() throws {
        //Arrange
        let sut = self.buildSUT()
        let object = ThrowingObject()
        let expectedError = TestError()
        object.thrownError = expectedError
        var returnedError: Error?
        var decodedObject: Void?
        var completionResult: Restler.VoidResult?
        //Act
        _ = sut
            .put(self.endpoint)
            .body(object)
            .decode(Void.self)
            .onFailure({ returnedError = $0 })
            .onSuccess({ decodedObject = $0 })
            .onCompletion({ completionResult = $0 })
            .start()
        self.dispatchQueueManager.performParams.forEach { $0.action() }
        //Assert
        XCTAssertEqual(self.dispatchQueueManager.performParams.count, 1)
        XCTAssertEqual(self.networking.makeRequestParams.count, 0)
        XCTAssertNil(decodedObject)
        try self.assertThrowsEncodingError(expected: expectedError, returnedError: returnedError, completionResult: completionResult)
    }
    
    func testPutOptionalDecodable_buildingRequest_encodingBody() throws {
        //Arrange
        let sut = self.buildSUT()
        let object = SomeObject(id: 1, name: "name")
        let data = try JSONEncoder().encode(object)
        var completionResult: Restler.DecodableResult<SomeObject?>?
        //Act
        _ = sut
            .put(self.endpoint)
            .body(object)
            .decode(SomeObject?.self)
            .onCompletion({ completionResult = $0 })
            .start()
        //Assert
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        let requestParams = try XCTUnwrap(self.networking.makeRequestParams.first)
        XCTAssertEqual(requestParams.url.absoluteString, self.mockURLString)
        XCTAssertEqual(requestParams.method, .put(content: data))
        XCTAssertNil(completionResult)
    }
    
    func testPutOptionalDecodable_buildingRequest_encodingBodyFails() throws {
        //Arrange
        let sut = self.buildSUT()
        let object = ThrowingObject()
        let expectedError = TestError()
        object.thrownError = expectedError
        var returnedError: Error?
        var decodedObject: SomeObject?
        var completionResult: Restler.DecodableResult<SomeObject?>?
        //Act
        _ = sut
            .put(self.endpoint)
            .body(object)
            .decode(SomeObject?.self)
            .onFailure({ returnedError = $0 })
            .onSuccess({ decodedObject = $0 })
            .onCompletion({ completionResult = $0 })
            .start()
        self.dispatchQueueManager.performParams.forEach { $0.action() }
        //Assert
        XCTAssertEqual(self.dispatchQueueManager.performParams.count, 1)
        XCTAssertEqual(self.networking.makeRequestParams.count, 0)
        XCTAssertNil(decodedObject)
        try self.assertThrowsEncodingError(expected: expectedError, returnedError: returnedError, completionResult: completionResult)
    }
    
    func testPutDecodable_buildingRequest_encodingBody() throws {
        //Arrange
        let sut = self.buildSUT()
        let object = SomeObject(id: 1, name: "name")
        let data = try JSONEncoder().encode(object)
        var completionResult: Restler.DecodableResult<SomeObject>?
        //Act
        _ = sut
            .put(self.endpoint)
            .body(object)
            .decode(SomeObject.self)
            .onCompletion({ completionResult = $0 })
            .start()
        //Assert
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        let requestParams = try XCTUnwrap(self.networking.makeRequestParams.first)
        XCTAssertEqual(requestParams.url.absoluteString, self.mockURLString)
        XCTAssertEqual(requestParams.method, .put(content: data))
        XCTAssertNil(completionResult)
    }
    
    func testPutDecodable_buildingRequest_encodingBodyFails() throws {
        //Arrange
        let sut = self.buildSUT()
        let object = ThrowingObject()
        let expectedError = TestError()
        object.thrownError = expectedError
        var returnedError: Error?
        var decodedObject: SomeObject?
        var completionResult: Restler.DecodableResult<SomeObject>?
        //Act
        _ = sut
            .put(self.endpoint)
            .body(object)
            .decode(SomeObject.self)
            .onFailure({ returnedError = $0 })
            .onSuccess({ decodedObject = $0 })
            .onCompletion({ completionResult = $0 })
            .start()
        self.dispatchQueueManager.performParams.forEach { $0.action() }
        //Assert
        XCTAssertEqual(self.dispatchQueueManager.performParams.count, 1)
        XCTAssertEqual(self.networking.makeRequestParams.count, 0)
        XCTAssertNil(decodedObject)
        try self.assertThrowsEncodingError(expected: expectedError, returnedError: returnedError, completionResult: completionResult)
    }
}

// MARK: - DELETE
extension InterfaceIntegrationTests {
    func testDeleteVoid_buildingRequest_encodingQuery() throws {
        //Arrange
        let sut = self.buildSUT()
        var completionResult: Restler.VoidResult?
        //Act
        _ = sut
            .delete(self.endpoint)
            .query(SomeObject(id: 1, name: "name"))
            .decode(Void.self)
            .onCompletion({ completionResult = $0 })
            .start()
        //Assert
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        let requestParams = try XCTUnwrap(self.networking.makeRequestParams.first)
        XCTAssertEqual(requestParams.url.absoluteString, self.mockURLString)
        XCTAssertEqual(requestParams.method, .delete)
        XCTAssertNil(completionResult)
    }
    
    func testDeleteVoid_buildingRequest_encodingQueryFails() throws {
        //Arrange
        let sut = self.buildSUT()
        let object = ThrowingObject()
        let expectedError = TestError()
        object.thrownError = expectedError
        var returnedError: Error?
        var decodedObject: Void?
        var completionResult: Restler.VoidResult?
        //Act
        _ = sut
            .delete(self.endpoint)
            .query(object)
            .decode(Void.self)
            .onFailure({ returnedError = $0 })
            .onSuccess({ decodedObject = $0 })
            .onCompletion({ completionResult = $0 })
            .start()
        self.dispatchQueueManager.performParams.forEach { $0.action() }
        //Assert
        XCTAssertEqual(self.dispatchQueueManager.performParams.count, 1)
        XCTAssertEqual(self.networking.makeRequestParams.count, 0)
        XCTAssertNil(decodedObject)
        try self.assertThrowsEncodingError(expected: expectedError, returnedError: returnedError, completionResult: completionResult)
    }

    func testDeleteVoid_buildingRequest_encodingBody() throws {
        //Arrange
        let sut = self.buildSUT()
        var completionResult: Restler.VoidResult?
        //Act
        _ = sut
            .delete(self.endpoint)
            .body(SomeObject(id: 1, name: "name"))
            .decode(Void.self)
            .onCompletion({ completionResult = $0 })
            .start()
        //Assert
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        let requestParams = try XCTUnwrap(self.networking.makeRequestParams.first)
        XCTAssertEqual(requestParams.url.absoluteString, self.mockURLString)
        XCTAssertEqual(requestParams.method, .delete)
        XCTAssertNil(completionResult)
    }

    func testDeleteVoid_buildingRequest_encodingBodyFails() throws {
        //Arrange
        let sut = self.buildSUT()
        let object = ThrowingObject()
        let expectedError = TestError()
        object.thrownError = expectedError
        var returnedError: Error?
        var decodedObject: Void?
        var completionResult: Restler.VoidResult?
        //Act
        _ = sut
            .delete(self.endpoint)
            .body(object)
            .decode(Void.self)
            .onFailure({ returnedError = $0 })
            .onSuccess({ decodedObject = $0 })
            .onCompletion({ completionResult = $0 })
            .start()
        self.dispatchQueueManager.performParams.forEach { $0.action() }
        //Assert
        XCTAssertEqual(self.dispatchQueueManager.performParams.count, 1)
        XCTAssertEqual(self.networking.makeRequestParams.count, 0)
        XCTAssertNil(decodedObject)
        try self.assertThrowsEncodingError(expected: expectedError, returnedError: returnedError, completionResult: completionResult)
    }
    
    func testDeleteOptionalDecodable_buildingRequest() throws {
        //Arrange
        let sut = self.buildSUT()
        var completionResult: Restler.DecodableResult<SomeObject?>?
        //Act
        _ = sut
            .delete(self.endpoint)
            .decode(SomeObject?.self)
            .onCompletion({ completionResult = $0 })
            .start()
        //Assert
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        let requestParams = try XCTUnwrap(self.networking.makeRequestParams.first)
        XCTAssertEqual(requestParams.url.absoluteString, self.mockURLString)
        XCTAssertEqual(requestParams.method, .delete)
        XCTAssertNil(completionResult)
    }
    
    func testDeleteDecodable_buildingRequest() throws {
        //Arrange
        let sut = self.buildSUT()
        var completionResult: Restler.DecodableResult<SomeObject>?
        //Act
        _ = sut
            .delete(self.endpoint)
            .decode(SomeObject.self)
            .onCompletion({ completionResult = $0 })
            .start()
        //Assert
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        let requestParams = try XCTUnwrap(self.networking.makeRequestParams.first)
        XCTAssertEqual(requestParams.url.absoluteString, self.mockURLString)
        XCTAssertEqual(requestParams.method, .delete)
        XCTAssertNil(completionResult)
    }
}

// MARK: - Private
extension InterfaceIntegrationTests {
    private func buildSUT() -> Restler {
        return Restler(
            baseURL: self.baseURL,
            networking: self.networking,
            dispatchQueueManager: self.dispatchQueueManager,
            encoder: JSONEncoder(),
            decoder: JSONDecoder())
    }
    
    private func assertThrowsEncodingError<T>(expected: TestError, returnedError: Error?, completionResult: Result<T, Error>?) throws {
        let restlerError = try XCTUnwrap(returnedError as? Restler.Error)
        guard case let .multiple(errors) = restlerError else { return XCTFail("Returned error is not multiple error") }
        XCTAssertEqual(errors.count, 1)
        guard case let .common(type, base) = errors.first else { return XCTFail("Error thrown is not common error") }
        XCTAssertEqual(base as? TestError, expected)
        XCTAssertEqual(type, Restler.ErrorType.invalidParameters)
        AssertResult(try XCTUnwrap(completionResult), errorIsEqualTo: restlerError)
    }
}
