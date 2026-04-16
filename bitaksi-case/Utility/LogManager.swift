//
//  LogManager.swift
//  bitaksi-case
//
//  Created by Semih Özsoy on 16.04.2026.
//

import Foundation
import CocoaLumberjackSwift

final class LogManager {

    static func setup() {
        DDLog.add(DDOSLogger.sharedInstance)
        let fileLogger = DDFileLogger()
        fileLogger.rollingFrequency = 60 * 60 * 24   // 24 saat
        fileLogger.logFileManager.maximumNumberOfLogFiles = 7
        DDLog.add(fileLogger)
    }

    static func debug(_ message: @autoclosure () -> String,
                      file: StaticString = #file,
                      function: StaticString = #function,
                      line: UInt = #line) {
        DDLogDebug(message(), file: file, function: function, line: line)
    }

    static func info(_ message: @autoclosure () -> String,
                     file: StaticString = #file,
                     function: StaticString = #function,
                     line: UInt = #line) {
        DDLogInfo(message(), file: file, function: function, line: line)
    }

    static func warning(_ message: @autoclosure () -> String,
                        file: StaticString = #file,
                        function: StaticString = #function,
                        line: UInt = #line) {
        DDLogWarn(message(), file: file, function: function, line: line)
    }

    static func error(_ message: @autoclosure () -> String,
                      file: StaticString = #file,
                      function: StaticString = #function,
                      line: UInt = #line) {
        DDLogError(message(), file: file, function: function, line: line)
    }
}
