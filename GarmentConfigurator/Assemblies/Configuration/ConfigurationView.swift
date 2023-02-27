import SwiftUI

struct ConfigurationView: View {
    @ObservedObject var viewModel: ConfigurationViewModel

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
