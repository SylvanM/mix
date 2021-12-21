//
//  MIX+Description.swift
//  mix
//
//  Created by Sylvan Martin on 12/20/21.
//

import Foundation

extension MIX: CustomDebugStringConvertible {

    // MARK: String Description

    /**
     * The string representation of the state of the mix computer for use in debugging
     */
    public var debugDescription: String {
        var stringDescription = "------------ MIX COMPUTER STATE ------------\n"

        stringDescription.append("Registers:\n")

        stringDescription.append("A\t")
        var r = get(register: .a, indices: 0...5)
        stringDescription.append(r[0] == 0 ? "-" : "+")
        stringDescription.append(String(format: " %02X %02X %02X %02X %02X\n", r[1], r[2], r[3], r[4], r[5]))

        stringDescription.append("X\t")
        r = get(register: .x, indices: 0...5)
        stringDescription.append(r[0] == 0 ? "-" : "+")
        stringDescription.append(String(format: " %02X %02X %02X %02X %02X\n", r[1], r[2], r[3], r[4], r[5]))

        stringDescription.append("I1\t")
        r = get(register: .i1, indices: 0...2)
        stringDescription.append(r[0] == 0 ? "-" : "+")
        stringDescription.append(String(format: " %02X %02X\n", r[1], r[2]))

        stringDescription.append("I2\t")
        r = get(register: .i2, indices: 0...2)
        stringDescription.append(r[0] == 0 ? "-" : "+")
        stringDescription.append(String(format: " %02X %02X\n", r[1], r[2]))

        stringDescription.append("I3\t")
        r = get(register: .i3, indices: 0...2)
        stringDescription.append(r[0] == 0 ? "-" : "+")
        stringDescription.append(String(format: " %02X %02X\n", r[1], r[2]))

        stringDescription.append("I4\t")
        r = get(register: .i4, indices: 0...2)
        stringDescription.append(r[0] == 0 ? "-" : "+")
        stringDescription.append(String(format: " %02X %02X\n", r[1], r[2]))

        stringDescription.append("I5\t")
        r = get(register: .i5, indices: 0...2)
        stringDescription.append(r[0] == 0 ? "-" : "+")
        stringDescription.append(String(format: " %02X %02X\n", r[1], r[2]))

        stringDescription.append("I6\t")
        r = get(register: .i6, indices: 0...2)
        stringDescription.append(r[0] == 0 ? "-" : "+")
        stringDescription.append(String(format: " %02X %02X\n", r[1], r[2]))

        stringDescription.append("J\t")
        r = get(register: .j, indices: 1...2)
        stringDescription.append("+")
        stringDescription.append(String(format: " %02X %02X\n", r[0], r[1]))

        stringDescription.append("\n")

        stringDescription.append("Indicators:\n")
        stringDescription.append(String(format: "OVF\t%s\n", overflow ? "true" : "false"))
        stringDescription.append("CMP\t")

        switch comparisonIndicator {
            case .equal:
            stringDescription.append("EQUAL\n")
            case .less:
            stringDescription.append("LESS\n")
            case .greater:
            stringDescription.append("GREATER\n")
        }

        stringDescription.append("--------------------------------------------\n")

        return stringDescription
    }

}
