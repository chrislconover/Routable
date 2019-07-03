//
//  Reporting.swift
//  Routable
//
//  Created by Chris Conover on 2/12/19.
//  Copyright © 2019 Chris Conover. All rights reserved.
//

import Foundation

class Diagnostics {
    static func report(_ message: String? = nil,
                       error: Error,
                       file: String = URL(string: #file)?.lastPathComponent ?? #file,
                       function: String = #function,
                       line: Int = #line) {
        if let message = message {
            Logger.error(
                "\(message): \(error.localizedDescription)",
                file: file, function: function, line: line)
        }
        else {
            Logger.error(error.localizedDescription,
                         file: file, function: function, line: line)
        }
    }
}


open class Logger: NSObject {

    public static func legacyError(_ format: String,
                                 file: String = URL(string: #file)?.lastPathComponent ?? #file,
                                 function: String = #function,
                                 line: Int = #line) {
        let extendedArgs = [CVarArg]()
        let extendedFormat = "[%d]\t ERROR " + format
        withVaList(extendedArgs) { doLog(extendedFormat, $0) }
    }

    public static func error(
        _ format: String,
        _ args: CVarArg...,
        file: String = #file,
        function: String = #function,
        line: Int = #line) {

        log(format, args, file: file, function: function, line: line)
    }


    public static func warn(
        _ format: String,
        _ args: CVarArg...,
        file: String = URL(string: #file)?.lastPathComponent ?? #file,
        function: String = #function,
        line: Int = #line) {

        log(format, args, file: file, function: function, line: line)
    }


    public static func trace(
        _ format: String,
        _ args: CVarArg...,
        file: String = URL(string: #file)?.lastPathComponent ?? #file,
        function: String = #function,
        line: Int = #line) {

        #if DEBUG
        log(format, args, file: file, function: function, line: line)
        #endif
    }

    public static func debug(
        _ format: String,
        _ args: CVarArg...,
        file: String = URL(string: #file)?.lastPathComponent ?? #file,
        function: String = #function,
        line: Int = #line) {

        #if DEBUG
        log(format, args, file: file, function: function, line: line)
        #endif
    }

    public static func log(
        _ format: String,
        _ args: CVarArg...,
        file: String = URL(string: #file)?.lastPathComponent ?? #file,
        function: String = #function,
        line: Int = #line) {

        let extendedFormat = "%@: %@ @%d\t " + format
        let extendedArgs : [CVarArg] = [ file, function, line ] + args
        withVaList(extendedArgs) { doLog(extendedFormat, $0) }
    }

    fileprivate static func doLog(_ format: String, _ args: CVaListPointer) {
        NSLogv(format, args)
    }
}

extension Logger {
    public static func route(
        _ format: String,
        _ args: CVarArg...,
        file: String = URL(string: #file)?.lastPathComponent ?? #file,
        function: String = #function,
        line: Int = #line) {

//        log(format, args, file: file, function: function, line: line)
    }
}




