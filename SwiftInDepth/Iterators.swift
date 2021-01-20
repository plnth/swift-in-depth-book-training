import Foundation

func delete<T>(_ parameter: T) {
    debugPrint("deleting \(parameter)...")
}

struct Bag<Element: Hashable> {
    private var store = [Element : Int]()
    
    mutating func insert(_ element: Element) {
        store[element, default: 0] += 1
    }
    
    mutating func remove(_ element: Element) {
        store[element]? -= 1
        if store[element] == 0 {
            store[element] = nil
        }
    }
    
    var count: Int {
        return store.values.reduce(0, +)
    }
}

extension Bag: CustomStringConvertible {
    var description: String {
        var summary = String()
        for (key, value) in store {
            let times = value == 1 ? "time" : "times"
            summary.append("\(key) occurs \(value) \(times)\n")
        }
        return summary
    }
}

//struct BagIterator<T: Hashable>: IteratorProtocol {
//    var store = [T: Int]()
//
//    mutating func next() -> T? {
//        guard let (key, value) = store.first  else {
//            return nil
//        }
//        if value > 1 {
//            store[key]? -= 1
//        } else {
//            store[key] = nil
//        }
//        return key
//    }
//}

//extension Bag: Sequence {
//    func makeIterator() -> BagIterator<Element> {
//        return BagIterator(store: store)
//    }
//}

extension Bag: Sequence {
    func makeIterator() -> AnyIterator<Element> {
        var exhaustiveStore = store
        return AnyIterator<Element> {
            guard let (key, value) = exhaustiveStore.first  else {
                return nil
            }
            if value > 1 {
                exhaustiveStore[key]? -= 1
            } else {
                exhaustiveStore[key] = nil
            }
            return key
        }
    }
}

extension Bag: ExpressibleByArrayLiteral {
    typealias ArrayLiteralElement = Element
    init(arrayLiteral elements: Element...) {
        store = elements.reduce(into: [Element : Int]()) { (updatingScore, element) in
            updatingScore[element, default: 0] += 1
        }
    }
}

struct Activity: Equatable {
    let date: Date
    let description: String
}

struct Day: Hashable {
    let date: Date
    
    init(date: Date) {
        let unitFlags: Set<Calendar.Component> = [.day, .month, .year]
        let components = Calendar.current.dateComponents(unitFlags, from: date)
        guard let convertedDate = Calendar.current.date(from: components)
        else {
            self.date = date
            return
        }
        self.date = convertedDate
    }
}

struct TravelPlan {
    typealias DataType = [Day : [Activity]]
    
    private var trips = DataType()
    
    init(activities: [Activity]) {
        self.trips = Dictionary(grouping: activities, by: { activity -> Day in
            Day(date: activity.date)
        })
    }
    
    func getTrips() -> DataType {
        return self.trips
    }
}

extension TravelPlan: Collection {
    typealias KeysIndex = DataType.Index
    typealias DataElement = DataType.Element
    
    var startIndex: KeysIndex {
        return trips.keys.startIndex
    }
    
    var endIndex: KeysIndex {
        return trips.keys.endIndex
    }
    
    func index(after i: KeysIndex) -> KeysIndex {
        return trips.index(after: i)
    }
    
    subscript(index: KeysIndex) -> DataElement {
        return trips[index]
    }
}

extension TravelPlan {
    subscript(date: Date) -> [Activity] {
        return trips[Day(date: date)] ?? []
    }
    subscript(day: Day) -> [Activity] {
        return trips[day] ?? []
    }
}

extension TravelPlan: ExpressibleByArrayLiteral {
    init(arrayLiteral elements: Activity...) {
        self.init(activities: elements)
    }
}

