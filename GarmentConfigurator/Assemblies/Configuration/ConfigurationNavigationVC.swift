import UIKit

final class ConfigurationNavigationVC: BackButtonNavigationVC {

    weak var delegate: ConfigurationContainerDelegate?
    
    private let arButton: UIButton = {
        let button = UIButton(type: .detailDisclosure)
        button.tintColor = Asset.Colors.baseWhite.color
        button.setImage(UIImage(systemName: "arkit"), for: .normal)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupUI()
    }

    private func setupLayout() {
        controlsContainer.addSubviews([arButton])
        controlsContainer.snp.makeConstraints { make in
            make.height.equalTo(44)
        }

        arButton.snp.makeConstraints { make in
            make.size.equalTo(36)
            make.trailingMargin.equalToSuperview().offset(-8)
            make.centerY.equalToSuperview()
        }
    }

    private func setupUI() {
        arButton.addAction { [weak self] in
            self?.delegate?.openAR()
        }
    }
}
