//
//  InfoOptions.swift
//
//
//  Created by Dove Zachary on 2023/11/6.
//

import Foundation

extension hdiutilClass {
    public typealias InfoOptions = [InfoOption]
    
    public enum InfoOption {
        /// display framework and driver version only
        case simplified
        
        // MARK: - Common options

        /// provide result output in plist format.
        ///
        /// Other programs invoking hdiutil are expected to use `plist` rather than try to parse the human-readable output.
        /// The usual output is consistent but generally unstructured.
        case plist

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
        /// As of macOS 10.6, `debug` enables `verbose`.
        case debug
    }
}

extension hdiutilClass.InfoOptions {
    var arguments: [String] {
        self.map {
            switch $0 {
                case .simplified:
                    "-s"
                case .plist:
                    "-plist"
                case .verbose:
                    "-verbose"
                case .quiet:
                    "-quiet"
                case .debug:
                    "-debug"
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
