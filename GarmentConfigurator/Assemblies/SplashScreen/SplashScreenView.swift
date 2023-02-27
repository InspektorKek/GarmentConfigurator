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
            VStack {
                Spacer()
                Button {
                    viewModel.send(.onNextScene)
                } label: {
                    Text(L10n.coreButtonContinue)
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
            .padding()
        }
    }
}
