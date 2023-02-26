import UIKit

final class SplashScreenViewController: UIHostingViewControllerCustom<SplashScreenView> {
    let viewModel: SplashScreenViewModel

    init(viewModel: SplashScreenViewModel) {
        self.viewModel = viewModel
        super.init(rootView: SplashScreenView(viewModel: viewModel))
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
