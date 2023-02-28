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
    @State var isPressed: Bool = false
    @State private var showingSheet = false
    @State var mediaType: ARResultMediaType?
    @State var capturedImage: UIImage

//    @State private var image: UIImage?

    var body: some View {
        ZStack(alignment: .bottom) {
            ARViewContainer().edgesIgnoringSafeArea(.all)

            Button {
                    takePhoto()
            } label: {
                ZStack {
                    Circle()
                        .fill(Color.black)
                        .frame(width: 65, height: 65)

                    Circle()
                        .stroke(Color.black, lineWidth: 2)
                        .frame(width: 70, height: 70)
                }
            }
            .sheet(isPresented: $showingSheet) {
//                if capturedImage != nil {
                ARResultView(mediaType: self.mediaType!, image: self.$capturedImage)
//                }
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

extension ARScreenView {

    func takePhoto() {
        DispatchQueue.global().async {
            ARVariables.arView.takePhotoResult { (result: Result<UIImage, Swift.Error>) in
                switch result {
                case .success(let image):
                    DispatchQueue.main.async {
                        capturedImage = image
                        mediaType = .image(image)
                        showingSheet.toggle()
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}

public enum Capture {
    static let limitedTime: Double = 60.00
}
