//
//  Settings.swift
//  
//
//  Created by Steven on 12.07.22.
//

import Foundation

/// Contains setting properties of the app.
public struct Settings: Codable {

    /// Appearance of the app, light, dark or system.
    public var appearance: Appearance?

    /// Contains all properties of the signed in person.
    public var signedInPerson: SignedInPerson??

    /// Contains all properties of the club.
    public var clubProperties: ClubProperties??
}
