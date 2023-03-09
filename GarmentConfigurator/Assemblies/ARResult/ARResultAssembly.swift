import UIKit

struct ARResultAssembly: SceneAssembly {
    private let delegate: ARResultSceneDelegate

    init(delegate: ARResultSceneDelegate) {
        self.delegate = delegate
    }

    func makeScene() -> UIViewController {
        let viewModel = ARResultViewModel(mediaType: .image(UIImage()))
        viewModel.delegate = delegate
        let viewController = ARResultViewController(viewModel: viewModel)
        let navigationVC = ARResultNavigationVC(backButtonDelegate: viewModel)
        navigationVC.delegate = viewModel
        viewModel.navigationVC = navigationVC
        return viewController.withCustom(navigationViewController: navigationVC)
    }
}
