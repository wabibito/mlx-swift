// Copyright © 2026 Apple Inc.

import Foundation

/// A complex number, stored as its real and imaginary parts.
///
/// This exists so MLX can express `DType/complex64` values without depending on `swift-numerics`.
/// MLX used exactly three things from that package — the `Complex<Float>` type, `.real` and
/// `.imaginary` — while the dependency itself pulled a substantial transitive graph into every app
/// that links MLX. This is an independent implementation of that small surface, not derived code.
///
/// ## Memory layout
///
/// This type is `@frozen` and stores exactly two `RealType` values, real first. That layout is load
/// bearing: ``MLXArray/item(_:)`` reinterprets the buffer returned by `mlx_array_data_complex64` —
/// C's `float _Complex`, i.e. two contiguous `Float32` — directly as `Complex<Float32>`. Adding,
/// reordering, or boxing a stored property here would silently corrupt every complex read. Do not
/// give this type stored properties beyond these two.
@frozen
public struct Complex<RealType: FloatingPoint> {
    /// The real part.
    public var real: RealType
    /// The imaginary part.
    public var imaginary: RealType

    /// Create a complex number from its real and imaginary parts.
    @_transparent
    public init(_ real: RealType, _ imaginary: RealType) {
        self.real = real
        self.imaginary = imaginary
    }

    /// Create a complex number from a real value, with a zero imaginary part.
    @_transparent
    public init(_ real: RealType) {
        self.init(real, 0)
    }

    /// The additive identity, `0 + 0i`.
    @_transparent
    public static var zero: Complex { Complex(0, 0) }

    /// The imaginary unit, `0 + 1i`.
    @_transparent
    public static var i: Complex { Complex(0, 1) }
}

extension Complex: Equatable {
    @_transparent
    public static func == (a: Complex, b: Complex) -> Bool {
        a.real == b.real && a.imaginary == b.imaginary
    }
}

extension Complex: Hashable where RealType: Hashable {}

extension Complex: Sendable where RealType: Sendable {}

extension Complex: CustomStringConvertible {
    public var description: String {
        // Match the conventional "a + bi" rendering, folding a negative imaginary part into "a - bi".
        imaginary < 0
            ? "\(real) - \(-imaginary)i"
            : "\(real) + \(imaginary)i"
    }
}

extension Complex: AdditiveArithmetic {
    @_transparent
    public static func + (a: Complex, b: Complex) -> Complex {
        Complex(a.real + b.real, a.imaginary + b.imaginary)
    }

    @_transparent
    public static func - (a: Complex, b: Complex) -> Complex {
        Complex(a.real - b.real, a.imaginary - b.imaginary)
    }
}

extension Complex {
    /// The product `(ac - bd) + (ad + bc)i`.
    @_transparent
    public static func * (a: Complex, b: Complex) -> Complex {
        Complex(
            a.real * b.real - a.imaginary * b.imaginary,
            a.real * b.imaginary + a.imaginary * b.real)
    }

    /// The complex conjugate, `a - bi`.
    @_transparent
    public var conjugate: Complex { Complex(real, -imaginary) }
}
