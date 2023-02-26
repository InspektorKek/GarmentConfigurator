import SwiftUI

struct CameraScreenView: View {
    @ObservedObject var viewModel: CameraScreenViewModel

    var body: some View {
        content
            .onAppear {
                viewModel.send(.onAppear)
            }
    }

    private var content: some View {
        ZStack {
            
        }
    }
}
