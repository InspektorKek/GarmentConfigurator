import SwiftUI

struct SplashScreenView: View {
    private enum Constants {
        static let markdown = LinkMarkdownComposer.replaceIn(text: L10n.coreAgreementText, translationAndLinks: [
            L10n.coreTermsAndConditions: AppConstants.Links.termsAndConditions,
            L10n.corePrivacyPolicy: AppConstants.Links.privacyPolicy
        ])
    }
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

            Text(.init(Constants.markdown))
                .padding(5)
                .multilineTextAlignment(.center)
                .font(.subheadline)
                .foregroundColor(.gray)
                .environment(\.openURL, OpenURLAction { url in
                    viewModel.send(.onSelect(url))
                    return .discarded
                })
                .padding(.horizontal, 16)
        }
    }
}

struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenView(viewModel: SplashScreenViewModel())
    }
}

struct LinkMarkdownComposer {
    static func replaceIn(text: String, translationAndLinks: [String: String]) -> String {
        var result = text
        translationAndLinks.forEach { key, link in
            result = result.replacingOccurrences(of: key, with: getMarkdownFor(text: key, link: link))
        }
        return result
    }
    
    private static func getMarkdownFor(text: String, link: String) -> String {
        "**[\(text)](\(link))**"
    }
}
