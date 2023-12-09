//
//  File.swift
//  
//
//  Created by Dove Zachary on 2023/11/5.
//

import Foundation
extension hdiutilClass {
    public enum ConvertImageOption: HDIUtilOptions {
        
        /// overwrite target file(s) if it already exists
        case overwrite
        
        /// The default is 4 (2K).
        case alignment(Int)
        
        /// add partition map.
        ///
        /// When converting a `NDIF` to a any variety of `UDIF`,
        /// or when converting an unpartitioned UDIF, the default is true.
        case pmap
        
        /// Specify segmentation into size_spec-sized segments as outfile is being written.
        ///
        ///  The default size\_spec when `segmentSize` is specified alone is 2*1024*1024 (1 GB worth of sectors) for `UDTO` images and `4*1024*1024` (2 GB segments) for all other image types. 
        ///
        /// size\_spec can also be specified ??b|??k|??m|??g|??t??p|??e like create's -size flag.
        case segmentSize(String)
        
        /// When converting an image into a compressed format, specify the number of threads to use for the compression operation. 
        ///
        /// The default is the number of processors active in the current system.
        case tasks(_ taskCount: Int)
        
        // MARK: - Common options
        
        case encryption(CommonOption.CryptoMethod)
        case stdinPass
        case agentPass
        case certificate(String)
        case imageKey(_ key: String, _ value: String)
        case srcImageKey(_ key: String, _ value: String)
        case tgtImageKey(_ key: String, _ value: String)
        case shadow(_ shadowFile: String)
        case insecureHTTP
        
        /// Specify a certificate authority certificate.
        ///
        /// `cert` can beeither a PEM file or a directory of certificates processed by c\_rehash(1).\
        /// See also --capath and --cacert in curl(1).
        case cacert(String)
        case plist
        case puppetStrings
        case verbose
        case debug
        case quiet
    }
}


extension hdiutilClass.ConvertImageOption {
    public enum Format: String, Codable {
        /// read-only
        case udro = "UDRO"
        
        /// compressed (ADC)
        case udco = "UDCO"
        
        /// compressed
        case udzo = "UDZO"
        
        /// compressed (bzip2), deprecated
        case udbz = "UDBZ"
        
        /// compressed (lzfse)
        case ulfo = "ULFO"
        
        /// compressed (lzma)
        case ulmo = "ULMO"
        
        /// entire device
        case ufbi = "UFBI"
        
        /// iPod image
        case ipod = "IPOD"
        
        /// sparsebundle
        case udsb = "UDSB"
        
        /// sparse
        case udsp = "UDSP"
        
        /// read/write
        case udrw = "UDRW"
        
        /// DVD/CD master
        case udto = "UDTO"
    }
}


extension [hdiutilClass.ConvertImageOption] {
    var arguments: [String] {
        flatMap {
            switch $0 {
                case .overwrite:
                    ["-ov"]
                case .alignment(let alignment):
                    ["-align", "\(alignment)"]
                case .pmap:
                    ["-pmap"]
                case .segmentSize(let sizeSpec):
                    ["-segmentSize", sizeSpec]
                case .tasks(let taskCount):
                    ["-tasks", "\(taskCount)"]
                case .encryption(let method):
                    ["-encryption", method.rawValue]
                case .stdinPass:
                    ["-stdinpass"]
                case .agentPass:
                    ["-agentpass"]
                case .certificate(let cert):
                    ["-certificate", cert]
                case .imageKey(let key, let value):
                    ["-imagekey", "\(key)=\(value)"]
                case .srcImageKey(let key, let value):
                    ["-srcimagekey", "\(key)=\(value)"]
                case .tgtImageKey(let key, let value):
                    ["-tgtimagekey", "\(key)=\(value)"]
                case .shadow(let shadowFile):
                    ["-shadow", shadowFile]
                case .insecureHTTP:
                    ["-insecurehttp"]
                case .cacert(let fileOrDir):
                    ["-cacert", fileOrDir]
                case .plist:
                    ["-plist"]
                case .puppetStrings:
                    ["-puppetstrings"]
                case .verbose:
                    ["-verbose"]
                case .debug:
                    ["-debug"]
                case .quiet:
                    ["-quiet"]
            }
        }
    }
    
    var stringValue: String {
        self.arguments
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