func partIterators() {
    let cheeses = ["Gouda", "Camembert", "Brie"]
    let intArray = [6, 1, 10, -34, 21, 35, 2]
    
    var cheeseIterator: IndexingIterator<[String]> = cheeses.makeIterator()
    while let cheese = cheeseIterator.next() {
        debugPrint(cheese)
    }
    
    let filteredArray = intArray.filter({ value -> Bool in
        debugPrint(value)
        return value > 1
    })
    debugPrint("filteredArray: \(filteredArray)")
    
    intArray.forEach { element in
        debugPrint(element)
    }
    cheeses.forEach(delete)
    
    debugPrint(intArray.enumerated())
    
    let bigRange = 0 ..< Int.max
    let filteredBig = bigRange.lazy.filter { $0 % 2 == 0 }
    let lastThree = filteredBig.suffix(3)
    lastThree.forEach(delete)
    
    let text = "It's hard to come up with fresh exercises.\n\n\nOver and over again.\nAnd again."
    let startValue = 0
    let numberOfBreaks = text.reduce(startValue) { result, character in
        debugPrint("----------")
        debugPrint(result, character)
        if character == "\n" {
            return result + 1
        } else {
            return result
        }
    }
    debugPrint(numberOfBreaks)
    
    let grades = [3.2, 4.2, 2.6, 4.1]
//    let results = grades.reduce([:]) { (results : [Character : Int], grade: Double) in
//        var copy = results
//
//        switch grade {
//        case 1 ..< 2: copy["D", default: 0] += 1
//        case 2 ..< 3: copy["C", default: 0] += 1
//        case 3 ..< 4: copy["B", default: 0] += 1
//        case 4... : copy["A", default: 0] += 1
//        default: break
//        }
//        return copy
//    }
//    debugPrint(results)
    let reducedGrades = grades.reduce(into: [:]) { (results: inout [Character : Int], grade: Double) in
        switch grade {
        case 1 ..< 2: results["D", default: 0] += 1
        case 2 ..< 3: results["C", default: 0] += 1
        case 3 ..< 4: results["B", default: 0] += 1
        case 4... : results["A", default: 0] += 1
        default: break
        }
    }
    debugPrint("reducedGrades:")
    debugPrint(reducedGrades)
    
    let zipped = zip(0 ..< 10, ["a", "b", "c"])
    for (int, str) in zipped {
        debugPrint((int, str))
    }
    
    var bag = Bag<String>()
    bag.insert("Huey")
    bag.insert("Huey")
    bag.insert("Huey")
    bag.insert("Mickey")
    bag.remove("Huey")
    debugPrint(bag.count)
    debugPrint(bag)
    
    debugPrint(bag.filter { $0.count > 2 })
    debugPrint(bag.lazy.filter { $0.count > 2 })
    debugPrint(bag.contains("Mickey"))
    
    let _: Bag = ["Green", "Black"]
    
    var mutArray = [1, 2, 3, 4, 5, 6, 7, 8, 9]
    let i = mutArray.partition { $0 % 2 == 0 }
    debugPrint(i, mutArray)
    
    let activities = [
        Activity(date: Date(), description: "1"),
        Activity(date: Date(), description: "2"),
        Activity(date: Date(), description: "3"),
        Activity(date: Date(), description: "4"),
        Activity(date: Date(), description: "5"),
        Activity(date: Date(), description: "6"),
        Activity(date: Date(), description: "7"),
        Activity(date: Date(), description: "8"),
        Activity(date: Date(), description: "9"),
        Activity(date: Date(), description: "10")
    ]
    let travelPlan = TravelPlan(activities: activities)
    
    for (day, activities) in travelPlan {
        debugPrint("======")
        debugPrint(day.date)
        for activity in activities {
            debugPrint(activity)
        }
    }
    debugPrint(travelPlan[Date()])
    
//    let trips = travelPlan.getTrips()
//    debugPrint("trips:")
//    for trip in trips {
//        debugPrint("\(trip.key)\n\(trip.value)\n")
//    }
    let plans = [
        TravelPlan(activities: [Activity(date: Date(), description: "1")]),
        TravelPlan(activities: [Activity(date: Date(), description: "2")]),
        TravelPlan(activities: [Activity(date: Date(), description: "3")]),
        TravelPlan(activities: [Activity(date: Date(), description: "4")]),
        TravelPlan(activities: [Activity(date: Date(), description: "5")]),
        TravelPlan(activities: [Activity(date: Date(), description: "6")])
    ]
    for plan in plans {
        let trips = plan.getTrips()
        for trip in trips {
            debugPrint(trip.key, trip.value)
        }
        debugPrint("-----")
    }
}
