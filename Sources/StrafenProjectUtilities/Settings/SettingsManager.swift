//
//  SettingsManager.swift
//  
//
//  Created by Steven on 13.07.22.
//

import Foundation
import Crypter

/// Manages settings of the app.
@dynamicMemberLookup public struct SettingsManager {

    /// Errors that can occur while managing settings.
    public enum Error: Swift.Error {

        /// Security application group identifier to get shared file direcory is invalid.
        case invalidSecurityApplicationGroupIdentifier

        /// Cryption keys aren't set for settings manager
        case noCryptionKeys
    }

    /// Cryption keys for settings manager.
    private var cryptionKeys: Crypter.Keys?

    /// Security application group identifier to get shared file direcory.
    private var securityApplicationGroupIdentifier: String?

    /// Contains setting properties of the app.
    private var settings: Settings

    /// Shared instance for singelton
    public static let shared = Self()

    /// Private init for singleton
    private init() {
        self.settings = Settings()
    }

    /// Url for settings file.
    private var settingsUrl: URL {
        get throws {
            guard let securityApplicationGroupIdentifier = self.securityApplicationGroupIdentifier,
                  let baseUrl = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: securityApplicationGroupIdentifier) else {
                throw Error.invalidSecurityApplicationGroupIdentifier
            }
            return baseUrl.appending(path: "settings") .appendingPathExtension("json")
        }
    }

    /// Read settings from file.
    public mutating func readSettings() throws {
        guard let encryptedJsonData = FileManager.default.contents(atPath: try self.settingsUrl.absoluteString) else { return }
        guard let cryptionKeys = self.cryptionKeys else {
            throw Error.noCryptionKeys
        }
        let crypter = Crypter(keys: cryptionKeys)
        let jsonData = try crypter.decryptAesAndVernam(encryptedJsonData)
        let decoder = JSONDecoder()
        self.settings = try decoder.decode(Settings.self, from: jsonData)
    }

    /// Get the setting currently cached or the default value, if setting isn't set or settings file isn't read already.
    /// - Parameter keyPath: Key path to the setting to get.
    /// - Returns: Cached setting or default value.
    public subscript<T>(dynamicMember keyPath: KeyPath<Settings, T?>) -> T where T: Defaultable {
        return self.settings[keyPath: keyPath] ?? T.default
    }

    /// Save the setting at specified key path and caches it.
    /// - Parameters:
    ///   - value: New value of the setting.
    ///   - keyPath: Key path to the setting to save.
    public mutating func saveSetting<T>(_ value: T, at keyPath: WritableKeyPath<Settings, T?>) throws {
        self.settings[keyPath: keyPath] = value
        let encoder = JSONEncoder()
        let jsonData = try encoder.encode(self.settings)
        guard let cryptionKeys = self.cryptionKeys else {
            throw Error.noCryptionKeys
        }
        let crypter = Crypter(keys: cryptionKeys)
        let encryptedJsonData = try crypter.encryptVernamAndAes(jsonData)
        if FileManager.default.fileExists(atPath: try self.settingsUrl.absoluteString) {
            try encryptedJsonData.write(to: try self.settingsUrl, options: .atomic)
        } else {
            FileManager.default.createFile(atPath: try self.settingsUrl.absoluteString, contents: encryptedJsonData)
        }
    }

    /// Sets the cryption keys for crypter.
    /// - Parameter cryptionKeys: Cryption keys to set in the returned settings manager.
    /// - Returns: Settings manager with specified cryption keys.
    public func cryptionKeys(_ cryptionKeys: Crypter.Keys) -> SettingsManager {
        var caller = self
        caller.cryptionKeys = cryptionKeys
        return caller
    }

    /// Sets the security application group identifier.
    /// - Parameter cryptionKeys: Security application group identifier to set in the returned settings manager.
    /// - Returns: Settings manager with specified security application group identifier.
    public func securityApplicationGroupIdentifier(_ securityApplicationGroupIdentifier: String) -> SettingsManager {
        var caller = self
        caller.securityApplicationGroupIdentifier = securityApplicationGroupIdentifier
        return caller
    }
}
