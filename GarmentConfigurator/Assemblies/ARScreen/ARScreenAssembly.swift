import UIKit

struct ARScreenAssembly: SceneAssembly {
    private let delegate: ARScreenSceneDelegate

    init(delegate: ARScreenSceneDelegate) {
        self.delegate = delegate
    }

    func makeScene() -> UIViewController {
        let viewModel = ARScreenViewModel()
        viewModel.delegate = delegate
        let viewController = ARScreenViewController(viewModel: viewModel)
        let navigationVC = ARScreenNavigationVC(backButtonDelegate: viewModel)
        navigationVC.delegate = viewModel
        viewModel.navigationVC = navigationVC
        return viewController.withCustom(navigationViewController: navigationVC)
    }
}
