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

import SCNRecorder

struct ARScreenView: View {
    @ObservedObject var viewModel: ARScreenViewModel

    @State private var showingSheet = false

    var body: some View {
        ZStack(alignment: .bottom) {
            ARViewContainer()
                .edgesIgnoringSafeArea(.all)

            Button(action: {
                if viewModel.isRecording {
                    viewModel.stopCapturingVideo()
                    viewModel.isRecording.toggle()
                    showingSheet.toggle()
                }
            }, label: {
                ZStack {
                    Circle()
                        .fill(viewModel.isRecording ? Color.red : Color.white)
                        .frame(width: 65, height: 65)

                    Circle()
                        .stroke(Color.white, lineWidth: 2)
                        .frame(width: 70, height: 70)
                }
            })
            .simultaneousGesture(LongPressGesture(minimumDuration: 0.2)
                .onEnded {_ in
                    viewModel.isRecording.toggle()
                    viewModel.startCapturingVideo()
            })
            .simultaneousGesture(TapGesture().onEnded {
                viewModel.takePhoto()
                showingSheet.toggle()
            })
            .fullScreenCover(isPresented: $viewModel.shouldShowResult) {
                if let mediaType = viewModel.mediaType {
                    ARResultView(viewModel: ARResultViewModel(mediaType: mediaType))
                }
            }
        }
        .onAppear {
            ARVariables.arView.prepareForRecording()
        }
    }
}

struct ARVariables {
    static var arView: ARView!
}

struct ARViewContainer: UIViewRepresentable {

    func makeUIView(context: Context) -> ARView {
        ARVariables.arView = ARView(frame: .zero)
        // Load the "Box" scene from the "Experience" Reality File
        do {
            let boxAnchor = try Experience.loadBox()

            // Add the box anchor to the scene
            ARVariables.arView.scene.anchors.append(boxAnchor)
        } catch {
            print("cant create boxanchor")
        }
        return ARVariables.arView
    }

    func updateUIView(_ uiView: ARView, context: Context) {}
}
