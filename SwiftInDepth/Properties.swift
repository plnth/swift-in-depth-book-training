import Foundation

struct RunActivity {
    let id: String
    let startTime: Date
    var endTime: Date?
    
    var elapsedTime: TimeInterval {
        return Date().timeIntervalSince(startTime)
    }
    
    var isFinished: Bool {
        return endTime !=  nil
    }
    
    mutating func setFinished() {
        endTime = Date()
    }
    
    init(id: String, startTime: Date) {
        self.id = id
        self.startTime = startTime
        self.endTime = nil
    }
}

//var run = RunActivity(id: "10", startTime: Date())
//
//
//print(run.elapsedTime)
//sleep(4)
//print(run.elapsedTime)
//print(run.isFinished)
//run.setFinished()
//print(run.elapsedTime)

func defers() {
    defer { debugPrint("defer") }
    
    defer { debugPrint("second defer") }
    debugPrint("center")
    debugPrint("end")
}

func partProperties() {
    
}
