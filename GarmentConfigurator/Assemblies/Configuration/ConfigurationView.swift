import SwiftUI

struct ConfigurationView: View {
    @ObservedObject var viewModel: ConfigurationViewModel
    
    @State var camera = PerspectiveCamera()
    
    @State private var scaleValue = 0.0
    @State private var rotationValue = 0.0
    
    let numberFormatter: NumberFormatter = {
        let num = NumberFormatter()
        num.maximumFractionDigits = 0
        return num
    }()

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
                    ScrollView {
                        patternNavigationLink()
                    }
                    .safeAreaInset(edge: .top) {
                        navigationHeader
                    }
                    .navigationBarHidden(true)
                    .background(Asset.Colors.baseNavigationColor.swiftUIColor)
                }
                .cornerRadius(20, corners: [.topLeft, .topRight])
                .edgesIgnoringSafeArea(.bottom)
            }
        }
    }
    
    private func patternNavigationLink() -> some View {
        VStack(spacing: 0) {
            ForEach(viewModel.model.patterns, id: \.self) { pattern in
                NavigationLink {
                    ScrollView {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 10) {
                                Button {
                                    #warning("Add own material")
                                } label: {
                                    Text("Add own image")
                                        .frame(width: 80, height: 80)
                                        .font(.system(size: 13))
                                        .overlay {
                                            RoundedRectangle(cornerRadius: 16)
                                                .stroke(style: StrokeStyle(lineWidth: 2, dash: [5]))
                                                .frame(width: 80, height: 80)
                                        }
                                        .foregroundColor(Asset.Colors.accentColor.swiftUIColor)
                                }
                                ForEach(viewModel.materials) { material in
                                    if let imageData = material.texture, let image = UIImage(data: imageData) {
                                        if let textureMaterial = pattern.textureMaterial {
                                            PatternButton(image: Image(uiImage: image),
                                                          isSelected: textureMaterial == material) {
                                                viewModel.send(.apply(material: material, pattern: pattern))
                                            }
                                        } else {
                                            PatternButton(image: Image(uiImage: image),
                                                          isSelected: false) {
                                                viewModel.send(.apply(material: material, pattern: pattern))
                                            }
                                        }
                                    }
                                }
                            }
                            .padding(.top, 20)
                            .padding(.horizontal, 20)
                        }
                        
                        VStack(spacing: 20) {
                            VStack {
                                Slider(value: $scaleValue, in: 0...100)
                                .foregroundColor(Asset.Colors.accentColor.swiftUIColor)
                                .tint(Asset.Colors.baseWhite.swiftUIColor)
                                
                                Text("Scale: \(numberFormatter.string(from: NSNumber(value: scaleValue))!)%")
                            }
                            
                            VStack {
                                Slider(value: $rotationValue, in: 0...360)
                                .foregroundColor(Asset.Colors.accentColor.swiftUIColor)
                                .tint(Asset.Colors.baseWhite.swiftUIColor)
                                
                                Text("Rotation: \(numberFormatter.string(from: NSNumber(value: rotationValue))!)°")
                            }
                        }
                        .padding(20)
                    }
                    .safeAreaInset(edge: .top) {
                        VStack {
                            Rectangle()
                                .frame(height: 1)
                                .foregroundColor(Asset.Colors.secondary.swiftUIColor)
                        }
                        .background(Asset.Colors.baseNavigationColor.swiftUIColor)
                    }
                    .navigationTitle(pattern.name)
                    .background(Asset.Colors.baseNavigationColor.swiftUIColor)
                } label: {
                    patternView(pattern)
                }
            }
        }
        .cornerRadius(16)
        .padding(.horizontal, 20)
        .padding(.top, 20)
        .background(Asset.Colors.baseNavigationColor.swiftUIColor)
    }
    
    private func patternView(_ pattern: TShirtPatternInfo) -> some View {
        HStack {
            Text(pattern.name)
                .font(.system(size: 17))
            Spacer()
            
            if let imageData = pattern.textureMaterial?.texture, let image = UIImage(data: imageData) {
                Image(uiImage: image)
                    .resizable()
                    .frame(width: 36, height: 36)
                    .cornerRadius(12)
            } else {
                Asset.Images.iconEmptyTexture.swiftUIImage
            }
            
            Image(systemName: "chevron.right")
                .padding(.leading, 16)
        }
        .padding(.horizontal, 20)
        .foregroundColor(Asset.Colors.labelsPrimary.swiftUIColor)
        .frame(height: 60)
        .background(Asset.Colors.secondary.swiftUIColor)
    }
    
    private var navigationHeader: some View {
        VStack {
            HStack {
                Spacer()
                VStack(alignment: .center) {
                    Capsule()
                        .frame(width: 34, height: 6)
                        .foregroundColor(Asset.Colors.labelsPrimary.swiftUIColor)
                    Text("Patterns")
                        .font(.system(size: 25, weight: .medium))
                        .foregroundColor(Asset.Colors.baseWhite.swiftUIColor)
                }
                Spacer()
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
            
            Rectangle()
                .frame(height: 1)
                .foregroundColor(Asset.Colors.secondary.swiftUIColor)
        }
        .background(Asset.Colors.baseNavigationColor.swiftUIColor)
    }
}

struct ConfigurationView_Previews: PreviewProvider {
    static var previews: some View {
        ConfigurationView(viewModel: ConfigurationViewModel(model: GarmentModel(type: .tShirt, name: "Name", bodyType: .male)))
    }
}

struct PatternButton: View {
    @State var image: Image
    @State var isSelected: Bool
    
    var tappedAction: (() -> Void)

    var body: some View {
        Button {
            tappedAction()
        } label: {
            image
                .resizable()
                .scaledToFit()
                .frame(width: 74, height: 74)
        }
        .cornerRadius(12)
        .overlay(
            isSelected ?
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.white, lineWidth: 2)
                .frame(width: 80, height: 80)
            : nil
        )
        .frame(width: 82, height: 82)
    }
}
