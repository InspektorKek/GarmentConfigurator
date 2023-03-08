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
            Button {
                viewModel.send(.onNextScene)
            } label: {
                Text(L10n.titleGarments)
                    .frame(width: 250, height: 30)
            }
            .buttonStyle(
                GradientBackgroundStyle(
                    startColor: Color(Asset.Colors.Gradients.first.color),
                    endColor: Color(Asset.Colors.Gradients.second.color)
                )
            )
        }
    }
}
