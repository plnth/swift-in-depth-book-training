import Foundation

protocol RequestBuilder {
    var baseURL: URL { get }
    func makeRequest(path: String) -> URLRequest
}

extension RequestBuilder {
    func makeRequest(path: String) -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        var request = URLRequest(url: url)
        request.httpShouldHandleCookies = false
        request.timeoutInterval = 30
        return request
    }
}

struct BikeRequestBuilder: RequestBuilder {
    let baseURL: URL = URL(string: "https://www.biketriptracker.com")!
}

enum ResponseError: Error {
    case invalidResponse
}

protocol ResponseHandler {
    func validate(response: URLResponse) throws
}

extension ResponseHandler {
    func validate(response: URLResponse) throws {
        guard let _ = response as? HTTPURLResponse else {
            throw ResponseError.invalidResponse
        }
    }
}

class BikeAPI: RequestBuilder, ResponseHandler {
    let baseURL: URL = URL(string: "https://www.biketriptracker.com")!
}

struct MailAddress {
    let value: String
}

struct Email {
    let subject: String
    let body: String
    let to: [MailAddress]
    let from: MailAddress
}

protocol Mailer {
    func send(email: Email) throws
}

extension Mailer {
    func send(email: Email) throws {
        debugPrint("Email is sent!")
    }
}

protocol ValidatingMailer: Mailer {
    func send(email: Email) throws
    func validate(email: Email) throws
}

extension ValidatingMailer {
    func send(email: Email) throws {
        try validate(email: email)
        debugPrint("Email is validated")
    }
    
    func validate(email: Email) throws {
        
    }
}

protocol MailValidator {
    func validate(email: Email) throws
}

extension MailValidator {
    func validate(email: Email) throws {
        
    }
}

extension MailValidator where Self: Mailer {
    func send(email: Email) throws {
        try validate(email: email)
        debugPrint("Email is validated and sent")
    }
    
    func send(email: Email, at: Date) throws {
        try validate(email: email)
        debugPrint("Email is validated and stored")
    }
}

struct SMTPClient: Mailer, MailValidator {}

func submitEmail<T>(sender: T, email: Email) where T: Mailer, T: MailValidator {
    try? sender.send(email: email, at: Date(timeIntervalSinceNow: 3600))
}

protocol Plant {
    func grow()
}
extension Plant {
    func grow() {
        debugPrint("Growing a plant")
    }
}

protocol Tree: Plant {}
extension Tree {
    func grow() {
        debugPrint("Growing a tree")
    }
}

struct Oak: Tree {
    func grow() {
         print("The mighty oak is growing")
    }
}

struct CherryTree: Tree {}
struct KiwiPlant: Plant {}

func growPlant<T>(_ plant: T) where T: Plant {
    plant.grow()
}

extension Collection where Element: Equatable {
    func unique() -> [Element] {
        var uniqueValues = [Element]()
        for element in self {
            if !uniqueValues.contains(element) {
                uniqueValues.append(element)
            }
        }
        return uniqueValues
    }
}

extension Collection where Element: Hashable {
    func unique() -> [Element] {
        var set = Set<Element>()
        var uniqueValues = [Element]()
        for element in self {
            if !set.contains(element) {
                uniqueValues.append(element)
                set.insert(element)
            }
        }
        return uniqueValues
    }
}

extension Set {
    func unique() -> [Element] {
        return Array(self)
    }
}

extension Sequence {
    public func take(while predicate: (Element) throws -> Bool) rethrows -> [Element] {
        var iterator = self.makeIterator()
        var result = ContiguousArray<Element>()
        while let element = iterator.next() {
            if try predicate(element) {
                result.append(element)
            } else { break }
        }
        return Array(result)
    }
}

func partProtocolExtensions() {
    let bikeRequestBuilder = BikeRequestBuilder()
    let request = bikeRequestBuilder.makeRequest(path: "trips/all")
    debugPrint(request)
    
    let client = SMTPClient()
    let email = Email(subject: "Learn Swift",
          body: "Lorem ipsum",
          to: [MailAddress(value: "john@appleseed.com")],
          from: MailAddress(value: "stranger@somewhere.com"))

    try? client.send(email: email) // Email validated and sent.
    try? client.send(email: email, at: Date(timeIntervalSinceNow: 3600))

    growPlant(Oak()) // The mighty oak is growing
    growPlant(CherryTree()) // Growing a tree
    growPlant(KiwiPlant()) // Growing a plant
    
    debugPrint([3, 2, 3, 2, 1].unique())
    debugPrint("aaaaaappppporototo".unique())
    
    let str = "DFGDFSGIDFPGrjgbafjHYFjJ{FIJO'lfd;fl"
    debugPrint(
        str.take(while: { $0.isUppercase }
        )
    )
}
