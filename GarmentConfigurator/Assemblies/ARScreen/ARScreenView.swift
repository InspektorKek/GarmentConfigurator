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

    @State private var showеingSheet = false

    var body: some View {
        ZStack(alignment: .bottom) {
            ARViewContainer(viewModel: viewModel)
                .edgesIgnoringSafeArea(.all)
            VStack {
                if viewModel.isRecording {
                    timeLabel
                        .padding()
                }

                Spacer()

                Button(action: {
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
                .fullScreenCover(isPresented: $viewModel.shouldShowResult) {
                    if let mediaType = viewModel.mediaType {
                        ARResultView(viewModel: ARResultViewModel(mediaType: mediaType))
                    }
                }

            }
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

struct ARViewContainer: UIViewRepresentable {
    @ObservedObject var viewModel: ARScreenViewModel

    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        arView.session.run(ARBodyTrackingConfiguration())

        viewModel.arView = arView
        arView.session.delegate = viewModel

        do {
            var material = SimpleMaterial()
            material.color = try .init(tint: .white, texture: .init(.load(named: "img", in: nil)))
            material.metallic = .init(floatLiteral: 1.0)
            material.roughness = .init(floatLiteral: 0.5)

            viewModel.loadCharacter(material: material)
        } catch {
            fatalError(error.localizedDescription)
        }

        return arView
    }

    func updateUIView(_ uiView: ARView, context: Context) {
    }
}
