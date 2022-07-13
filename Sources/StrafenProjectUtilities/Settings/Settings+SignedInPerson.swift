//
//  Settings+SignedInPerson.swift
//  
//
//  Created by Steven on 12.07.22.
//

import StrafenProjectTypes
import Foundation

extension Settings {

    /// Contains all properties of the signed in person.
    public struct SignedInPerson {

        /// Id of the person.
        public let id: Person.ID

        /// Name of the person.
        public let name: PersonName

        /// Date of sign in of the person.
        public let signInDate: Date

        /// Indicates whether person is admin.
        public let admin: Bool

        /// User id of the person.
        public let userId: String
    }
}

extension Settings.SignedInPerson: Codable {}

extension Settings.SignedInPerson: IPerson {

    /// Initializes person with a `IPerson` protocol.
    /// - Parameter person: `IPerson` protocol to initialize the person.
    public init?(_ person: some IPerson) {
        self.id = person.id
        self.name = PersonName(person.name)
        guard let signInData = person.signInData else { return nil }
        self.signInDate = signInData.signInDate
        self.admin = signInData.admin
        self.userId = signInData.userId
    }

    public var signInData: SignInData? {
        return SignInData(admin: self.admin, signInDate: self.signInDate, userId: self.userId)
    }
}
