import SwiftUI

struct ConfigurationView: View {
    @ObservedObject var viewModel: ConfigurationViewModel

    @State var camera = PerspectiveCamera()

    var body: some View {
        content
            .onAppear {
                viewModel.send(.onAppear)
            }
    }

    private var content: some View {
        ZStack {
            VStack {
                Model3DView(scene: viewModel.scene.scene)
                    .cameraControls(OrbitControls(camera: $camera,
                                                  sensitivity: 0.3,
                                                  minZoom: 1,
                                                  maxZoom: 3,
                                                  friction: 0))
                
                NavigationView {
                    VStack {
                        ForEach(viewModel.model.patterns, id: \.self) { pattern in
                            NavigationLink {
                                HStack(spacing: 10) {
                                    ForEach(viewModel.materials) { material in
                                        if let imageData = material.texture, let image = UIImage(data: imageData) {
                                            Button {
                                                viewModel.send(.apply(material: material, pattern: pattern))
                                            } label: {
                                                Image(uiImage: image)
                                                    .resizable()
                                                    .frame(width: 80, height: 80)
                                                    .scaledToFit()
                                            }
                                        }
                                    }
                                }
                            } label: {
                                HStack {
                                    Text(pattern.name)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
