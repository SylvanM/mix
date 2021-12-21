//
//  ClosedRange+Count.swift
//  mix
//
//  Created by Sylvan Martin on 12/20/21.
//

import Foundation

extension ClosedRange where Bound: BinaryInteger {
    
    /**
     * The number of elements in this range
     */
    var count: Int {
        return Int(upperBound - lowerBound + 1)
    }
    
}
