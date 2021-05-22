//
//  File.swift
//  
//
//  Created by Chris Conover on 9/11/19.
//

import Veneer

public var logLevel: LogLevel {
    get { Logger.logLevel }
    set { Logger.logLevel = newValue }
}

typealias Logger = Veneer.Logger
extension LoggerType {
    public static func route(
        _ format: String,
        _ args: CVarArg...,
        file: String = #file,
        function: String = #function,
        line: Int = #line) {
        debug(format, args, file: file, function: function, line: line)
    }
}
