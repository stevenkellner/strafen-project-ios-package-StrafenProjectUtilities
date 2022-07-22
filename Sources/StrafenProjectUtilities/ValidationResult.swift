//
//  ValidationResult.swift
//  
//
//  Created by Steven on 22.07.22.
//

import Foundation

/// Result of a validation, either `valid` or `invalid`.
public enum ValidationResult {

    /// Validation was valid.
    case valid

    /// Validation was invalid.
    case invalid

    /// Toggles the validation result.
    ///
    /// Use this method to toggle a validation result from `.valid` to `.invalid` or from
    /// `.invalid` to `.valid`.
    public mutating func toggle() {
        if self == .valid {
            return self = .invalid
        }
        self = .valid
    }

    /// Performs a logical AND validation on two validation results.
    ///
    /// The logical AND operator (`&&`) combines two validation results and returns
    /// `.valid` if both of the results are `.valid`. If either of the results is
    /// `.invalid`, the operator returns `.invalid`.
    ///
    /// - Parameters:
    ///   - lhs: left-hand side of the validation
    ///   - rhs: right-hand side of the validation
    /// - Throws: rethrows error
    /// - Returns: result of logical AND validation
    public static func && (lhs: ValidationResult, rhs: @autoclosure () throws -> ValidationResult) rethrows -> ValidationResult {
        if lhs == .invalid {
            return .invalid
        }
        return try rhs()
    }

    /// Performs a logical OR validation on two validation results.
    ///
    /// The logical OR operator (`||`) combines two validation results and returns
    /// `.valid` if at least one of the results is `.valid`. If both results are
    /// `.invalid`, the operator returns `.invalid`.
    ///
    /// - Parameters:
    ///   - lhs: left-hand side of the validation
    ///   - rhs: right-hand side of the validation
    /// - Throws: rethrows error
    /// - Returns: result of logical OR validation
    public static func || (lhs: ValidationResult, rhs: @autoclosure () throws -> ValidationResult) rethrows -> ValidationResult {
        if lhs == .valid {
            return .valid
        }
        return try rhs()
    }

    /// Performs a logical NOT validation on a validation result.
    ///
    /// The logical NOT operator (`!`) inverts a validation result. If the value is
    /// `.valid`, the result of the validation is `.invalid`; if the result is `.invalid`,
    /// the result is `.valid`.
    ///
    /// - Parameter rhs: validation result value to negate
    /// - Returns: negated validation result
    public static prefix func ! (rhs: ValidationResult) -> ValidationResult {
        var result = rhs
        result.toggle()
        return result
    }

    /// Evaluates all validation results of given evaluator
    /// - Parameter evaluator: evaluator to evaluate validation result
    /// - Returns: result of validation evaluator
    public static func evaluate(@ValidationResultEvaluator _ evaluator: () -> ValidationResult) -> ValidationResult {
        return evaluator()
    }
}

extension Collection where Element == ValidationResult {

    /// `.valid` if all elements are `.valid`, else `.invalid`.
    public var allValid: ValidationResult {
        return self.allSatisfy { $0 == .valid } ? .valid : .invalid
    }

    /// `.valid` if at least one element is `.valid`, else `.invalid`.
    public var someValid: ValidationResult {
        return self.contains { $0 == .valid } ? .valid : .invalid
    }
}

extension Collection {

    /// `.valid` if check of all elements are `.valid`, `.invalid` otherwise.
    /// - Parameter evaluate: Closure to check if element is `.valid`.
    /// - Returns: Check result.
    public func evaluateAll(valid evaluate: (Element) throws -> ValidationResult) rethrows -> ValidationResult {
        return try self.map(evaluate).allValid
    }
}

/// /// Result builder for validation result evaluation.
@resultBuilder public struct ValidationResultEvaluator {
    public typealias Component = ValidationResult

    public static func buildBlock(_ components: Component...) -> Component {
        return components.allValid
    }

    public static func buildArray(_ components: [Component]) -> Component {
        return components.allValid
    }

    public static func buildOptional(_ component: Component?) -> Component {
        return component ?? .valid
    }

    public static func buildEither(first component: Component) -> Component {
        return component
    }

    public static func buildEither(second component: Component) -> Component {
        return component
    }
}
