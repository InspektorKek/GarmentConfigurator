//
//  ContentView.swift
//  ARTestCapture
//
//  Created by Aleksandr Shapovalov on 27/02/23.
//

import SwiftUI
import RealityKit
import AVKit
import ARKit
import Combine

import SCNRecorder

struct ARScreenView: View {
    @ObservedObject var viewModel: ARScreenViewModel

    @State private var showingSheet = false

    var body: some View {
        ZStack(alignment: .bottom) {
            ARViewContainer(viewModel: ARScreenViewModel())
                .edgesIgnoringSafeArea(.all)
            VStack {
                if viewModel.isRecording {
                    timeLabel
                        .padding()
                }

                Spacer()

                Button(action: {
//                    viewModel.send(.onNextScene)
                }, label: {
                    ZStack {
                            Circle()
                                .fill(Color.gray)
                                .opacity(viewModel.isRecording ? 0.4 : 1)
                                .frame(width: 70, height: 70)
                                .overlay {
                                    RoundedRectangle(cornerRadius: 8)
                                        .frame(width: 24, height: 24)
                                        .opacity(viewModel.isRecording ? 1 : 0)
                                }
                        Circle()
                            .trim(from: 0, to: viewModel.progressValue )
                            .stroke(viewModel.isRecording ? Color.red : Color.gray, lineWidth: 5)
                            .frame(width: 65, height: 65)
                    }
                    .padding()
                    .scaleEffect(viewModel.isRecording ? 1.35 : 1)
                })
                .highPriorityGesture(
                    LongPressGesture(minimumDuration: 0.25)
                        .onEnded { _ in
                            viewModel.startCapturingVideo()
                        }
                )
                        .simultaneousGesture(
                    TapGesture()
                        .onEnded {
                            if viewModel.isRecording {
                                viewModel.stopCapturingVideo()
                            } else {
                                viewModel.takePhoto()
                            }
                        }
                )
                //            .simultaneousGesture(LongPressGesture(minimumDuration: 0.1, maximumDistance: 100)
                //                .onEnded { isPressing in
                //                    if isPressing {
                //                        viewModel.isRecording = true
                //                        viewModel.startCapturingVideo()
                //                    } else {
                //                        viewModel.isRecording = false
                //                        viewModel.stopCapturingVideo()
                //                    }
                //            })
                //            .simultaneousGesture(TapGesture().onEnded {
                //                viewModel.takePhoto()
                //                showingSheet.toggle()
                //            })
                .fullScreenCover(isPresented: $viewModel.shouldShowResult) {
                    if let mediaType = viewModel.mediaType {
                        ARResultView(viewModel: ARResultViewModel(mediaType: mediaType))
                    }
                }

            }
        }
        .onAppear {
            viewModel.arView?.prepareForRecording()
        }
    }

    private var timeLabel: some View {
        Label(viewModel.labelText, systemImage: "heart")
            .padding(5)
            .background {
                Rectangle()
                    .foregroundColor(Color.red)
            }
            .labelStyle(.titleOnly)
    }

}

// struct ARVariables {
//    static var arView: ARView!
// }

// struct ARViewContainer: UIViewRepresentable {
//
//    func makeUIView(context: Context) -> ARView {
//        ARVariables.arView = ARView(frame: .zero)
//        // Load the "Box" scene from the "Experience" Reality File
//        do {
//            let boxAnchor = try Experience.loadBox()
//
//            // Add the box anchor to the scene
//            ARVariables.arView.scene.anchors.append(boxAnchor)
//        } catch {
//            print("cant create boxanchor")
//        }
//        return ARVariables.arView
//    }
//
//    func updateUIView(_ uiView: ARView, context: Context) {}
// }

