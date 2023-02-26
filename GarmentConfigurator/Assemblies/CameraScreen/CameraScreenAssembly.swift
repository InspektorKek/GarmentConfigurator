import UIKit

struct CameraScreenAssembly: SceneAssembly {
    private let delegate: CameraScreenSceneDelegate

    init(delegate: CameraScreenSceneDelegate) {
        self.delegate = delegate
    }
    
    func makeScene() -> UIViewController {
        let viewModel = CameraScreenViewModel()
        viewModel.delegate = delegate
        let viewController = CameraScreenViewController(viewModel: viewModel)
        let navigationVC = CameraScreenNavigationVC(backButtonDelegate: viewModel)
        navigationVC.delegate = viewModel
        viewModel.navigationVC = navigationVC
        return viewController.withCustom(navigationViewController: navigationVC)
    }
}
