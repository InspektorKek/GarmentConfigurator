import SwiftUI
import SceneKit

struct GarmentsView: View {
    @ObservedObject var viewModel: GarmentsViewModel
    
    private let garmentLayout = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        content
            .onAppear {
                viewModel.send(.onAppear)
            }
    }

    private var content: some View {
        ScrollView {
            LazyVGrid(columns: garmentLayout, spacing: 16) {
                ForEach(viewModel.garments, id: \.self) { garment in
                    ZStack {
                        VStack(spacing: 10) {
                            Model3DView(scene: PatternedScene(scene: SCNScene(named: garment.sceneName)!).scene)
                                .transform(rotate: Euler(y: .degrees(180)))
                                .frame(height: 160)
                                .camera(PerspectiveCamera(fov: .degrees(60)))
                            
                            VStack {
                                Text(garment.name)
                                    .font(.system(size: 17))
                                Text(garment.bodyType.name)
                                    .foregroundColor(Asset.Colors.labelsPrimary.swiftUIColor)
                                    .font(.system(size: 13))
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                        }
                    }
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(.white, lineWidth: 1)
                    )
                    .onTapGesture {
                        viewModel.send(.onTap(model: garment))
                    }
                }
            }
            .listRowSeparator(.hidden)
            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
        }
        .padding(.all, 16)
    }
}
