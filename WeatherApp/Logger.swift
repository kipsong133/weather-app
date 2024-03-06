import Foundation

/// 사용 예시
/// Logger.log("위치정보 획득 에러", level: .error)
/// Logger.log("이것은 경고 메시지입니다", level: .warning)
/// Logger.log("정보 메시지입니다")
class Logger {
    enum Level: String {
        case info = "INFO"
        case warning = "WARNING"
        case error = "ERROR"
    }
    
    static func log(_ message: String, level: Level = .info, file: String = #file, function: String = #function, line: Int = #line) {
        #if DEBUG
        let fileName = (file as NSString).lastPathComponent
        let logMessage = "[\(level.rawValue)] [\(fileName):\(line)] \(function) - \(message)"
        print(logMessage)
        #endif
    }
}