// struct ARViewContainer: UIViewRepresentable {
//    @ObservedObject var viewModel: ARScreenViewModel
//    let arView = ARView(frame: .zero)
//
//    func makeUIView(context: Context) -> ARView {
//        arView.session.delegate = context.coordinator
//        arView.session.run(ARBodyTrackingConfiguration())
//        return arView
//    }
//
//    func updateUIView(_ uiView: ARView, context: Context) {
//    }
//
//    func makeCoordinator() -> Coordinator {
//        return Coordinator(parent: self)
//    }
//
//    class Coordinator: NSObject, ARSessionDelegate {
//
//        var parent: ARViewContainer
//
//        // The 3D character to display.
//        var character: BodyTrackedEntity?
//        let characterOffset: SIMD3<Float> = [0, 0, 0] // Offset the character by one meter to the left
//        let characterAnchor = AnchorEntity()
//
//        init(parent: ARViewContainer) {
//            self.parent = parent
//            super.init()
//
//            var material = SimpleMaterial()
//            // swiftlint:disable all
//            if #available(iOS 15.0, *) {
//                material.color = try! .init(tint: .white,
//                                            texture: .init(.load(named: "img", in: nil)))
//                // material.color = try! .init(tint: .white,texture: .init(.load(contentsOf:url, withName:nil)))
//                material.metallic = .init(floatLiteral: 1.0)
//                material.roughness = .init(floatLiteral: 0.5)
//            } else {
//                // Fallback on earlier versions
//            }
//            // swiftlint:enable all
//            parent.arView.scene.addAnchor(characterAnchor)
//            // Asynchronously load the 3D character.
//            var cancellable: AnyCancellable?
//            cancellable = Entity.loadBodyTrackedAsync(named: "untitled2").sink(
//                receiveCompletion: { completion in
//                    if case let .failure(error) = completion {
//                        print("Error: Unable to load model: \(error.localizedDescription)")
//                    }
//                    cancellable?.cancel()
//                }, receiveValue: { (character: Entity) in
//                    if let character = character as? BodyTrackedEntity {
//                        // Scale the character to human size
//                        character.model?.materials[0] = material
//                        // character.model?.materials[1] = material
//                        character.scale = [0.01, 0.01, 0.01]
//                        self.character = character
//                        cancellable?.cancel()
//                    } else {
//                        print("Error: Unable to load model as BodyTrackedEntity")
//                    }
//                })
//        }
//        func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
//            for anchor in anchors {
//                guard let bodyAnchor = anchor as? ARBodyAnchor else { continue }
//
//                // Update the position of the character anchor's position.
//                let bodyPosition = simd_make_float3(bodyAnchor.transform.columns.3)
//                characterAnchor.position = bodyPosition + characterOffset
//                // Also copy over the rotation of the body anchor, because the skeleton's pose
//                // in the world is relative to the body anchor's rotation.
//                characterAnchor.orientation = Transform(matrix: bodyAnchor.transform).rotation
//
//                if let character = character, character.parent == nil {
//                    // Attach the character to its anchor as soon as
//                    // 1. the body anchor was detected and
//                    // 2. the character was loaded.
//                    characterAnchor.addChild(character)
//                }
//            }
//        }
//    }
// }

struct ARViewContainer: UIViewRepresentable {
    @ObservedObject var viewModel: ARScreenViewModel

    func makeUIView(context: Context) -> ARView {
            let arView = ARView(frame: .zero)
            viewModel.arView = arView
            arView.session.delegate = viewModel
            arView.session.run(ARBodyTrackingConfiguration())
            // swiftlint:disable all
            var material = SimpleMaterial()
            if #available(iOS 15.0, *) {
                material.color = try! .init(tint: .white, texture: .init(.load(named: "img", in: nil)))
                material.metallic = .init(floatLiteral: 1.0)
                material.roughness = .init(floatLiteral: 0.5)
            } else {
                // Fallback on earlier versions
            }

            viewModel.loadCharacter(material: material)

            return arView
    }

    func updateUIView(_ uiView: ARView, context: Context) {
    }
}
