import Foundation

var opt: Optional<String> = "optional"
//MARK: When firstName has a value, bind it to name and print it.

//switch opt {
//case .none:
//    debugPrint("")
//case let some?:
//    debugPrint(some)
//}

struct Customer {
    let firstName: String?
    let lastName: String?
}

let customer = Customer(firstName: "a", lastName: "b")

//switch (customer.firstName, customer.lastName) {
//case (let firstName?, let lastName?): debugPrint(firstName, lastName)
//case (.none, _): debugPrint("")
//case (_, .none): debugPrint("")
//}

enum UserPreference: RawRepresentable {
    case enabled, disabled, notSet
    
    init(rawValue: Bool?) {
        switch rawValue {
        case nil: self = .notSet
        case true?: self = .enabled
        case false?: self = .disabled
        }
    }
    
    var rawValue: Bool? {
        switch self {
        case .enabled: return true
        case .disabled: return false
        case .notSet: return nil
        }
    }
}

enum AudioSetting: RawRepresentable {
    
    case enabled, disabled, unknown
    
    init(rawValue: Bool?) {
        switch rawValue {
        case true?: self = .enabled
        case false?: self = .disabled
        case nil: self = .unknown
        }
    }
    
    var rawValue: Bool? {
        switch self {
        case .enabled: return true
        case .disabled: return false
        case .unknown: return nil
        }
    }
}

let configuration: [String : Any?] = ["audioEnabled": nil]
let audioSetting = AudioSetting(rawValue: configuration["audioEnabled"] as? Bool)

//switch audioSetting {
//case .enabled: print("Turn up the jam!")
//case .disabled: print("sshh")
//case .unknown: print("Ask the user for the audio setting")
//}
//
//let isEnabled = audioSetting.rawValue
//debugPrint(#line)

func partOptionals() {
    
}
