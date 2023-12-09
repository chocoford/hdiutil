//
//  File.swift
//  
//
//  Created by Dove Zachary on 2023/11/6.
//

import Foundation

extension hdiutilClass.hdiutilError {
    public enum AttachError: LocalizedError {
        case invalidOutput
        
        public var errorDescription: String? {
            switch self {
                case .invalidOutput:
                    "invalid output"
            }
        }
    }
}
