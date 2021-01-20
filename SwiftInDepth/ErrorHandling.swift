import Foundation

enum ParseLocationError: Error {
    case invalidData
    case locationDoesNotExist
    case middleOfTheOcean
}

struct Location {
    let latitude: Double
    let longitude: Double
}

/// Turns two strings with a latitude and longitude value into a Location type
/// - Parameters:
///   - lat: A string containing a latitude value
///   - lon: A string containing a longitude value
/// - Throws: Will throw a ParseLocationError.invalidData if lat and long can't be converted to Double.
/// - Returns: A Location struct
func parseLocation(_ lat: String, _ lon: String) throws -> Location {
    guard let lat = Double(lat), let lon = Double(lon) else {
        throw ParseLocationError.invalidData
    }
    return Location(latitude: lat, longitude: lon)
}

struct Recipe {
    let ingredients: [String]
    let steps: [String]
}

enum ParseRecipeError: Error {
    case parseError(line: Int, symbol: String)
    case noRecipeDetected
    case noIngredientsDetected
}

extension ParseRecipeError: LocalizedError {
    
    var errorDescription: String? {
        switch self {
        case .parseError:
            return NSLocalizedString("The HTML file had unexpected symbols.",
                                     comment: "Parsing error reason unexpected symbols")
        case .noIngredientsDetected:
            return NSLocalizedString("No ingredients were detected.",
                                     comment: "Parsing error no ingredients.")
        case .noRecipeDetected:
            return NSLocalizedString("No recipe was detected.",
                                     comment: "Parsing error no recipe.")
        }
    }
    
    var failureReason: String? {
        switch self {
        case let .parseError(line: line, symbol: symbol):
            return String(format: NSLocalizedString("Parsing data failed at line: %i and symbol: %@",
                                                    comment: "Parsing error line symbol"), line, symbol)
        case .noIngredientsDetected:
            return NSLocalizedString("The recipe seems to be missing its ingredients.",
                                     comment: "Parsing error reason missing ingredients.")
        case .noRecipeDetected:
            return NSLocalizedString("The recipe seems to be missing a recipe.",
                                     comment: "Parsing error reason missing recipe.")
        }
    }
    
    var recoverySuggestion: String? {
        return "Please try a different recipe."
    }
}

extension ParseRecipeError: CustomNSError {
    
    static var errorDomain: String { return "com.recipeextractor" }
    var errorCode: Int { return 300 }
    var errorUserInfo: [String : Any] {
        return [
            NSLocalizedDescriptionKey: errorDescription ?? "",
            NSLocalizedFailureReasonErrorKey: failureReason ?? "",
            NSLocalizedRecoverySuggestionErrorKey: recoverySuggestion ?? ""
        ]
    }
}

struct RecipeExtractor {

    let html: String
    
    func extractRecipe() throws -> Recipe {
        return try parseWebpage(html)
    }
    
    private func parseHTML(_ html: String) throws -> Recipe {
        let ingredients = try parseIngredients(html)
        let steps = try parseSteps(html)
        return Recipe(ingredients: ingredients, steps: steps)
    }

    private func parseWebpage(_ html: String) throws -> Recipe {
        let ingredients = try parseIngredients(html)
        let steps = try parseSteps(html)
        return Recipe(ingredients: ingredients, steps: steps)
    }

    private func parseIngredients(_ html: String) throws -> [String] {
        // ... Parsing happens here

        // .. Unless an error is thrown
        throw ParseRecipeError.parseError(line: #line, symbol: "*")
    }

    private func parseSteps(_ html: String) throws -> [String] {
        // ... Parsing happens here

        // .. Unless an error is thrown
        throw ParseRecipeError.noRecipeDetected
    }

}

struct ErrorHandler {
    
    static let `default` = ErrorHandler()
    
    let genericMessage = "Sorry! Something went wrong"
    
    func handleError(_ error: Error) {
        presentToUser(message: genericMessage)
    }
    
    //MARK: if localized
    func handleError(_ error: LocalizedError) {
        if let errorDescription = error.errorDescription {
            presentToUser(message: errorDescription)
        } else {
            presentToUser(message: genericMessage)
        }
    }
    
    func presentToUser(message: String) {
        // Show alert dialog in iOS or OSX
        // ... snip
    }
}

enum LoadError: Error {
    case couldntLoadFile
}

func loadFile(name: String) -> Data? {
    let url = URL(fileURLWithPath: NSHomeDirectory())
    do {
        return try Data(contentsOf: url)
    } catch let error as LoadError {
        print(error)
        return nil
    } catch {
        debugPrint("other error")
        return nil
    }
}

//MARK: throwable initializer if we don't want to validate the same value multiple times
enum ValidationError: Error {
    case noEmptyValueAllowed
    case invalidPhoneNumber
}

struct PhoneNumber {
    let contents: String
    
    init(_ text: String) throws {
        guard !text.isEmpty else {
            throw ValidationError.noEmptyValueAllowed
        }
        
        let pattern = "^(\\([0-9]{3}\\) |[0-9]{3}-)[0-9]{3}-[0-9]{4}$"
        if text.range(of: pattern, options: .regularExpression) == nil {
            throw ValidationError.invalidPhoneNumber
        }
        self.contents = text
    }
}

func partErrorHandling() {
//    do {
//        let loc = try parseLocation("a", "~")
//        debugPrint(loc)
//    } catch {
//        debugPrint(error)
//    }
    
    let re = RecipeExtractor(html: "test")
    do {
        _ = try re.extractRecipe()
    } catch {
        ErrorHandler.default.handleError(error)
    }
    
    let nsError: NSError = ParseRecipeError.parseError(line: 3, symbol: "#") as NSError
    print(nsError)
    
    do {
        let phoneNumber = try PhoneNumber("(123) 123-1234")
        debugPrint(phoneNumber)
    } catch {
        debugPrint(error)
    }
}
