import UIKit

struct GarmentsAssembly: SceneAssembly {
    private let delegate: GarmentsSceneDelegate

    init(delegate: GarmentsSceneDelegate) {
        self.delegate = delegate
    }

    func makeScene() -> UIViewController {
        let viewModel = GarmentsViewModel()
        viewModel.delegate = delegate
        let viewController = GarmentsViewController(viewModel: viewModel)
        let navigationVC = GarmentsNavigationVC()
        viewModel.navigationVC = navigationVC
        return viewController.withCustom(navigationViewController: navigationVC)
    }
}
