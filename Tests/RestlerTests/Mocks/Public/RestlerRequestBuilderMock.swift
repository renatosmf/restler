import XCTest
#if canImport(Combine)
import Combine
#endif
import RestlerCore

final class RestlerRequestBuilderMock {
    
    // MARK: - RestlerBasicRequestBuilderType
    private(set) var setInHeaderParams: [SetInHeaderParams] = []
    struct SetInHeaderParams {
        let value: String?
        let key: Restler.Header.Key
    }
    
    private(set) var failureDecodeParams: [FailureDecodeParams] = []
    struct FailureDecodeParams {
        let type: RestlerErrorDecodable.Type
    }
    
    private(set) var customRequestModificationParams: [CustomRequestModificationParams] = []
    struct CustomRequestModificationParams {
        let modification: ((inout URLRequest) -> Void)?
    }
    
    private(set) var catchingParams: [CatchingParams] = []
    struct CatchingParams {
        let handler: ((Restler.Error) -> Void)?
    }
    
    var urlRequestReturnValue: URLRequest?
    private(set) var urlRequestParams: [URLRequestParams] = []
    struct URLRequestParams {}
    
    private(set) var publisherParams: [PublisherParams] = []
    struct PublisherParams {}
    
    // MARK: - RestlerQueryRequestBuilderType
    private(set) var queryParams: [QueryParams] = []
    struct QueryParams {
        let object: Any
    }
    
    // MARK: - RestlerBodyRequestBuilderType
    private(set) var bodyParams: [BodyParams] = []
    struct BodyParams {
        let object: Any
    }
    
    // MARK: - RestlerMultipartRequestBuilderType
    private(set) var multipartParams: [MultipartParams] = []
    struct MultipartParams {
        let object: Any
        let boundary: String?
    }
    
    // MARK: - RestlerDecodableResponseRequestBuilderType
    private(set) var decodeReturnedMocks: [Any] = []
    private(set) var decodeParams: [DecodeParams] = []
    struct DecodeParams {
        let type: Any
    }
    
    // MARK: - RestlerDownloadRequestBuilderType
    private(set) var resumeDataParams: [ResumeDataParams] = []
    struct ResumeDataParams {
        let data: Data
    }
    
    var requestDownloadReturnValue: RestlerDownloadRequestMock = .init()
    private(set) var requestDownloadParams: [RequestDownloadParams] = []
    struct RequestDownloadParams {}
    
    // MARK: - Internal
    func callCompletion<T>(type: T.Type, result: Result<T, Error>) throws {
        guard let request = self.decodeReturnedMocks.last as? RestlerRequestMock<T> else {
            throw "Decode hasn't return value with a specified type."
        }
        var isCalledAnything = false
        switch result {
        case let .success(object):
            guard let successHandler = request.lastSuccessHandler else { break }
            successHandler(object)
            isCalledAnything = true
        case let .failure(error):
            guard let failureHandler = request.lastFailureHandler else { break }
            failureHandler(error)
            isCalledAnything = true
        }
        if let completionHandler = request.lastCompletionHandler {
            completionHandler(result)
            isCalledAnything = true
        }
        guard isCalledAnything else { throw "None handler has been called." }
    }
}

// MARK: - RestlerBasicRequestBuilderType
extension RestlerRequestBuilderMock: RestlerBasicRequestBuilderType {
    func setInHeader(_ value: String?, forKey key: Restler.Header.Key) -> Self {
        self.setInHeaderParams.append(SetInHeaderParams(value: value, key: key))
        return self
    }
    
    func failureDecode<T>(_ type: T.Type) -> Self where T: RestlerErrorDecodable {
        self.failureDecodeParams.append(FailureDecodeParams(type: type))
        return self
    }
    
    func customRequestModification(_ modification: ((inout URLRequest) -> Void)?) -> Self {
        self.customRequestModificationParams.append(CustomRequestModificationParams(modification: modification))
        return self
    }
    
    func catching(_ handler: ((Restler.Error) -> Void)?) -> Self {
        self.catchingParams.append(CatchingParams(handler: handler))
        return self
    }
    
    func receive(on queue: DispatchQueue?) -> Self {
        return self
    }
    
    func decode(_ type: Void.Type) -> Restler.Request<Void> {
        self.decodeParams.append(DecodeParams(type: type))
        let mock = RestlerRequestMock<Void>()
        self.decodeReturnedMocks.append(mock)
        return mock
    }
    
    func urlRequest() -> URLRequest? {
        self.urlRequestParams.append(URLRequestParams())
        return self.urlRequestReturnValue
    }
    
    #if canImport(Combine)
    @available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    func publisher() -> AnyPublisher<URLSession.DataTaskPublisher.Output, URLSession.DataTaskPublisher.Failure>? {
        self.publisherParams.append(PublisherParams())
        return nil
    }
    #endif
}

// MARK: - RestlerQueryRequestBuilderType
extension RestlerRequestBuilderMock: RestlerQueryRequestBuilderType {
    func query<E>(_ object: E) -> Self where E: RestlerQueryEncodable {
        self.queryParams.append(QueryParams(object: object))
        return self
    }
}

// MARK: - RestlerBodyRequestBuilderType
extension RestlerRequestBuilderMock: RestlerBodyRequestBuilderType {
    func body<E>(_ object: E) -> Self where E: Encodable {
        self.bodyParams.append(BodyParams(object: object))
        return self
    }
}

// MARK: - RestlerMultipartRequestBuilderType
extension RestlerRequestBuilderMock: RestlerMultipartRequestBuilderType {
    func multipart<E>(_ object: E, boundary: String?) -> Self where E: RestlerMultipartEncodable {
        self.multipartParams.append(MultipartParams(object: object, boundary: boundary))
        return self
    }
}

// MARK: - RestlerDecodableResponseRequestBuilderType
extension RestlerRequestBuilderMock: RestlerDecodableResponseRequestBuilderType {
    func decode<T>(_ type: T?.Type) -> Restler.Request<T?> where T: Decodable {
        self.decodeParams.append(DecodeParams(type: type))
        let mock = RestlerRequestMock<T?>()
        self.decodeReturnedMocks.append(mock)
        return mock
    }
    
    func decode<T>(_ type: T.Type) -> Restler.Request<T> where T: Decodable {
        self.decodeParams.append(DecodeParams(type: type))
        let mock = RestlerRequestMock<T>()
        self.decodeReturnedMocks.append(mock)
        return mock
    }
}

// MARK: - RestlerDownloadRequestBuilderType
extension RestlerRequestBuilderMock: RestlerDownloadRequestBuilderType {
    func resumeData(_ data: Data) -> Self {
        self.resumeDataParams.append(ResumeDataParams(data: data))
        return self
    }
    
    func requestDownload() -> RestlerDownloadRequestType {
        self.requestDownloadParams.append(RequestDownloadParams())
        return self.requestDownloadReturnValue
    }
}
