/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Provides helper types for the BERT model's outputs.
*/

import CoreML

extension Array where Element: Comparable {
    /// Provides the indices of the largest elements.
    ///
    /// - parameters:
    ///     - count: The number of indicies to return, at most.
    /// - returns: An array of integers.
    func indicesOfLargest(_ count: Int = 10) -> [Int] {
        let count = Swift.min(count, self.count)
        let sortedSelf = enumerated().sorted { (arg0, arg1) in arg0.element > arg1.element }
        let topElements = sortedSelf[0..<count]
        let topIndices = topElements.map { (tuple) in tuple.offset }
        return topIndices
    }
}

extension MLMultiArray {
    /// Creates a copy of the multi-array's contents into a Doubles array.
    ///
    /// - returns: An array of Doubles.
    func doubleArray() -> [Double] {
        // Bind the underlying `dataPointer` memory to make a native swift `Array<Double>`
        let unsafeMutablePointer = dataPointer.bindMemory(to: Double.self, capacity: count)
        let unsafeBufferPointer = UnsafeBufferPointer(start: unsafeMutablePointer, count: count)
        return [Double](unsafeBufferPointer)
    }
}
