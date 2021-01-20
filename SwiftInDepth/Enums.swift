import Foundation

enum DateType {
    case singleDate(Date), dateRange(Range<Date>)
}

let dates: [DateType] = [
    .singleDate(Date()),
    .singleDate(Date(timeIntervalSinceNow: 3600)),
    .dateRange(Date() ..< Date(timeIntervalSinceNow: 3600))
]

enum Topping {
    case creamCheese, peanutButter, jam
}

enum Bagel {
    case cinnamonRaising(topping: Topping)
    case glutenFree(topping: Topping)
    case oatMeal(topping: Topping)
    case blueberry(topping: Topping)
}

enum Age {
    case baby, toddler, teen
}

struct Puzzle {
    let numberOfPieces: Int
    let age: Age
}

enum Currency: String {
    case euro = "eur", usd, gbp
}

let currency = Currency.euro

//let parameters: [String : String]
//switch currency {
//    case .euro: parameters = ["filter" : "euro"]
//    case .usd: parameters = ["filter" : "usd"]
//    case .gbp: parameters = ["filter" : "gbp"]
//}

enum ImageType: String {
    case jpg, bmp, gif

    init?(rawValue: String) {
        switch rawValue.lowercased() {
            case "jpg", "jpeg": self = .jpg
            case "bmp", "bitmp": self = .bmp
            case "gif", "gifv": self = .gif
        default: return nil
        }
    }
}

func iconName(for fileExtension: String) -> String {
    guard let imageType = ImageType(rawValue: fileExtension) else {
        return "assetIconUnknown"
    }
    switch imageType {
        case .jpg: return "assetIconJpeg"
        case .bmp: return "assetIconBitmap"
        case .gif: return "assetIconGif"
    }
}

struct Run {}
struct Cycling {}
enum ActivityType {
    case run(Run)
    case cycling(Cycling)
}

//let type = ActivityType.run(Run())
//switch type {
//case let .run(run): debugPrint(run) //MARK: the same output
//case .cycling(let cycling): debugPrint(cycling)
//}


func partEnums() {
    
}
