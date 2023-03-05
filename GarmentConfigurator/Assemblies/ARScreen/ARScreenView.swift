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
//                .simultaneousGesture
                .highPriorityGesture(
                    LongPressGesture(minimumDuration: 0.25)
                    // .onChanged { _ in
                        .onEnded { _ in
                            //                        if isPressing {
                            viewModel.startCapturingVideo()
                            //                        }
                        }
                )
//                .highPriorityGesture(
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
            ARVariables.arView.prepareForRecording()
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
