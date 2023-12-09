//
//  File.swift
//  
//
//  Created by Dove Zachary on 2023/11/5.
//

import Foundation

extension hdiutilClass {
    public typealias InternetEnableOptions = [InternetEnableOption]
    
    public enum InternetEnableOption: HDIUtilOptions {
        case encryption
        case stdinPass
        case srcImageKey
        case plist
    }
}

extension hdiutilClass.InternetEnableOption {
    public enum Enability {
        case yes
        case no
        case query
    }
}

extension hdiutilClass.InternetEnableOptions {
    var stringValue: String {
        var arguments: [String] = []
        
        arguments.append(
            contentsOf: self.map {
                switch $0 {
                    case .encryption:
                        ""
                    case .stdinPass:
                        ""
                    case .srcImageKey:
                        ""
                    case .plist:
                        ""
                }
            }
        )
        
        return arguments.joined(separator: " ")
    }
}
