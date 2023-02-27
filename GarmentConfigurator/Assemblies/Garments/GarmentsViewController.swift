import UIKit

final class GarmentsViewController: UIHostingViewControllerCustom<GarmentsView> {
    let viewModel: GarmentsViewModel

    init(viewModel: GarmentsViewModel) {
        self.viewModel = viewModel
        super.init(rootView: GarmentsView(viewModel: viewModel))
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
