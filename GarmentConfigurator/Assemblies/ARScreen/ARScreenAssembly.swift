import UIKit

struct ARScreenAssembly: SceneAssembly {
    private let delegate: ARScreenSceneDelegate
    private let model: GarmentModel

    init(model: GarmentModel, delegate: ARScreenSceneDelegate) {
        self.model = model
        self.delegate = delegate
    }

    func makeScene() -> UIViewController {
        let viewModel = ARScreenViewModel(model: model)
        viewModel.delegate = delegate
        let viewController = ARScreenViewController(viewModel: viewModel)
        viewController.modalPresentationStyle = .fullScreen
        return viewController
    }
}
