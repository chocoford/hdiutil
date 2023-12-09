//
//  CreateError.swift
//
//
//  Created by Dove Zachary on 2023/11/6.
//

import Foundation

extension hdiutilClass {
    public enum CreateError: LocalizedError {
        case invalidOutput
        
        public var errorDescription: String? {
            switch self {
                case .invalidOutput:
                    "invalid output"
            }
        }
    }
}
