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
                    .foregroundColor(Color(Asset.Colors.baseWhite.color))
                    .padding()
                    .frame(maxWidth: .infinity)
                    .font(.system(size: 16, weight: .bold))
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(height: 50)
            }
            .buttonStyle(
                GradientBackgroundStyle(
                    startColor: Color(Asset.Colors.Gradients.first.color),
                    endColor: Color(Asset.Colors.Gradients.second.color)
                )
            )
            .clipShape(Capsule())
        }
    }
}
