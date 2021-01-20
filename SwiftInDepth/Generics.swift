import Foundation

func firstLast<T>(array: [T]) -> (T, T) {
    return (array[0], array[array.count - 1])
}

func wrap<T>(value: T) -> [T] {
    return [value]
}

func lowest<T: Comparable>(_ array: [T]) -> T? {
//    let sortedArray = array.sorted { (lhs, rhs) -> Bool in
//        return lhs < rhs
//    }
    return array.sorted().first
}

enum RoyalRank: Comparable {
    case emperor, king, duke
    
    //MARK: it's enough to implement only < operator
    static func <(lhs: RoyalRank, rhs: RoyalRank) -> Bool {
        switch (lhs, rhs) {
        case (king, emperor): return true
        case (duke, emperor): return true
        case (duke, king): return true
        default: return false
        }
    }
}

func occurences<T>(values: [T]) -> [T : Int] where T: Comparable & Hashable {
    var groupedValues = [T : Int]()
    for value in values {
        groupedValues[value, default: 0] += 1
    }
    return groupedValues
}

func logger<T>(value: T) -> String where T: CustomDebugStringConvertible {
    return value.debugDescription
}

struct CustomType: CustomDebugStringConvertible, CustomStringConvertible {
    var description: String {
        return  "This is my description"
    }
    
    var debugDescription: String {
        return "This is my debugDescription"
    }
}

struct Logger {
    func log<T>(type: T)
        where T: CustomStringConvertible & CustomDebugStringConvertible {
            print(type.debugDescription)
            print(type.description)
    }
}

struct Pair<T: Hashable, U: Hashable>: Hashable {
    let left: T
    let right: U
    
    init(_ left: T, _ right: U) {
        self.left = left
        self.right = right
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(left)
        hasher.combine(right)
    }
    
    static func ==(_ lhs: Pair<T, U>, _ rhs: Pair<T, U>) -> Bool {
        return lhs.left == rhs.left && lhs.right == rhs.right
    }
}

class MiniCache<T: Hashable, U> {
    var cache = [T : U]()
    init() {}
    
    func insert(_ value: U, for key: T) {
        cache[key] = value
    }
    
    func read(from key: T) -> U? {
        return cache[key]
    }
}

class OnlineCourse {
    func start() {
        print("Starting online course.")
    }
}
class SwiftOnTheServer: OnlineCourse {
    override func start() {
        print("Starting Swift course.")
    }
}

struct Container<T> {}

struct Cache<T> {}

func refreshCache(_ cache: Cache<OnlineCourse>) {
    debugPrint("refreshing cache")
}

func readOptionalCourse(_ value: Optional<OnlineCourse>) {
    debugPrint("reading optional course", value)
}

func partGenerics() {
    let tuple = firstLast(array: [1, 2]) //MARK: Int already at compile time!
    debugPrint(tuple.0, tuple.1)
    debugPrint(firstLast(array: [1, 3, 5]))
    debugPrint(firstLast(array: ["A", "B", "C"]))
    
    let king: RoyalRank = .king
    let duke: RoyalRank = .duke
    
    debugPrint(duke > king)
    debugPrint(lowest([king, duke]) ?? "")
    
    debugPrint(occurences(values: [1, 1, 5, 6, 3, 5, 6, 7, 8, 2, 3, 3, 8]))
    debugPrint(logger(value: 1))
    
    let logger = Logger()
    logger.log(type: CustomType())
    
    let pair = Pair("left", 1)
    let dict = [pair : "Value"]
    debugPrint(dict)
    debugPrint(pair.hashValue)
    
    let set: Set<Pair> = [Pair(1, "one"), Pair(2, "two")]
    debugPrint(set)
    
    var hasher = Hasher()
    hasher.combine(pair)
    let hash = hasher.finalize()
    
    debugPrint(hash)
    
    let cache = MiniCache<String, Int>()
    cache.insert(1, for: "1")
    debugPrint(cache.read(from: "1") ?? "")
    
    let swiftCourse: SwiftOnTheServer = SwiftOnTheServer()
    let course: OnlineCourse = swiftCourse
    course.start()
    
    let containerSwiftCourse: Container<SwiftOnTheServer> = Container<SwiftOnTheServer>()
//    let containerCourse: Container<OnlineCourse> = containerSwiftCourse //MARK: not allowed
    let courseCache: Cache<SwiftOnTheServer> = Cache<SwiftOnTheServer>()
//    refreshCache(courseCache) //MARK: not allowed too
    
    //MARK: but for standard Swift types it is allowed
    let optionalCourse: Optional<SwiftOnTheServer> = SwiftOnTheServer()
    readOptionalCourse(optionalCourse) //MARK: allowed
    
    //MARK: invariant vs covariant
}
