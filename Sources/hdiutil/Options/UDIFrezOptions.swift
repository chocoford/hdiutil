//
//  File.swift
//  
//
//  Created by Dove Zachary on 2023/11/5.
//

import Foundation

extension hdiutilClass {
    public typealias UDIFrezOptions = [UDIFrezOption]

    public enum UDIFrezOption: HDIUtilOptions {
        /// Copy resources from the XML in file.
        case xml(_ file: String)
        /// Copy resources from file's resource fork.
        case rsrcFork(_ file: String)
        /// Delete all pre-existing resources in image.
        case replaceAll
    }
}


extension hdiutilClass.UDIFrezOptions {
    var arguments: [String] {
        self.map {
            switch $0 {
                case .xml(let file):
                    "-xml \(file)"
                case .rsrcFork(let file):
                    "-rsrcfork \(file)"
                case .replaceAll:
                    "-replaceall"
            }
        }
    }
    
    var stringValue: String {
        arguments
            .map {
                if $0.hasPrefix("-") {
                    return $0
                } else {
                    return "\"\($0)\""
                }
            }
            .joined(separator: " ")
    }
}
