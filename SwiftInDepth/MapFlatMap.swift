import Foundation

func resolveCounts(statistics: [(String, Int)]) -> [String] {
    return statistics.map { name, count in
        switch count {
        case 0: return "\(name) isn't involved in the project."
        case 1..<100: return "\(name) isn't very active on the project."
        default: return "\(name) is active on the project."
        }
    }
}

func counts(statistics: [(String, Int)]) -> [Int] {
    return statistics
        .map { $0.1 }
        .filter { $0 > 0 }
        .sorted(by: >)
}

func removeEmojis(_ string: String) -> String {
    var scalars = string.unicodeScalars
    scalars.removeAll(where: isEmoji)
    return String(scalars)
}

func isEmoji(_ scalar: Unicode.Scalar) -> Bool {
    switch Int(scalar.value) {
    case 0x1F601...0x1F64F: return true // Emoticons
    case 0x1F600...0x1F636: return true // Additional emoticons
    case 0x2702...0x27B0: return true // Dingbats
    case 0x1F680...0x1F6C0: return true // Transport and map symbols
    case 0x1F681...0x1F6C5: return true // Additional transport and map symbols
    case 0x24C2...0x1F251: return true // Enclosed characters
    case 0x1F30D...0x1F567: return true // Other additional symbols
    default: return false
    }
}

class Cover {
    let image: UIImage
    let title: String?
    
    init(image: UIImage, title: String?) {
        self.image = image
        
//        self.title = title.map { chr -> String in
//            return removeEmojis(chr)
//        }
        
//        or
//        self.title = title.map { removeEmojis($0) }
        
//        or
        self.title = title.map(removeEmojis) //MARK: it’s a function that accepts one parameter and returns one parameter, which is exactly what map expects.
    }
}

func capitalizedAndTrimmed(_ string: String) -> String {
    return string.trimmingCharacters(in: .whitespaces).capitalized
}

func half(_ int: Int) -> Int? {
    guard int % 2 == 0 else { return nil }
    return int / 2
}

func partMapFlatMap() {
    let commitStats = [
        (name: "Miranda", count: 30),
        (name: "Elly", count: 650),
        (name: "John", count: 0),
        (name: "Matt", count: 34),
        (name: "Peter", count: 123)
    ]
    debugPrint(resolveCounts(statistics: commitStats))
    debugPrint(counts(statistics: commitStats))
    
    let commitsDict = Dictionary(uniqueKeysWithValues: commitStats)
    let mappedKeysAndValues = commitsDict.map { name, count -> String in
        switch count {
        case 0: return "\(name) isn't involved in the project."
        case 1..<100: return "\(name) isn't very active on the project."
        default: return "\(name) is active on the project."
        }
    }
    debugPrint(mappedKeysAndValues)
    let mappedValues = commitsDict.mapValues { count -> String in
        return "\(count)"
    }
    debugPrint(mappedValues)
    
    debugPrint([9, 8, 7, 6, 5, 4, 3, 2, 1].map { [$0] } )
    
    let names = [
        "John",
        "Mary",
        "Elizabeth"
    ]
    let nameCount = names.count
    let generatedNames = (0 ..< 5).map { index in
        return names[index % nameCount]
    }
    debugPrint(generatedNames)
    
    let possibleNilsArray: Array<Optional<Int>> = [3, nil, 24, 7, nil, nil]
    let mapped = possibleNilsArray.map { $0 }
    debugPrint(mapped)
    
    let num: Int? = 8
    let numUnwrapped = [num].map { $0! }.first!
    debugPrint(numUnwrapped)
    
    let contact =
        ["address":
            [
                "zipcode": "12345",
                "street": "broadway",
                "city": "wichita"
            ]
    ]
    
    let capitalizedStreet = contact["address"]?["street"].map {
        capitalizedAndTrimmed($0)
    }
    let capitalizedCity = contact["address"]?["city"].map {
        capitalizedAndTrimmed($0)
    }
    debugPrint(capitalizedStreet ?? "", capitalizedCity ?? "")
    
    let receivedData = ["url": "https://www.clubpenguinisland.com"]
    let path: String? = receivedData["url"]
    let url = path.flatMap { string -> URL? in
        return URL(string: string)
    }
    debugPrint(url as Any)
    
    let startValue = 8
    let four = half(startValue)
    let two = four.flatMap { number -> Int? in
        debugPrint(number)
        let nestedTwo = half(number)
        debugPrint(nestedTwo as Any)
        return nestedTwo
    }
    debugPrint(two as Any)
    let five = Optional(20).flatMap { number in
        return half(number)
    }.flatMap { number in
        return half(number)
    }
//    .flatMap { number in
//        return half(number)
//    }
//    MARK: The closure in the last flatMap operation won’t be called because the optional is nil before.
    debugPrint(five as Any)
    let endResult = half(80)
        .flatMap(half)
        .flatMap(half)
        .flatMap(half)
    debugPrint(endResult as Any)
    
    debugPrint([2, 3].flatMap { [$0, $0] })
    
    let str = "Hellooooooooo!!!!"
    debugPrint(str.interspersed("-"))
    
    let suits = ["Hearts", "Clubs", "Diamonds", "Spades"]
    let faces = ["2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K", "A"]
    let deckOfCards = suits.flatMap { suit in
        faces.map { face in
            (suit, face)
        }
    }
    debugPrint(deckOfCards.shuffled())
    
    let strs = [
        "https://www.duckduckgo.com",
        "https://www.twitter.com",
        "OMG SHOES",
        "https://www.swift.org"
    ]
    let optionalURLs = strs.map { URL(string: $0) }
    debugPrint(optionalURLs as Any)
    let urls = strs.compactMap { URL(string: $0) }
    debugPrint(urls)
    for case let url? in optionalURLs {
        debugPrint("the URL is \(url)")
    }
    
    let startString = "abcd"
    let finalResults = startString.flatMap { a -> [(Character, Character)] in
        startString.compactMap { b -> (Character, Character)? in
            if a == b { return nil } else { return (a, b) }
        }
    }
    debugPrint(finalResults)
    
    exercises()
}

extension String {
    func interspersed(_ element: Character) -> String {
        let characters = self.flatMap {
            [$0, element]
        }.dropLast()
        
        return String(characters)
    }
}

func arrayWithSubtractedAndAdded(_ array: [Int]) -> [Int] {
    return array.flatMap { [$0 - 1, $0, $0 + 1] }
}

func removeVowels(in string: String) -> String {
    let characters = string.compactMap { symbol -> Character? in
        switch symbol {
        case "e", "u", "i", "o", "a": return nil
        default: return symbol
        }
    }
    return String(characters)
}

func generaterPairs(from array: [Int]) -> [(Int, Int)] {
    return array.flatMap { firstNumber in
        array.compactMap { secondNumber in
            return (firstNumber, secondNumber)
        }
    }
}

func duplicateInside<T>(array arr: [T]) -> [T] {
    return arr.flatMap { [$0, $0] }
}

func exercises() {
    debugPrint(arrayWithSubtractedAndAdded([20, 30, 40]))
    let strideSequence = stride(from: 0, through: 30, by: 2)
    debugPrint(strideSequence.compactMap { int in
        return int % 10 == 0 ? int : nil
    })
    
    debugPrint(removeVowels(in: "aaaappppotoiiooho"))
    
    debugPrint(generaterPairs(from: [1, 2, 3]))
    
    debugPrint(duplicateInside(array: [["a", "b"], ["c", "d"]]))
}
