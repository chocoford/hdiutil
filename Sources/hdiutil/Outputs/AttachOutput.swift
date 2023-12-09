//
//  File.swift
//  
//
//  Created by Dove Zachary on 2023/11/6.
//

import Foundation

extension hdiutilClass {
    public struct AttachOutput: Codable, Hashable {
        public var deviceNode: String
//        var contentHint: String
        public var mountPoint: URL
        
        init?(_ outputString: String) {
            guard let deviceName = outputString.components(separatedBy: " ").first,
                  let mountDir = outputString.components(separatedBy: " ").last?.replacingOccurrences(of: "\t", with: "").replacingOccurrences(of: "\n", with: ""),
                  let mountURL = URL(string: "file://" + String(mountDir)) else {
                return nil
            }
            
            self.deviceNode = deviceName
            self.mountPoint = mountURL
        }
    }
    
}
