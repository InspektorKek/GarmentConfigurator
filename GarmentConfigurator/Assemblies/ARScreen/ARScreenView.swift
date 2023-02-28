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
    @StateObject var viewModel = ARScreenViewModel()
    @State private var showingSheet = false

    var body: some View {
        ZStack(alignment: .bottom) {
            ARViewContainer().edgesIgnoringSafeArea(.all)

            HStack {
                Button {
                    viewModel.takePhoto()
                    showingSheet.toggle()
                } label: {
                    ZStack {
                        Circle()
                            .fill(Color.white)
                            .frame(width: 65, height: 65)

                        Circle()
                            .stroke(Color.white, lineWidth: 2)
                            .frame(width: 70, height: 70)
                    }
                }

                Button {
                    if !viewModel.isPressed {
                        viewModel.startCapturingVideo()
                    } else {
                        viewModel.stopCapturingVideo()
                        showingSheet.toggle()
                    }
                } label: {
                    ZStack {
                        Circle()
                            .fill(Color.red)
                            .frame(width: 65, height: 65)

                        Circle()
                            .stroke(Color.blue, lineWidth: 2)
                            .frame(width: 70, height: 70)
                    }
                }

            }
            .sheet(isPresented: $showingSheet) {
                ARResultScreen().environmentObject(viewModel)
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
