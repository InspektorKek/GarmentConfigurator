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
        VStack {
            VStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 38)
                        .inset(by: 10)
                        .stroke(Color.gray, lineWidth: 2)
                        .frame(maxWidth: 235, maxHeight: 490)
                    VStack {
                        Text(L10n.coreWelcomeToText + "\nARgo")
                            .font(.system(size: 34).bold())

                        Spacer()
                            .frame(height: 100)
                        Text(L10n.coreSpeedUpText + "\n" + L10n.corePrototypingProcessesText)
                            .font(.system(size: 25))
                    }
                    .multilineTextAlignment(.center)
                }

                Spacer()

                Button {
                    viewModel.send(.onNextScene)
                } label: {
                    Text(L10n.coreButtonContinue)
                        .frame(width: 250, height: 30)
                }
                .buttonStyle(
                    GradientBackgroundStyle(
                        startColor: Color(Asset.Colors.Gradients.first.color),
                        endColor: Color(Asset.Colors.Gradients.second.color)
                    )
                )
            }
            .padding()

            Text("\(L10n.coreAgreementText)\n [\(L10n.coreTermsAndConditions)](https://google.com) \(L10n.coreAndText) [\(L10n.corePrivacyPolicy)](https://apple.com).")
                .padding(5)
                .multilineTextAlignment(.center)
                .font(.subheadline)
                .foregroundColor(.gray)

        }
    }
}

struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenView(viewModel: SplashScreenViewModel())
    }
}
