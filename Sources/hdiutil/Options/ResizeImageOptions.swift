//
//  ResizeImageOptions.swift
//
//
//  Created by Dove Zachary on 2023/11/4.
//

import Foundation

extension hdiutilClass {
    public enum ResizeImageOption: HDIUtilOptions {
        // MARK: - Size specifiers
        case size(CreateImageOption.Size)
        
        /// Specify the number of 512-byte sectors to which the partition should be resized.
        ///
        /// If this falls outside the mininum valid value or space remaining on the underlying file system, an error will be returned and the partition will not be resized.  `min` automatically determines the smallest possible size.
        case sectors(SectorsOptions)
        
        // MARK: - Other options
        
        /// only resize the image file, not the partition(s) and filesystems inside of it.
        case imageOnly
        
        /// only resize a partition / filesystem in the image, not the image.
        ///
        /// `partitionOnly` will fail if the new size won't fit inside the image. 
        ///  On APM, shrinking a partition results in an explicit Apple\_Free entry taking up the remaining space in the image.
        case partitionOnly
        
        /// specifies which partition to resize (UDIF only -- see HISTORY below).
        ///
        /// partitionNumber is 0-based, but, per hdiutil pmap, partition 0 is the partition map itself.
        case partitionNumber(Int)
        
        /// only allow the image to grow
        case growOnly
        
        /// only allow the image to shrink
        case shrinkOnly
        
        /// allow resize to entirely eliminate the trailing free partition in an APM map.  
        ///
        /// Restoring such images to very old hardware can interfere with booting.
        case noFinalGap
        
        /// Displays the minimum, current, and maximum sizes (in 512-byte sectors) for the image.
        ///
        /// In addition to any hosted filesystem constraints, UDRW images are constrained by available disk space in the filesystem hosting the image.  
        /// `limits` does not modify the image.
        case limits
        
        /// for given options, don't resize, just list resize information for the image and all (any) partitions.
        case allLimits
        
        // MARK: - Common options
        
        case encryption(CommonOption.CryptoMethod)
        case stdinpass
        case agentpass
        case srcImageKey(_ key: String, _ value: String)
        case shadow(String)
        case insecureHTTP
        case cacert(String)
        case plist
        case verbose
        case debug
        case quiet
    }
}

extension hdiutilClass.ResizeImageOption {
    public enum SectorsOptions: Codable, Hashable {
        case count(Int)
        case min
    }
}

extension [hdiutilClass.ResizeImageOption] {
    var arguments: [String] {
        self.map {
            switch $0 {
                case .size(let size):
                    size.stringValue
                case .sectors(let sectorsOptions):
                    switch sectorsOptions {
                        case .count(let count):
                            "-sectors \(count)"
                        case .min:
                            "-secotrs min"
                    }
                case .imageOnly:
                    "-imageonly"
                case .partitionOnly:
                    "-partitiononly"
                case .partitionNumber(let id):
                    "-partitionID \(id)"
                case .growOnly:
                    "-growonly"
                case .shrinkOnly:
                    "-shrinkonly"
                case .noFinalGap:
                    "-nofinalgap"
                case .limits:
                    "-limits"
                case .allLimits:
                    "-alllimits"
                case .encryption(let method):
                    "-encryption \(method.rawValue)"
                case .stdinpass:
                    "-stdinpass"
                case .agentpass:
                    "-agentpass"
                case .srcImageKey(let key, let value):
                    "-srcimagekey \(key)=\(value)"
                case .shadow(let file):
                    "-shadow \(file)"
                case .insecureHTTP:
                    "-insecurehttp"
                case .cacert(let fileOrDir):
                    "-cacert \(fileOrDir)"
                case .plist:
                    "-plist"
                case .verbose:
                    "-verbose"
                case .debug:
                    "-debug"
                case .quiet:
                    "-quiet"
            }
        }
    }
    
    public var stringValue: String {
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
