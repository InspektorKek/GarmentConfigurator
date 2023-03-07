//
//  Euler.swift
//  GarmentConfigurator
//
//  Created by Mikhail Borisov on 28/02/23.
//

import SwiftUI

/// Rotation vector where all elements are of type `Angle`.
///
/// The vector represents Euler angles.
/// - Note: Any arithmetic calculations are based on radians.
struct Euler: Equatable {
    var x: Angle
    var y: Angle
    var z: Angle

    init(x: Angle = .radians(0), y: Angle = .radians(0), z: Angle = .radians(0)) {
        self.x = x
        self.y = y
        self.z = z
    }

    // https://en.wikipedia.org/wiki/Conversion_between_quaternions_and_Euler_angles#Source_code_2
    /// Initialize with a rotation quaternion.
    init(_ quat: Quaternion) {
        let sinr_cosp = 2 * (quat.real * quat.imag.x + quat.imag.y * quat.imag.z)
        let cosr_cosp = 1 - 2 * (quat.imag.x * quat.imag.x + quat.imag.y * quat.imag.y)
        let x = atan2(sinr_cosp, cosr_cosp)

        let sinp = 2 * (quat.real * quat.imag.y - quat.imag.z * quat.imag.x)
        let y = abs(sinp) >= 1 ? copysign(.pi / 2, sinp) : asin(sinp)

        let siny_cosp = 2 * (quat.real * quat.imag.z + quat.imag.x * quat.imag.y)
        let cosy_cosp = 1 - 2 * (quat.imag.y * quat.imag.y + quat.imag.z * quat.imag.z)
        let z = atan2(siny_cosp, cosy_cosp)

        self.init(x: .radians(Double(x)), y: .radians(Double(y)), z: .radians(Double(z)))
    }
}

extension Euler: CustomStringConvertible {
    var description: String {
        "Euler(\(x), \(y), \(z))"
    }
}

// MARK: - Vector arithemtic conformance.
extension Euler: VectorArithmetic {
    static func - (lhs: Euler, rhs: Euler) -> Euler {
        Euler(
            x: .radians(lhs.x.radians - rhs.x.radians),
            y: .radians(lhs.y.radians - rhs.y.radians),
            z: .radians(lhs.z.radians - rhs.z.radians)
        )
    }

    static func + (lhs: Euler, rhs: Euler) -> Euler {
        Euler(
            x: .radians(lhs.x.radians + rhs.x.radians),
            y: .radians(lhs.y.radians + rhs.y.radians),
            z: .radians(lhs.z.radians + rhs.z.radians)
        )
    }

    mutating func scale(by rhs: Double) {
        x = .radians(x.radians * rhs)
        y = .radians(y.radians * rhs)
        z = .radians(z.radians * rhs)
    }

    var magnitudeSquared: Double {
        x.radians * x.radians + y.radians * y.radians + z.radians * z.radians
    }

    static var zero: Euler {
        Euler(x: .radians(0), y: .radians(0), z: .radians(0))
    }
}
