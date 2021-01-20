import Foundation

protocol CryptoCurrency {
    var name: String { get }
    var symbol: String { get }
    var holdings: Double { get }
    var price: NSDecimalNumber? { get set }
}

struct Bitcoin: CryptoCurrency {
    let name = "Bitcoin"
    let symbol = "BTC"
    var holdings: Double
    var price: NSDecimalNumber?
}

struct Ethereum: CryptoCurrency {
    let name = "Ethereum"
    let symbol = "ETH"
    var holdings: Double
    var price: NSDecimalNumber?
}

//MARK: problem  - Portfolio can't accept an array with different coins
final class Portfolio {
    var coins: [CryptoCurrency]
    
    init(coins: [CryptoCurrency]) {
        self.coins = coins
    }
    
    func addCoin(_ newCoin: CryptoCurrency) {
        coins.append(newCoin)
    }
}

func retrievePriceRunTime(coin: CryptoCurrency, completion: ((CryptoCurrency) -> Void)) {
    var copy = coin
    copy.price = 6000
    completion(copy)
}

func retrievePriceCompileTime<Coin: CryptoCurrency>(coin: Coin, completion: ((Coin) -> Void)) {
    var copy = coin
    copy.price = 6000
    completion(copy)
}

protocol Worker {
    associatedtype Input
    associatedtype Output
    
    @discardableResult
    func start(input: Input) -> Output
}

class MailJob: Worker {
    //MARK: not needed if types in methods are concrete
//    typealias Input = String
//    typealias Output = Bool
    
    func start(input: String) -> Bool {
        return true
    }
}

class FileRemover: Worker {
    //MARK: needed
    typealias Input = URL
    typealias Output = [String]
    
    func start(input: Input) -> Output {
        do {
            var results = [String]()
            let fileManager = FileManager.default
            
            let fileURLs = try fileManager.contentsOfDirectory(at: input, includingPropertiesForKeys: nil)
            for fileURL in fileURLs {
                try fileManager.removeItem(at: fileURL)
                results.append(fileURL.absoluteString)
            }
            return results
        } catch {
            debugPrint("Clearing failed")
            return []
        }
    }
}

typealias UIImage = String

final class ImageCropper: Worker {
    typealias Input = UIImage
    typealias Output = Bool
    
    func start(input: UIImage) -> Bool {
        return true
    }
}

protocol ImageWorker: Worker where Input == UIImage, Output == Bool {}

//MARK: where to constrain class
final class ImageProcessor<W: ImageWorker> {
    let worker: W
    
    init(worker: W) {
        self.worker = worker
    }
    
    private func process() {
        // start batches
        var results = [Bool]()
        
        let amount = 50
        var offset = 0
        var images = fetchImages(amount: amount, offset: offset)
        var failedCount = 0
        while !images.isEmpty {
            
            for image in images {
                if !worker.start(input: image) {
                    failedCount += 1
                }
            }
            
            offset += amount
            images = fetchImages(amount: amount, offset: offset)
        }
        
        print("\(failedCount) images failed")
    }
    
    private func fetchImages(amount: Int, offset: Int) -> [UIImage] {
        return [UIImage(), UIImage()]
    }
}

func runWorker<W: Worker>(worker: W, input: [W.Input]) {
    input.forEach { value in
        worker.start(input: value)
    }
}

final class User {
    let firstName: String
    let lastName: String
    
    init(firstName: String, lastName: String) {
        self.firstName = firstName
        self.lastName = lastName
    }
}

func runWorker<W>(worker: W, input: [W.Input]) where W: Worker, W.Input == User {
    input.forEach { user in
        worker.start(input: user)
        debugPrint("Finished processing user \(user.firstName) \(user.lastName)")
    }
}

//class AbstractDamage {}
//
//class AbstractEnemy {
//    func attack() -> AbstractDamage {
//        fatalError("This method must be implemented by subclass")
//    }
//}
//
//class Fire: AbstractDamage {}
//class Imp: AbstractEnemy {
//    override func attack() -> Fire {
//        return Fire()
//    }
//}
//
//class BluntDamage: AbstractDamage {}
//class Centaur: AbstractEnemy {
//    override func attack() -> BluntDamage {
//        return BluntDamage()
//    }
//}

protocol AbstractEnemy {
    associatedtype DamageType
    func attack() -> DamageType
}

struct Fire {}
class Imp: AbstractEnemy {
    typealias DamageType = Fire
    
    func attack() -> Fire {
        return Fire()
    }
}

struct BluntDamage {}
class Centaur: AbstractEnemy {
    typealias DamageType = BluntDamage
    
    func attack() -> BluntDamage {
        return BluntDamage()
    }
}

protocol Playable {
    associatedtype Media
    var contents: Media { get }
    func play()
}

final class Movie: Playable {
    typealias Media = URL
    let contents: URL
    
    init(contents: URL) {
        self.contents = contents
    }
    
    func play() {
        debugPrint("PLaying vieo at \(contents)")
    }
}

struct AudioFile {}
final class Song: Playable {
    typealias Media = AudioFile
    let contents: AudioFile
    
    init(contents: AudioFile) {
        self.contents = contents
    }
    
    func play() {
        debugPrint("playing song")
    }
}

//final class Playlist<P> where P: Playable, P.Media == AudioFile //no
//final class Playlist<P> where P: Playable
final class Playlist<P: Playable> {
    
    private var queue: [P] = []
    
    func addToQueue(playable: P) {
        queue.append(playable)
    }
    
    func start() {
        queue.first?.play()
    }
}

protocol Mentos {}
protocol Coke {}

extension Mentos where Self: Coke {
    func explode() {
        debugPrint("BOOM")
    }
}

func mix<T>(concoction: T) where T: Mentos, T: Coke {
    concoction.explode()
}

func partProtocols() {
    let coins: [CryptoCurrency] = [
        Ethereum(holdings: 4, price: NSDecimalNumber(value: 500)),
        Bitcoin(holdings: 4, price: NSDecimalNumber(value: 6000)) // We can't mix
    ]
    let portfolio = Portfolio(coins: coins)

    //portfolio.addCoin(Bitcoin())
    //  error: cannot convert value of type 'Bitcoin' to expected argument type 'Ethereum'
    print(type(of: portfolio.coins)) // Array<Ethereum>
    
    let btc = Bitcoin(holdings: 3, price: nil)
    retrievePriceRunTime(coin: btc) { updatedCoin in
        debugPrint("runtime:")
        debugPrint(type(of: updatedCoin)) //MARK: CryptoCurrency until run
        debugPrint(updatedCoin.price?.doubleValue ?? 0)
    }
    debugPrint("====================")
    retrievePriceCompileTime(coin: btc) { updatedCoin in
        debugPrint("compile time:")
        debugPrint(type(of: updatedCoin)) //MARK: Bitcoin before run
        debugPrint(updatedCoin.price?.doubleValue ?? 0)
    }
    
    let mailJob = MailJob()
    runWorker(worker: mailJob, input: ["grover@sesamestreetcom", "bigbird@sesamestreet.com"])

    let fileRemover = FileRemover()
    runWorker(worker: fileRemover, input: [
        URL(fileURLWithPath: "./cache", isDirectory: true),
        URL(fileURLWithPath: "./tmp", isDirectory: true),
        ])
}
