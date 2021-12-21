//
//  MIX+Instructions.swift
//  mix
//
//  Created by Sylvan Martin on 12/21/21.
//

import Foundation

extension MIX {
    
    // MARK: - Instructions
    
    struct MIXInstruction {
        
        /**
         * The actual word representation of this instruction
         */
        var word: [UInt8]
        
        /**
         * The address for the instruction
         */
        var address: Int {
            get {
                let aa = word[1...2].withUnsafeBytes { pointer in
                    pointer.bindMemory(to: UInt16.self).baseAddress!.pointee
                }
                
                var address = Int(aa)
                
                if word[0] == 0 {
                    address = -address
                }
                
                return address
            }
            set {
                
            }
        }
        
        /**
         * The index specification, `I`
         */
        var indexSpecification: UInt8 {
            get {
                word[3]
            }
            set {
                word[3] = newValue
            }
        }
        
        /**
         * The operation code, `C`
         */
        var operationCode: UInt8 {
            get {
                word[5]
            }
            set {
                word[5] = newValue
            }
        }
        
        /**
         * The modification parameter
         */
        var modification: UInt8 {
            get {
                word[4]
            }
            set {
                word[4] = newValue
            }
        }
        
        /**
         * Creates a `MIXInstruction` from a MIX word
         */
        init(word: [UInt8]) {
            self.word = word
        }
        
    }
    
    mutating func execute(instruction: MIXInstruction) {
        
    }
    
}
