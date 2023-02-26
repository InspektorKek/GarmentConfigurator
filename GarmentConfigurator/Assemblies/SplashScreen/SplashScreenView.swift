import SwiftUI

struct SplashScreenView: View {
    @ObservedObject var viewModel: SplashScreenViewModel

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
