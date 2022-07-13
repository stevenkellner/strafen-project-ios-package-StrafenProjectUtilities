//
//  Sequence+Sorted.swift
//  
//
//  Created by Steven on 13.07.22.
//

import Foundation

/// Order of sorted sequence.
public enum SortingOrder {

    /// Ascending order.
    case ascending

    /// Descanding order
    case descending
}

extension Sequence {

    /// Returns a sorted array, sorted by value at specified key path in specified order.
    /// - Parameters:
    ///   - keyPath: Key path to the value to sort sequence by.
    ///   - order: Order to sort sequence.
    /// - Returns: Sorted array.
    public func sorted<T>(by keyPath: KeyPath<Element, T>, order: SortingOrder = .ascending) -> [Element] where T: Comparable {
        return self.sorted { firstElement, secondElement in
            switch order {
            case .ascending:
                return firstElement[keyPath: keyPath] < secondElement[keyPath: keyPath]
            case .descending:
                return firstElement[keyPath: keyPath] > secondElement[keyPath: keyPath]
            }
        }
    }

    /// Returns a sorted array, sorted by value from sort value in specified order.
    /// - Parameters:
    ///   - sortValue: Gets value to sort sequence by.
    ///   - order: Order to sort sequence.
    /// - Returns: Sorted array.
    public func sorted<T>(by sortValue: (Element) throws -> T, order: SortingOrder = .ascending) rethrows -> [Element] where T: Comparable {
        return try self.sorted { firstElement, secondElement in
            switch order {
            case .ascending:
                return try sortValue(firstElement) < sortValue(secondElement)
            case .descending:
                return try sortValue(firstElement) > sortValue(secondElement)
            }
        }
    }
}

extension Sequence where Element: Comparable {

    /// Returns a sorted array in specified order.
    /// - Parameter order: Order to sort sequence.
    /// - Returns: Sorted array.
    public func sorted(order: SortingOrder = .ascending) -> [Element] {
        return self.sorted(by: \.self, order: order)
    }
}

extension Array {

    /// Sorts the array, sorted by value at specified key path in specified order.
    /// - Parameters:
    ///   - keyPath: Key path to the value to sort array by.
    ///   - order: Order to sort array.
    public mutating func sort<T>(by keyPath: KeyPath<Element, T>, order: SortingOrder = .ascending) where T: Comparable {
        self = self.sorted(by: keyPath, order: order)
    }

    /// Sorts the array, sorted by value from sort value in specified order.
    /// - Parameters:
    ///   - sortValue: Gets value to sort array by.
    ///   - order: Order to sort array.
    public mutating func sort<T>(by sortValue: (Element) throws -> T, order: SortingOrder = .ascending) rethrows where T: Comparable {
        self = try self.sorted(by: sortValue, order: order)
    }
}

extension Array where Element: Comparable {

    /// Sorts the array in specified order.
    /// - Parameter order: Order to sort array.
    public mutating func sort(order: SortingOrder = .ascending) {
        self = self.sorted(order: order)
    }
}
