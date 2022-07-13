//
//  Defaultable.swift
//  
//
//  Created by Steven on 13.07.22.
//

import Foundation

/// Type with a default value.
public protocol Defaultable {

    /// Default value of this type.
    static var `default`: Self { get }
}

extension Optional: Defaultable {
    public static var `default`: Optional<Wrapped> {
        return .none
    }
}
