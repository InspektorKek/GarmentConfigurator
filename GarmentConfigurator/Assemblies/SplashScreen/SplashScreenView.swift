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
                        .frame(maxWidth: 211, maxHeight: 459)
                    VStack {
                        Text("Welcome to \nARgo")
                            .font(.system(size: 34).bold())

                        Spacer()
                            .frame(height: 100)
                        Text("speed up the garment \nprototyping process")
                            .font(.title2)
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
            Text("By continuing you agree to our Terms and Conditions and Privacy Policy.")
                .font(.subheadline)
                .padding(7)
        }
    }
}

struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenView(viewModel: SplashScreenViewModel())
    }
}
