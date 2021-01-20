import Foundation

protocol Session {
    associatedtype Task: DataTask
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> Task
    func dataTask(with url: URL, completionHandler: @escaping (Result<Data, Error>) -> Void) -> Task
}

extension Session {
    func dataTask(with url: URL, completionHandler: @escaping (Result<Data, Error>) -> Void) -> Task {
        return dataTask(with: url) { (data, response, error) in
            if let error = error {
                completionHandler(Result.failure(error))
            } else if let data = data {
                completionHandler(Result.success(data))
            } else {
                debugPrint("fatalError")
            }
        }
    }
}

protocol DataTask {
    func resume()
}

extension URLSessionDataTask: DataTask {}
extension URLSession: Session {}

final class WeatherAPI<S: Session> {
    let session: S
    
    init(session: S) {
        self.session = session
    }
    
    func run() {
        guard let url = URL(string: "https://someweatherstartup") else {
            fatalError("Could not create url")
        }
        let task = session.dataTask(with: url) { (data, response, error) in
            debugPrint("executing...")
        }
        task.resume()
    }
}

enum APIError: Error {
    case couldNotCloadData
}

struct OfflineTask: DataTask {
    typealias Completion = (Data?, URLResponse?, Error?) -> Void
    let completionHandler: Completion
    
    init(completionHandler: @escaping Completion) {
        self.completionHandler = completionHandler
    }
    
    func resume() {
        let url = URL(fileURLWithPath: "prepared_response.json")
        let data = try? Data(contentsOf: url)
        completionHandler(data, nil, nil)
    }
}

final class OfflineURLSession: Session {
    var tasks = [URL: OfflineTask]()
    
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> OfflineTask {
        let task = OfflineTask(completionHandler: completionHandler)
        tasks[url] = task
        return task
    }
}

struct MockTask: DataTask {
    let expectedURLs: [URL]
    let url: URL
    
    func resume() {
        guard expectedURLs.contains(url) else {
            return
        }
        debugPrint("success")
    }
}

class MockSession: Session {
    let expectedURLs: [URL]
    init(urls: [URL]) {
        self.expectedURLs = urls
    }
    
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> MockTask {
        return MockTask(expectedURLs: expectedURLs, url: url)
    }
}

protocol Track {
    func play()
}

struct AudioTrack: Track {
    let file: URL
    func play() {
        debugPrint("playing \(file)")
    }
}

//extension Array where Element: Track {
//    func play() {
//        for element in self {
//            element.play()
//        }
//    }
//}

extension Array: Track where Element: Track {
    func play() {
        for element in self {
            element.play()
        }
    }
}

extension Optional: Track where Wrapped: Track {
    func play() {
        switch self {
        case .none:
            debugPrint("no track")
        case .some(let track):
            track.play()
        }
    }
}

final class CachedValue<T> {
    
    private let load: () -> T
    private var lastLoaded: Date
    private var timeToLive: Double
    private var currentValue: T
    
    public var value: T {
        let needsRefresh = abs(lastLoaded.timeIntervalSinceNow) > timeToLive
        if needsRefresh {
            currentValue = load()
            lastLoaded = Date()
        }
        return currentValue
    }
    
    init(timeToLive: Double, load: @escaping (() -> T)) {
        self.timeToLive = timeToLive
        self.load = load
        self.currentValue = load()
        self.lastLoaded = Date()
    }
}

protocol PokerGame: Hashable {
    func start()
}

struct StudPoker: PokerGame {
    func start() {
        print("Starting StudPoker")
    }
}
struct TexasHoldem: PokerGame {
    func start() {
        print("Starting Texas Holdem")
    }
}

//enum PokerGame: Hashable {
//    case studPoker(StudPoker)
//    case texasHoldem(TexasHoldem)
//}

struct AnyPokerGame: PokerGame {
    private let _start: () -> Void
    private let _hashable: AnyHashable
    
    init<Game: PokerGame>(_ pokerGame: Game) {
        _start = pokerGame.start
        _hashable = AnyHashable(pokerGame)
    }
    
    func start() {
        _start()
    }
}

extension AnyPokerGame: Hashable {
    static func == (lhs: AnyPokerGame, rhs: AnyPokerGame) -> Bool {
        return lhs._hashable == rhs._hashable
    }
    
    func hash(into hasher: inout Hasher) {
        _hashable.hash(into: &hasher)
    }
}

func partPatterns() {
    let productionAPI = WeatherAPI(session: URLSession.shared)
    let offlineAPI = WeatherAPI(session: OfflineURLSession())
    productionAPI.run()
    offlineAPI.run()
    
    let tracks = [
        AudioTrack(file: URL(fileURLWithPath: "1.mp3")),
        AudioTrack(file: URL(fileURLWithPath: "2.mp3"))
    ]
    tracks.play() // You use the play() method
    [tracks, tracks].play() //Referencing instance method 'play()' on 'Array' requires that '[AudioTrack]' conform to 'Track'
    
    let audio: AudioTrack? = AudioTrack(file: URL(fileURLWithPath: "1.mp3"))
    audio?.play()
    
    let simplecache = CachedValue(timeToLive: 2, load: { () -> String in
         print("I am being refreshed!")
         return "I am the value inside CachedValue"
    })
    debugPrint(simplecache.value)
    debugPrint(simplecache.value)
    sleep(3) // wait 3 seconds
    debugPrint(simplecache.value)
}

extension CachedValue: Equatable where T: Equatable {
    static func ==(lhs: CachedValue, rhs: CachedValue) -> Bool {
        return lhs.value == rhs.value
    }
}

func num(num: Int) -> Int {
    return num
}

//(num: Int) -> Int {
//    return num
//}

//{ (num: Int) -> Int
//    return num
//}

//{ (num: Int) -> Int in
//    return num
//}

let closure = { (num: Int) -> Int in
    return num
}
