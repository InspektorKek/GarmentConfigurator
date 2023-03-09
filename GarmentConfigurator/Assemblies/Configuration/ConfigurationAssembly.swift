import UIKit

struct ConfigurationAssembly: SceneAssembly {
    private let delegate: ConfigurationSceneDelegate
    private let input: ConfigurationSceneInput

    init(input: ConfigurationSceneInput, delegate: ConfigurationSceneDelegate) {
        self.input = input
        self.delegate = delegate
    }

    func makeScene() -> UIViewController {
        let viewModel = ConfigurationViewModel(model: input.model)
        viewModel.delegate = delegate
        let viewController = ConfigurationViewController(viewModel: viewModel)
        let navigationVC = ConfigurationNavigationVC(backButtonDelegate: viewModel)
        navigationVC.delegate = viewModel
        viewModel.navigationVC = navigationVC
        return viewController.withCustom(navigationViewController: navigationVC)
    }
}
