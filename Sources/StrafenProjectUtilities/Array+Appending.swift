//
//  Array+Appending.swift
//  
//
//  Created by Steven on 13.07.22.
//

import Foundation

extension Array {

    /// Returns a new array with new element appended.
    /// - Parameter newElement: Element to append.
    /// - Returns: Array with new element appended.
    public func appending(_ newElement: Element) -> [Element] {
        var list = self
        list.append(newElement)
        return list
    }
    /// Returns a new array with new elements appended.
    /// - Parameter newElements: Elements to append,
    /// - Returns: Array with new elements appended-
    public func appending(contentsOf newElements: some Sequence<Element>) -> [Element] {
        var list = self
        list.append(contentsOf: newElements)
        return list
    }
}
