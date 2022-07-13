//
//  ConnectionState.swift
//  
//
//  Created by Steven on 13.07.22.
//

import Foundation

/// State of a connection task.
public enum ConnectionState {

    /// Task not started yet.
    case notStarted

    /// Task is still loading.
    case loading

    /// Task is failed.
    case failed

    /// Task is passed.
    case passed

    /// Sets state to `notStarted`.
    public mutating func reset() {
        self = .notStarted
    }

    /// Sets state to `.loading` if current state is `notStarted`.
    /// - Returns: `passed`if current state is `notStarted`, `failed` otherwise.
    @discardableResult public mutating func start() -> OperationResult {
        guard self == .notStarted else { return .failed }
        self = .loading
        return .passed
    }

    /// Sets state to `.loading` if current state is not `loading`.
    /// - Returns: `passed`if current state is not `loading`, `failed` otherwise.
    @discardableResult public mutating func restart() -> OperationResult {
        guard self != .loading else { return .failed }
        self = .loading
        return .passed
    }

    /// Sets state to `failed`.
    public mutating func failed() {
        self = .failed
    }

    /// Sets state to `passed`.
    public mutating func passed() {
        self = .passed
    }
}
