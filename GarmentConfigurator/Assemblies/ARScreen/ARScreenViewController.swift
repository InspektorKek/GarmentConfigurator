import UIKit

final class ARScreenViewController: UIHostingViewControllerCustom<ARScreenView> {
    let viewModel: ARScreenViewModel

    init(viewModel: ARScreenViewModel) {
        self.viewModel = viewModel
        super.init(rootView: ARScreenView(viewModel: ARScreenViewModel()))
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
