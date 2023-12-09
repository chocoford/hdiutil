//
//  File.swift
//  
//
//  Created by Dove Zachary on 2023/11/30.
//

import Foundation

public extension hdiutilClass {
    enum hdiutilError: LocalizedError {
        case processError(String?)
        case invalidAppleScriptText
        case createError(CreateError)
        case attachError(AttachError)
        case unexpected(Any?)
        
        public var errorDescription: String? {
            switch self {
                case .processError(let string):
                    "Process error: \(string ?? "nil")"
                case .invalidAppleScriptText:
                    "Invalid apple script text"
                case .attachError(let attachError):
                    attachError.errorDescription
                case .createError(let createError):
                    createError.errorDescription
                case .unexpected(let anyInfo):
                    "Unexpected: \(String(describing: anyInfo))"
            }
        }
    }
}
