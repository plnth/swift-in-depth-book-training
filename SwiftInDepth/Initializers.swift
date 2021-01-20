import Foundation

enum Pawn: CaseIterable {
    case dog, car, hat
}

struct Player {
    let name: String
    let pawn: Pawn
}

extension Player {
    init(name: String) {
        self.name = name
        self.pawn = Pawn.allCases.randomElement()!
    }
}

protocol BoardGameType {
    init(players: [Player], numberOfTiles: Int)
}

class BoardGame: BoardGameType {
    let players: [Player]
    let numberOfTiles: Int
    
    required init(players: [Player], numberOfTiles: Int) {
        self.players = players
        self.numberOfTiles = numberOfTiles
    }
    
    convenience init(players: [Player]) {
        self.init(players: players, numberOfTiles: 32)
    }
    
    convenience init(names: [String]) {
        var players = [Player]()
        for name in names {
            players.append(Player(name: name))
        }
        self.init(players: players, numberOfTiles: 32)
    }
    
    //MARK: factory methods
    class func makeGame(players: [Player]) -> Self {
        let bg = self.init(players: players, numberOfTiles: 32)
            //configuratioins: bg.locale = Locale.current [ ... ]
        return bg
    }
}

class MutabilityLand: BoardGame {
    var scoreBoard = [String: Int]()
    var winner: Player?
    
    let instructions: String
    
//    override init(players: [Player], numberOfTiles: Int) {
//        self.instructions = "Read the manual"
//        super.init(players: players, numberOfTiles: numberOfTiles)
//    }
    
    //MARK: convenience override init points to MutabilityLand designated initializer, and that one points to superclass's designated initializer. thus the subclasses of MutabilityLand wouldn't have to override all of the designated initializers to get access to all convenience initializers from super class BoardGame. any subclass of MutabilityLand now has to override only single designated init to have such access. sideways vs upwards
    convenience required init(players: [Player], numberOfTiles: Int) {
        self.init(players: players, instructions: "Read the manual", numberOfTiles: numberOfTiles)
    }
    
    init(players: [Player], instructions: String, numberOfTiles: Int) {
        self.instructions = instructions
        super.init(players: players, numberOfTiles: numberOfTiles)
    }
}

class MutabilityLandJunior: MutabilityLand {
    
    let soundsEnabled: Bool
    
    init(soundsEnabled: Bool, players: [Player], instructions: String, numberOfTiles: Int) {
        self.soundsEnabled = soundsEnabled
        super.init(players: players, instructions: instructions, numberOfTiles: numberOfTiles)
    }
    
    convenience override init(players: [Player], instructions: String, numberOfTiles: Int) {
        self.init(soundsEnabled: false, players: players, instructions: instructions, numberOfTiles: numberOfTiles)
    }
}

class Device {
    var serialNumber: String
    var room: String
    
    init(serialNumber: String, room: String) {
        self.serialNumber = serialNumber
        self.room = room
    }
    
    convenience init() {
        self.init(serialNumber: "Unknown", room: "Unknown")
    }
    
    convenience init(serialNumber: String) {
        self.init(serialNumber: serialNumber, room: "Unknown")
    }
    
    convenience init(room: String) {
        self.init(serialNumber: "Unknown", room: room)
    }
    
}

class Television: Device {
    enum ScreenType {
        case led
        case oled
        case lcd
        case unknown
    }
    
    enum Resolution {
        case ultraHd
        case fullHd
        case hd
        case sd
        case unknown
    }
    
    let resolution: Resolution
    let screenType: ScreenType
    
//    override init(serialNumber: String, room: String) {
//        self.resolution = .hd
//        self.screenType = .led
//        super.init(serialNumber: serialNumber, room: room)
//    }
    
    convenience override init(serialNumber: String, room: String) {
        self.init(resolution: Resolution.fullHd, screenType: ScreenType.led, serialNumber:
                    serialNumber, room: room)
    }
    
    init(resolution: Resolution, screenType: ScreenType, serialNumber:
            String, room: String) {
        self.resolution = resolution
        self.screenType = screenType
        super.init(serialNumber: serialNumber, room: room)
    }
}

protocol SomeProtocol {
    init(str: String)
}

final class SomeClass: SomeProtocol {
    let str: String
    //MARK: required keyword is unnesessary because class is final
    init(str: String) {
        self.str = str
    }
}

class HandHeldTelevision: Television {
    let weight: Int

    convenience override init(resolution: Television.Resolution, screenType: Television.ScreenType, serialNumber: String, room: String) {
        self.init(weight: 23, resolution: resolution, screenType: screenType, serialNumber: serialNumber, room: room)
    }
    
    init(weight: Int, resolution: Resolution, screenType: ScreenType, serialNumber: String, room: String) {
        self.weight = weight
        super.init(resolution: resolution, screenType: screenType, serialNumber: serialNumber, room: room)
    }

}
        
func partInializers() {
    
    //MARK: MEMBERVISE init - implicitly provided by default, doesn't work if custom init exists but works if custom one is in extension
    let onePlayer = Player(name: "Miha", pawn: .car)
    let anotherPlayer = Player(name: "Another")
    debugPrint(onePlayer, anotherPlayer)
    
    let ml = MutabilityLand(players: [Player(name: "test"), Player(name: "player")])
    debugPrint(ml.instructions)
    
    let firstTelevision = Television(room: "Lobby")
    let secondTelevision = Television(serialNumber: "abc")
    
    debugPrint(firstTelevision.room, firstTelevision.serialNumber, secondTelevision.room, secondTelevision.serialNumber)
    
    let mlJ = MutabilityLandJunior(players: [Player(name: "Peter")]) //MARK: subclasses only have to override a single initializer!
    
    debugPrint(mlJ.numberOfTiles)
    
    let handHeldTV = HandHeldTelevision(serialNumber: "293nr30znNdjW")
    debugPrint(handHeldTV.serialNumber, handHeldTV.room, handHeldTV.resolution, handHeldTV.weight, handHeldTV.screenType)
}
