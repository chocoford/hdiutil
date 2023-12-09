//
//  File.swift
//  
//
//  Created by Dove Zachary on 2023/11/6.
//

import Foundation

extension hdiutilClass {
    public struct CreateOutput: Codable, Hashable {
        public var dmgURL: URL
        
        init?(_ hdiutilOutput: String) {
            guard let pathCompnent = hdiutilOutput.components(separatedBy: ": ").last?.replacingOccurrences(of: "\n", with: ""),
                let url = URL(string: "file://\(pathCompnent)") else {
                return nil
            }
            
            self.dmgURL = url
        }
    }
}
