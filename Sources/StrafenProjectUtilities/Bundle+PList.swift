//
//  Bundle+PList.swift
//  
//
//  Created by Steven on 13.07.22.
//

import Foundation

extension Bundle {

    /// Decodes a property list in the bundle to specified type.
    /// - Parameters:
    ///   - type: Type of the property list.
    ///   - fileName: Name of the property list file.
    /// - Returns: Decoded property list or nil if file didn't exitsts.
    func plist<T>(type: T.Type ,_ fileName: String) throws -> T? where T: Decodable {
        guard let path = self.path(forResource: fileName, ofType: "plist"),
              let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
            return nil
        }
        let decoder = PropertyListDecoder()
        return try decoder.decode(type, from: data)
    }
}
