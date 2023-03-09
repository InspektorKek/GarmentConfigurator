import SwiftUI

struct GarmentsView: View {
    @ObservedObject var viewModel: GarmentsViewModel

    var body: some View {
        content
            .onAppear {
                viewModel.send(.onAppear)
            }
    }

    private var content: some View {
        ZStack {
            EmptyView()
        }
    }
}
