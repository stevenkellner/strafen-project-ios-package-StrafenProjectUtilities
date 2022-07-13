//
//  Settings+Appearance.swift
//  
//
//  Created by Steven on 12.07.22.
//

#if os(iOS)
import UIKit
#else
import AppKit
#endif

extension Settings {

    /// Appearance of the app, `light`, `dark` or `system`.
    public enum Appearance {

        /// Use system appearance.
        case system

        /// Always use light appearance.
        case light

        /// Always use dark appearance.
        case dark
    }
}

extension Settings.Appearance: Codable, Defaultable {

    public static var `default`: Settings.Appearance {
        return .system
    }

#if os(iOS)
    /// Style for changing window style.
    private var uiStyle: UIUserInterfaceStyle {
        switch self {
        case .system: return .unspecified
        case .light: return .light
        case .dark: return .dark
        }
    }
#else
    /// Appearance for changing window style.
    private var nsAppearance: NSAppearance? {
        switch self {
        case .system: return nil
        case .light: return NSAppearance(named: .aqua)
        case .dark: return NSAppearance(named: .darkAqua)
        }
    }
#endif
}
