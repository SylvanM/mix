//
//  MIX.swift
//  mix
//
//  Created by Sylvan Martin on 12/18/21.
//

import Foundation

/**
 * The `MIX` computer, described by Donald Knuth in The Art of Computer Programming
 *
 * This is actuallty just a Swift wrapper for the mix type which is defined in `C`
 */
public struct MIX {
    
    // MARK: - Properties
    
    private var mixState: mix_t
    
    // MARK: - Register Interfaces
    
    /**
     * Register Labels
     */
    public enum RegisterLabel: Int, CaseIterable {
        case a = 0
        case x = 1
    
        case i1 = 2
        case i2 = 3
        case i3 = 4
        case i4 = 5
        case i5 = 6
        case i6 = 7
        
        case j = 8
    }
    
    public mutating func set(register: RegisterLabel, indices: ClosedRange<Int>, to value: [UInt8]) {
        var startOffset = 0
        let indexOffset = indices.lowerBound
        
        if indices.lowerBound == 0 {
            if value[0] == 0 {
                mixState.register_signs &= ~(1 << register.rawValue)
            } else {
                mixState.register_signs |= 1 << register.rawValue
            }
            
            if indices.upperBound == 0 {
                return
            }
            
            startOffset = 1
        }
        
        for i in (indices.lowerBound + startOffset)...(indices.upperBound) {
            mixState.reg_ptrs[register.rawValue]![i - 1] = value[i - indexOffset]
        }
        
    }
    
    /**
     * If the sign field is nonzero, that represents a positive sign. Zero represents a negative sign.
     */
    public func get(register: RegisterLabel, indices: ClosedRange<Int>) -> [UInt8] {
        
        var value = [UInt8](repeating: 0, count: indices.upperBound - indices.lowerBound + 1)
        
        var startOffset = 0
        let indexOffset = indices.lowerBound
        
        if indices.lowerBound == 0 {
            value[0] = register == .j ? 1 : mixState.register_signs & (1 << register.rawValue)
            startOffset = 1
            
            if indices.upperBound == 0 {
                return value
            }
        }
        
        for i in (indices.lowerBound + startOffset)...(indices.upperBound) {
            value[i - indexOffset] = mixState.reg_ptrs[register.rawValue]![i - 1]
        }
        
        return value

    }
    
    public mutating func set(register: RegisterLabel, value: [UInt8]) {
        let registerSize = mix_register_size(Int32(register.rawValue))
        set(register: register, indices: 0...registerSize, to: value)
    }
    
    public func get(register: RegisterLabel) -> [UInt8] {
        let registerSize = mix_register_size(Int32(register.rawValue))
        return get(register: register, indices: 0...registerSize)
    }
    
    // MARK: - Memory Interface
    
//    /**
//     * A word in computer memory
//     */
//    class MIXWord {
//
//        /**
//         * `true` if this positive, `false` represents negative
//         */
//        public var isPositive: Bool
//
//        /**
//         * The bytes of the word
//         */
//        private var bytes: [UInt8]
//
//        public subscript(_ index: Int) -> UInt8 {
//            get {
//                if index == 0 {
//                    return isPositive ? 1 : 0
//                }
//
//                return bytes[index - 1]
//            }
//            set {
//                if index == 0 {
//                    isPositive = newValue != 0
//                    return
//                }
//
//                bytes[index - 1] = newValue
//            }
//        }
//
//    }
    
    public mutating func set(memoryAddress: Int, indices: ClosedRange<Int> = 0...5, value: [UInt8]) {
        memory_write(mixState.memory, Int32(memoryAddress), Int32(indices.lowerBound), Int32(indices.upperBound), value)
    }
    
    public func get(memoryAddress: Int, indices: ClosedRange<Int> = 0...5) -> [UInt8] {
        var buffer = [UInt8](repeating: 0, count: indices.upperBound - indices.lowerBound + 1)
        memory_read(mixState.memory, Int32(memoryAddress), Int32(indices.lowerBound), Int32(indices.upperBound), &buffer)
        return buffer
    }
    
    // MARK: - Other Property Interfaces
    
    /**
     * The overflow toggle value
     */
    public private(set) var overflow: Bool {
        get {
            mixState.ov_comp & 0xFE == 1
        }
        set {
            if newValue {
                mixState.ov_comp |= 1 << 7
            } else {
                mixState.ov_comp &= ~(1 << 7)
            }
        }
    }
    
    /**
     * Possible values of the comparison indicator
     */
    public enum ComparisonValue: UInt8 {
        case equal   = 0
        case less    = 1
        case greater = 2
    }
    
    /**
     * The value of the comparison indicator
     */
    public private(set) var comparisonIndicator: ComparisonValue {
        get {
            return ComparisonValue(rawValue: mixState.ov_comp % 3)!
        }
        set {
            // first clear out the bits
            mixState.ov_comp &= 0b11111100
            mixState.ov_comp |= newValue.rawValue
        }
    }
    
    // MARK: - Initializers
    
    /**
     * Creates an empty MIX state
     */
    public init() {
        mixState = initialize_empty()
    }
    
}
