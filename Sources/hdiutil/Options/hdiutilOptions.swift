//
//  File.swift
//  
//
//  Created by Dove Zachary on 2023/11/3.
//

import Foundation

public protocol HDIUtilOptions: Codable, Hashable {
    
}

extension [HDIUtilOptions] {
    var stringValue: String {
        var arguments: [String] = []
        
        for case let option as hdiutilClass.CommonOption in self {
            switch option {
                case .verbose:
                    arguments.append("-verbose")
                case .quiet:
                    arguments.append("-quiet")
                case .debug:
                    arguments.append("-debug")
            }
        }
        
        return arguments.joined(separator: " ")
    }
}


extension hdiutilClass {
    public enum CommonOption: HDIUtilOptions {
        /// be verbose: produce extra progress output and error diagnostics.
        ///
        /// This option can help the user decipher why a particular operation failed.
        /// At a minimum, the probing of any specified images will be detailed.
        case verbose
        
        /// close stdout and stderr, leaving only hdiutil's exit status to indicate success or failure.
        ///
        /// `debug` and `verbose` disable `quiet`.
        case quiet
        
        /// be very verbose.  This option is good if a large amount of progress information is needed.
        ///
        ///  As of macOS 10.6, `debug` enables `verbose`.
        case debug

    }
}

extension hdiutilClass.CommonOption {
    public enum CryptoMethod: String, Codable {
        /// 128-bit AES encryption (recommended)
        case aes128 = "AES-128"
        /// 256-bit AES encryption (more secure, but slower)
        case aes256 = "AES-256"
    }
}
