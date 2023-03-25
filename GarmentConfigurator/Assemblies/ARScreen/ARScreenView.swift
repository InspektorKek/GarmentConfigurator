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

    var body: some View {
        ZStack(alignment: .bottom) {
            ARViewContainer(viewModel: viewModel)
                .edgesIgnoringSafeArea(.all)
            VStack {
                HStack {
                    closeButton
                    
                    Spacer()
                    
                    resetButton
                }
                
                if viewModel.isRecording {
                    timeLabel
                        .padding()
                }

                Spacer()

                Button(action: {
                }, label: {
                    ZStack {
                        Circle()
//                            .fill(Color.gray)
                            .fill(
                                RadialGradient(gradient: Gradient(colors: [.white, .black]), center: .center, startRadius: 0, endRadius: 50)
                                , strokeBorder: .white)
                            .opacity(viewModel.isRecording ? 0.4 : 1)
                            .frame(width: 80, height: 80)
                            .overlay {
                                RoundedRectangle(cornerRadius: 8)
                                    .frame(width: 24, height: 24)
                                    .foregroundColor(.white)
                                    .opacity(viewModel.isRecording ? 1 : 0)
                            }
                        Circle()
                            .trim(from: 0, to: viewModel.progressValue)
                            .stroke(viewModel.isRecording ? Color.red : Color.gray, lineWidth: 3)
                            .rotationEffect(.degrees(-90))
                            .frame(width: 77, height: 77)
                    }
                    .padding()
                    .scaleEffect(viewModel.isRecording ? 1.35 : 1)
                })
                .highPriorityGesture(
                    LongPressGesture(minimumDuration: 0.1)
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
    
    var closeButton: some View {
        HStack{
            Button {
                viewModel.send(.onNextScene)
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.white)
            }
            .frame(width: 60, height: 45)
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 15))
            
            Spacer()
        }
        .padding(.horizontal, 24)
        .padding(.top, 24)
    }
    
    var resetButton: some View {
        Button {
            viewModel.send(.onResetButtonTapped)
        } label: {
            Image(systemName: "arrow.triangle.2.circlepath")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(.white)
        }
        .frame(width: 45, height: 45)
        .padding(.horizontal, 24)
        .padding(.top, 24)
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
        let configuration = ARBodyTrackingConfiguration()
        configuration.automaticSkeletonScaleEstimationEnabled = true
        arView.session.run(configuration)

        viewModel.arView = arView
        arView.session.delegate = viewModel

        do {
            var material = SimpleMaterial()
            if let textureMaterial = viewModel.model.patterns[0].textureMaterial,
               let fileURL = FilesManager.makeURL(forFileNamed: textureMaterial.id.uuidString) {
                let texture = try TextureResource.load(contentsOf: fileURL)
                material.color = .init(tint: .white, texture: .init(texture))
            } else {
                material.color = .init(tint: .white)
            }
                
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

extension Shape {
    func fill<Fill: ShapeStyle, Stroke: ShapeStyle>(_ fillStyle: Fill, strokeBorder strokeStyle: Stroke, lineWidth: Double = 1) -> some View {
        self
            .stroke(strokeStyle, lineWidth: lineWidth)
            .background(self.fill(fillStyle))
    }
}

extension InsettableShape {
    func fill<Fill: ShapeStyle, Stroke: ShapeStyle>(_ fillStyle: Fill, strokeBorder strokeStyle: Stroke, lineWidth: Double = 1) -> some View {
        self
            .strokeBorder(strokeStyle, lineWidth: lineWidth)
            .background(self.fill(fillStyle))
    }
}
