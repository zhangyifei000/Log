//: A UIKit based Playground for presenting user interface
  
import UIKit

// model log detail

struct LogDetails {
    var level: Log.Level
    var message: String
    var date: Date
    var fileName: String
    var funcName: String
    var lineNumber: Int
    
    init(level: Log.Level = .debug, message: String, date: Date, fileName: String, funcName: String, lineNumber: Int) {
        self.level = level
        self.message = message
        self.date = date
        self.fileName = fileName
        self.funcName = funcName
        self.lineNumber = lineNumber
    }
}

protocol DestinationProtocol {
    var hasLevel: Bool {get set}
    var hasDate: Bool {get set}
    var hasFileName: Bool {get set}
    var hasFuncName: Bool {get set}
    var hasLineNumber: Bool {get set}
    
    func process(logDetails: LogDetails)
}

class BaseDestination: DestinationProtocol {
    var hasLevel: Bool = false
    var hasDate: Bool = true
    var hasFileName: Bool = true
    var hasFuncName: Bool = true
    var hasLineNumber: Bool = true
    
    func process(logDetails: LogDetails) {
        var extraDescribe = ""
        
        if hasLevel {
            extraDescribe += "[\(logDetails.level)]"
        }
        
        if hasDate {
            
        }
    }
}

open class Log {

    //  single instance
    
    open static var `default`: Log = {
        struct Static {
            static let instance: Log = Log()
        }
        return Static.instance
    }()
    
    // log level

    public enum Level: Int, CustomStringConvertible {
        case debug
        case warning
        case error
        
        public var description: String {
            switch self {
            case .debug:
                return "debug"
            case .warning:
                return "warning"
            case .error:
                return "error"
            }
        }
    }
    
    // set up
    
    func setup() {
        
    }
}
