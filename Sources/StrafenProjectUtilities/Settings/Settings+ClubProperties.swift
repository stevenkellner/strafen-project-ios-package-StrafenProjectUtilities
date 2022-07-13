//
//  Settings+ClubProperties.swift
//  
//
//  Created by Steven on 12.07.22.
//

import StrafenProjectTypes

extension Settings {

    /// Contains all properties of the club.
    public struct ClubProperties {

        /// Id of the club.
        public let id: Club.ID

        /// Identifier of the club.
        public let identifier: String

        /// Name of the club.
        public let name: String

        /// Region code of the club.
        public let regionCode: String

        /// Indicates whether in app payment is active.
        public let inAppPaymentActive: Bool
    }
}

extension Settings.ClubProperties: Codable {}

extension Settings.ClubProperties: IClub {

    /// Initializes club with a `IClub` protocol.
    /// - Parameter club: `IClub` protocol to initialize the club.
    public init(_ club: some IClub) {
        self.id = club.id
        self.identifier = club.identifier
        self.name = club.name
        self.regionCode = club.regionCode
        self.inAppPaymentActive = club.inAppPaymentActive
    }

    public var personUserIds: Dictionary<String, Person.ID> {
        return [:]
    }
}

