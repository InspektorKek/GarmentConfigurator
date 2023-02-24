import UIKit

struct SplashScreenAssembly: SceneAssembly {
    private let delegate: SplashScreenSceneDelegate

    init(delegate: SplashScreenSceneDelegate) {
        self.delegate = delegate
    }

    func makeScene() -> UIViewController {
        let viewModel = SplashScreenViewModel()
        viewModel.delegate = delegate
        let viewController = SplashScreenViewController(viewModel: viewModel)
        return viewController
    }
}
