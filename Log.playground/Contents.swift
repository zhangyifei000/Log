//: A UIKit based Playground for presenting user interface
  
import UIKit

// model log detail


struct LogDetails {
    var level: Log.Level
    var message: Any
    var date: Date
    var fileName: String
    var funcName: String
    var lineNumber: Int
    
    init(level: Log.Level = .debug, message: Any?, date: Date, fileName: String, funcName: String, lineNumber: Int) {
        self.level = level
        self.message = message ?? ""
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
    var hasLevel: Bool = true
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
            extraDescribe += "[\(Log.default.dateFormater.string(from: logDetails.date))]"
        }
        
        if hasFileName {
            extraDescribe += "[\(logDetails.fileName)]"
        }

        if hasFuncName {
            extraDescribe += "[\(logDetails.funcName)]"
        }

        if hasLineNumber {
            extraDescribe += "[\(logDetails.lineNumber)]"
        }

        extraDescribe += "\(logDetails.message)"
        print("\(Log.escape)fg\(extraDescribe)")
    }
}

open class Log {

    /// XcodeColors escape code
    public static let escape: String = "\u{001b}["
    
    /// XcodeColors code to reset the foreground colour
    public static let resetForeground = "\(escape)fg;"
    
    /// XcodeColors code to reset the background colour
    public static let resetBackground = "\(escape)bg;"
    
    /// XcodeColors code to reset both the foreground and background colours
    public static let reset: String = "\(escape);"
    var destinations: [DestinationProtocol] = []
    
    internal var _currentDateFormatter: DateFormatter?
    
    //  single instance
    
    open static var `default`: Log = {
        struct Static {
            static let instance: Log = Log()
        }
        return Static.instance
    }()
    
    open var dateFormater: DateFormatter {
        get {
            guard _currentDateFormatter !== nil else {
                struct Static {
                    static var dateFormatter: DateFormatter {
                        let defauletDateFormatter = DateFormatter()
                        defauletDateFormatter.locale = NSLocale.current
                        defauletDateFormatter.dateFormat = "MM-dd hh:mm:ss"
                        return defauletDateFormatter
                    }
                }
                return Static.dateFormatter
            }
             return _currentDateFormatter!
        }
        
        set(newValue) {
            _currentDateFormatter = newValue
        }
    }
    
    func addDestination(destination: DestinationProtocol) {
        self.destinations.append(destination)
        print(1)
    }
    
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
    
    open class func debug(_ message: Any?) {
        Log.default.setup(level: .debug, date: Date(), message: message)
    }
    
    // set up
    
    private func setup(level: Log.Level = .debug, date: Date, fileName: StaticString = #file ,functionName: StaticString = #function, lineNumber: Int = #line, message: Any?) {
        guard message != nil else {return}

        let logDetails: LogDetails = LogDetails(level: level, message: message, date: date, fileName: String.init(describing: fileName), funcName: String.init(describing: functionName), lineNumber: lineNumber)
        print(logDetails)
        for destination in self.destinations {
            print(destination)
            destination.process(logDetails: logDetails)
        }
    }
}

let baseDestination = BaseDestination()
Log.default.addDestination(destination: baseDestination)

Log.debug("122")











