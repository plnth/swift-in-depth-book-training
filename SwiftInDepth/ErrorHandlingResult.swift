import Foundation

enum NetworkError: Error {
    case fetchFailed(Error)
}

enum SearchResultError: Error {
    case invalidTerm(String)
    case underlyingError(NetworkError)
    case invalidData
    
}

typealias SearchResult<Value> = Result<Value, SearchResultError>
typealias JSON = [String: Any]

let session = URLSession(configuration: .default)
func callURL(with url: URL, completionHandler: @escaping (Result<Data, NetworkError>) -> Void) {
    let task = session.dataTask(with: url) { (data, response, error) in
        let dataTaskError = error.map {
            NetworkError.fetchFailed($0)
        }
        let result = Result<Data, NetworkError>(value: data, error: dataTaskError)
        completionHandler(result!)
    }
    task.resume()
}

func search(term: String, completionHandler: @escaping (SearchResult<JSON>) -> Void) {
    let encodedString = term.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
    let path = encodedString.map { "https://itunes.apple.com/search?term=" + $0 }
    guard let url = path.flatMap(URL.init) else {
        let result = SearchResult<JSON>.failure(.invalidTerm(term))
        completionHandler(result)
        return
    }
    
    //MARK: naive implementation
    callURL(with: url) { result in
//        switch result {
//        case .success(let data):
//            if let json = try? JSONSerialization.jsonObject(with: data, options: []),
//               let jsonDict = json as? JSON {
//                let result = SearchResult<JSON>.success(jsonDict)
//                completionHandler(result)
//            } else {
//                let result = SearchResult<JSON>.failure(.invalidData)
//                completionHandler(result)
//            }
//        case .failure(let error):
//            let result = SearchResult<JSON>.failure(.underlyingError(error))
//            completionHandler(result)
//        }
        
        //MARK: map + mapError
//        let convertedResult = result.map { data -> JSON in
//            guard let json = try? JSONSerialization.jsonObject(with: data, options: []),
//                  let jsonDict = json as? JSON else {
//                return [:]
//            }
//            return jsonDict
//        }
//        .mapError { networkError in
//            return SearchResultError.underlyingError(networkError)
//        }
//        completionHandler(convertedResult)
        
        //MARK: mapError + flatMap
//        let convertedResult: SearchResult<JSON> = result.mapError { networkError -> SearchResultError in
//            return SearchResultError.underlyingError(networkError)
//        }
//        .flatMap { data -> SearchResult<JSON> in
//            guard let json = try? JSONSerialization.jsonObject(with: data, options: []),
//                  let jsonDict = json as? JSON else {
//                return SearchResult.failure(.invalidData)
//            }
//            return SearchResult.success(jsonDict)
//        }
//        completionHandler(convertedResult)
//    }
        
        
        //MARK: Result with throwing function
        let convertedResult: SearchResult<JSON> = result.mapError {
            SearchResultError.underlyingError($0)
        }
        .flatMap { data -> SearchResult<JSON> in
            do {
                let searchResult: SearchResult<JSON> = Result.success(try parseData(data))
                return searchResult
            } catch {
                return SearchResult.failure(.invalidData)
            }
        }
        completionHandler(convertedResult)
    }
}

enum PaymentError: Error {
    case amountTooLow
    case insufficientFunds
}

enum ParsingError: Error {
    case couldNotParseJSON
}

func parseData(_ data: Data) throws -> JSON {
    guard let json = try? JSONSerialization.jsonObject(with: data, options: []),
          let jsonDict = json as? JSON else {
        throw ParsingError.couldNotParseJSON
    }
    return jsonDict
}

protocol Service {
    associatedtype Value
    associatedtype Err: Error
    func load(complete: @escaping (Result<Value, Err>) -> Void)
}

enum BogusError: Error {}

struct Subscription {}

//final class SubscriptionsLoader: Service {
//    func load(complete: @escaping (Result<[Subscription], BogusError>) -> Void) {
//        let subscriptions = [Subscription(), Subscription()]
//        complete(Result.success(subscriptions))
//    }
//}

final class SubscriptionsLoader: Service {
    func load(complete: @escaping (Result<[Subscription], Never>) -> Void) {
        let subscriptions = [Subscription(), Subscription()]
        complete(Result.success(subscriptions))
    }
}

func partErrorHandlingResult() {
//    let url = URL(string: "https://itunes.apple.com/search?term=iron%20man")!
//    callURL(with: url) { result in
//        switch result {
//        case .success(let data):
//            let value = String(data: data, encoding: .utf8)
//            debugPrint(value)
//        case .failure(let error):
//            debugPrint(error)
//        }
//    }
    
//    search(term: "Sting") { (result) in
//        switch result {
//        case .success(let json): debugPrint(json)
//        case .failure(let error): debugPrint(error)
//        }
//    }
    
    let data = Data()
    do {
//        if let data = data {
            let searchResult: Result<JSON, SearchResultError> = Result.success(try parseData(data))
            debugPrint(searchResult)
//        } else { debugPrint("No data") }
    } catch {
        debugPrint(error)
        let searchResult: Result<JSON, SearchResultError> = Result.failure(.invalidData)
        debugPrint(searchResult)
    }
    
    let error: AnyError = AnyError(PaymentError.amountTooLow)
    debugPrint(error)
    
//    let otherResult: Result<String, AnyError> = Result(anyError: { () throws -> String in
//        throw PaymentError.insufficientFunds
//    })
    
    let subscriptionsLoader = SubscriptionsLoader()
    subscriptionsLoader.load { result in
        switch result {
        case .success(let subscriptions): debugPrint(subscriptions)
        }
    }
}

extension Swift.Result {
    init?(value: Success?, error: Failure?) {
        if let error = error {
            self = .failure(error)
        } else if let value = value {
            self = .success(value)
        } else {
            fatalError("Could not create Result")
        }
    }
}

/// A type-erased error which wraps an arbitrary error instance. This should be
/// useful for generic contexts.
public struct AnyError: Swift.Error {
    /// The underlying error.
    public let error: Swift.Error

    public init(_ error: Swift.Error) {
        if let anyError = error as? AnyError {
            self = anyError
        } else {
            self.error = error
        }
    }
}

/// Protocol used to constrain `tryMap` to `Result`s with compatible `Error`s.
public protocol ErrorConvertible: Swift.Error {
    static func error(from error: Swift.Error) -> Self
}

extension AnyError: ErrorConvertible {
    public static func error(from error: Error) -> AnyError {
        return AnyError(error)
    }
}

extension AnyError: CustomStringConvertible {
    public var description: String {
        return String(describing: error)
    }
}

extension AnyError: LocalizedError {
    public var errorDescription: String? {
        return error.localizedDescription
    }

    public var failureReason: String? {
        return (error as? LocalizedError)?.failureReason
    }

    public var helpAnchor: String? {
        return (error as? LocalizedError)?.helpAnchor
    }

    public var recoverySuggestion: String? {
        return (error as? LocalizedError)?.recoverySuggestion
    }
}
