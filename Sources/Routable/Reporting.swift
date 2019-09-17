//
//  File.swift
//  
//
//  Created by Chris Conover on 9/11/19.
//

import Veneer

typealias Logger = Veneer.Logger
extension LoggerType {
    public static func route(
        _ format: String,
        _ args: CVarArg...,
        file: String = URL(string: #file)?.lastPathComponent ?? #file,
        function: String = #function,
        line: Int = #line) {

        debug(format, args, file: file, function: function, line: line)
    }
}
