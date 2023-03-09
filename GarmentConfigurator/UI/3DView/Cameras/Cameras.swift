//
//  Cameras.swift
//  GarmentConfigurator
//
//  Created by Mikhail Borisov on 28/02/23.
//

import SwiftUI
import simd

// MARK: - Camera protocol
/// Protocol for `Model3DView` cameras.
protocol Camera {
    var position: Vector3 { get set }
    var rotation: Euler { get set }
    func projectionMatrix(viewport: CGSize) -> Matrix4x4
}

extension Camera {
    /// Adjust the camera to orient towards `center`.
    mutating func lookAt(center: Vector3, up: Vector3 = [0, 1, 0]) {
        let m = Matrix4x4.lookAt(eye: position, target: center, up: up)
        let mat3 = Matrix3x3(
            [m.columns.0.x, m.columns.0.y, m.columns.0.z],
            [m.columns.1.x, m.columns.1.y, m.columns.1.z],
            [m.columns.2.x, m.columns.2.y, m.columns.2.z]
        )
        rotation = Euler(Quaternion(mat3))
    }

    /// Return a copy of the camera oriented towards `center`.
    func lookingAt(center: Vector3, up: Vector3 = [0, 1, 0]) -> Self {
        var copy = self
        copy.lookAt(center: center, up: up)
        return copy
    }
}

// MARK: - Camera view modifier
/// An animatable modifier that helps animate properties of a `Camera`.
private struct CameraModifier<C: Camera>: AnimatableModifier {
    var camera: C

    var animatableData: AnimatablePair<Vector3, Euler> {
        get {
            .init(camera.position, camera.rotation)
        }
        set {
            camera.position = newValue.first
            camera.rotation = newValue.second
        }
    }

    func body(content: Content) -> some View {
        content.environment(\.camera, camera)
    }
}

extension View {
    /// Sets the default camera.
    func camera<C: Camera>(_ camera: C) -> some View {
        modifier(CameraModifier(camera: camera))
    }
}

// MARK: - Camera types
/// Camera with orthographic projection.
struct OrthographicCamera: Camera, Equatable {
    var position: Vector3
    var rotation: Euler
    var near: Float
    var far: Float
    var scale: Float

    init(
        position: Vector3 = [0, 0, 2],
        rotation: Euler = Euler(),
        near: Float = 0.1,
        far: Float = 100,
        scale: Float = 1
    ) {
        self.position = position
        self.rotation = rotation
        self.near = near
        self.far = far
        self.scale = scale
    }

    func projectionMatrix(viewport size: CGSize) -> Matrix4x4 {
        let aspect = Float(size.width / size.height) * scale
        return .orthographic(left: -aspect, right: aspect, bottom: -scale, top: scale, near: near, far: far)
    }
}

/// Camera with perspective projection.
struct PerspectiveCamera: Camera, Equatable {
    var position: Vector3
    var rotation: Euler
    var fov: Angle
    var near: Float
    var far: Float

    init(
        position: Vector3 = [0, 0, 2],
        rotation: Euler = Euler(),
        fov: Angle = .degrees(60),
        near: Float = 0.1,
        far: Float = 100
    ) {
        self.position = position
        self.rotation = rotation
        self.fov = fov
        self.near = near
        self.far = far
    }

    func projectionMatrix(viewport size: CGSize) -> Matrix4x4 {
        let aspect = Float(size.width / size.height)
        return .perspective(fov: Float(fov.radians), aspect: aspect, near: near, far: far)
    }
}
