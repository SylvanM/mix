//
//  InputDevice.swift
//  mix
//
//  Created by Sylvan Martin on 12/19/21.
//

import Foundation

/**
 * A device used to input words to a `MIX` computer
 */
protocol WordInputDevice {
    
    /**
     * This function is called by the `MIX` computer to read the next word of input
     */
    func nextWord() -> [UInt8]
    
    /**
     * 
     */
    
}
