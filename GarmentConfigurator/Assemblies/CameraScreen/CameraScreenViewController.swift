import UIKit

final class CameraScreenViewController: UIHostingViewControllerCustom<CameraScreenView> {
    let viewModel: CameraScreenViewModel

    init(viewModel: CameraScreenViewModel) {
        self.viewModel = viewModel
        super.init(rootView: CameraScreenView(camera: viewModel))
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
