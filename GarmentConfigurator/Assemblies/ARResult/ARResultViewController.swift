import UIKit

final class ARResultViewController: UIHostingViewControllerCustom<ARResultView> {
    let viewModel: ARResultViewModel

    init(viewModel: ARResultViewModel) {
        self.viewModel = viewModel
        super.init(rootView: ARResultView(viewModel: viewModel))
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
