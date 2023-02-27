import UIKit

final class ConfigurationViewController: UIHostingViewControllerCustom<ConfigurationView> {
    let viewModel: ConfigurationViewModel

    init(viewModel: ConfigurationViewModel) {
        self.viewModel = viewModel
        super.init(rootView: ConfigurationView(viewModel: viewModel))
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
