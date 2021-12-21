//
//  mix_unit_tests.swift
//  mix_unit_tests
//
//  Created by Sylvan Martin on 12/20/21.
//

import XCTest
import mix

class mix_unit_tests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testRegisters() throws {
        
        func getRegisterSize(for register: MIX.RegisterLabel) -> Int {
            // This isn't a very safe way of doing things considering that good coding
            // practice would have me make more loosely coupled code, but I'm not going to be changing MIX
            // architecture anytime soon
            if register.rawValue <= MIX.RegisterLabel.x.rawValue {
                return Int(MIX_REGISTER_A_SIZE)
            } else {
                return Int(MIX_REGISTER_I_SIZE)
            }
        }
        
        var comp = MIX()
        
        // do some random test cases on each register
        
        let testCaseCount = 10000
        
        for register in MIX.RegisterLabel.allCases {
            for _ in 1...testCaseCount {
                
                let registerSize = getRegisterSize(for: register)
                
                let lowerBound = Int.random(in: 0...registerSize)
                let upperBound = Int.random(in: lowerBound...registerSize)
                
                let range = lowerBound...upperBound
                
                let newBytes = [UInt8](repeating: 0, count: range.count).map { _ in UInt8.random(in: 0...UInt8.max) }
                
                comp.set(register: .a, indices: range, to: newBytes)
                
                // We are only testing the public interface, so we just need to make sure
                // that works, not the state itself
                
                let readBytes = comp.get(register: .a, indices: range)
                
                var startIndex = 0
                
                if lowerBound == 0 {
                    XCTAssertEqual(newBytes[0] == 0, readBytes[0] == 0)
                    startIndex = 1
                }
                
                // If we have nothing left to test than exist the test before
                // we create an invalid range
                if startIndex > upperBound { continue }
                
                if newBytes[startIndex..<newBytes.count] != readBytes[startIndex..<readBytes.count] {
                    print("Writing \(newBytes) to register \(register) for indices \(range)")
                    print("Result from read was: \(readBytes)")
                    print("State:")
                    print(comp.debugDescription)
                    XCTFail()
                }
                
            }
        }
        
    }
    
    func testMemory() throws {
        
        var comp = MIX()
        
        let testCaseCount = 500000
        
        for _ in 1...testCaseCount {
            
            let memoryAddress = Int.random(in: 0..<Int(MIX_MEMORY_SIZE))
            
            let lowerBound = Int.random(in: 0..<Int(MIX_WORD_SIZE))
            let upperBound = Int.random(in: lowerBound..<Int(MIX_WORD_SIZE))
            
            let range = lowerBound...upperBound
            
            let newBytes = [UInt8](repeating: 0, count: range.count).map { _ in UInt8.random(in: 0...UInt8.max) }
            
            comp.set(memoryAddress: memoryAddress, indices: range, value: newBytes)
            
            let readBytes = comp.get(memoryAddress: memoryAddress, indices: range)
            
            XCTAssertEqual(newBytes, readBytes)
            
        }
        
    }
    

    func testExample() throws {
        
    }

    func testLaunchPerformance() throws {
        
    }
}
