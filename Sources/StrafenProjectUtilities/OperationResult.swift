//
//  OperationResult.swift
//  
//
//  Created by Steven on 13.07.22.
//

import Foundation

/// Result of a operation, either `passed` or `failed`.
public enum OperationResult {

    /// Operation has failed.
    case failed

    /// Operation has passed.
    case passed

    /// Toggles the operation result.
    ///
    /// Use this method to toggle a operation result from `.passed` to `.failed` or from
    /// `.failed` to `.passed`.
    public mutating func toggle() {
        if self == .passed {
            return self = .failed
        }
        self = .passed
    }

    /// Performs a logical AND operation on two operation results.
    ///
    /// The logical AND operator (`&&`) combines two operation results and returns
    /// `.passed` if both of the results are `.passed`. If either of the results is
    /// `.failed`, the operator returns `.failed`.
    ///
    /// - Parameters:
    ///   - lhs: left-hand side of the operation
    ///   - rhs: right-hand side of the operation
    /// - Throws: rethrows error
    /// - Returns: result of logical AND operation
    public static func && (lhs: OperationResult, rhs: @autoclosure () throws -> OperationResult) rethrows -> OperationResult {
        if lhs == .failed {
            return .failed
        }
        return try rhs()
    }

    /// Performs a logical OR operation on two operation results.
    ///
    /// The logical OR operator (`||`) combines two operation results and returns
    /// `.passed` if at least one of the results is `.passed`. If both results are
    /// `.failed`, the operator returns `.failed`.
    ///
    /// - Parameters:
    ///   - lhs: left-hand side of the operation
    ///   - rhs: right-hand side of the operation
    /// - Throws: rethrows error
    /// - Returns: result of logical OR operation
    public static func || (lhs: OperationResult, rhs: @autoclosure () throws -> OperationResult) rethrows -> OperationResult {
        if lhs == .passed {
            return .passed
        }
        return try rhs()
    }

    /// Performs a logical NOT operation on a operation result.
    ///
    /// The logical NOT operator (`!`) inverts a operation result. If the value is
    /// `.passed`, the result of the operation is `.failed`; if the result is `.failed`,
    /// the result is `.passed`.
    ///
    /// - Parameter rhs: operation result value to negate
    /// - Returns: negated operation result
    public static prefix func ! (rhs: OperationResult) -> OperationResult {
        var result = rhs
        result.toggle()
        return result
    }

    /// Evaluates all operation results of given evaluator
    /// - Parameter evaluator: evaluator to evaluate operation result
    /// - Returns: result of operation evaluator
    public static func evaluate(@OperationResultEvaluator _ evaluator: () -> OperationResult) -> OperationResult {
        return evaluator()
    }
}

extension Collection where Element == OperationResult {

    /// `.passed` if all elements are `.passed`, else `.failed`.
    public var allPassed: OperationResult {
        return self.allSatisfy { $0 == .passed } ? .passed : .failed
    }

    /// `.passed` if at least one element is `.passed`, else `.failed`.
    public var somePassed: OperationResult {
        return self.contains { $0 == .passed } ? .passed : .failed
    }
}

extension Collection {

    /// `.passed` if check of all elements are `.passed`, `.failed` otherwise.
    /// - Parameter evaluate: Closure to check if element is `.passed`.
    /// - Returns: Check result.
    public func evaluateAll(passed evaluate: (Element) throws -> OperationResult) rethrows -> OperationResult {
        return try self.map(evaluate).allPassed
    }
}

/// /// Result builder for operation result evaluation.
@resultBuilder public struct OperationResultEvaluator {
    public typealias Component = OperationResult

    public static func buildBlock(_ components: Component...) -> Component {
        return components.allPassed
    }

    public static func buildArray(_ components: [Component]) -> Component {
        return components.allPassed
    }

    public static func buildOptional(_ component: Component?) -> Component {
        return component ?? .passed
    }

    public static func buildEither(first component: Component) -> Component {
        return component
    }

    public static func buildEither(second component: Component) -> Component {
        return component
    }
}
