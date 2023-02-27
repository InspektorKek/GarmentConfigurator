import UIKit

struct ConfigurationAssembly: SceneAssembly {
    private let delegate: ConfigurationSceneDelegate

    init(delegate: ConfigurationSceneDelegate) {
        self.delegate = delegate
    }

    func makeScene() -> UIViewController {
        let viewModel = ConfigurationViewModel()
        viewModel.delegate = delegate
        let viewController = ConfigurationViewController(viewModel: viewModel)
        let navigationVC = ConfigurationNavigationVC(backButtonDelegate: viewModel)
        navigationVC.delegate = viewModel
        viewModel.navigationVC = navigationVC
        return viewController.withCustom(navigationViewController: navigationVC)
    }
}
