import Combine
import UIKit

final class SplashScreenViewModel: ObservableObject {
    weak var delegate: SplashScreenSceneDelegate?

    @Published private(set) var state: SplashScreenFlow.ViewState = .idle

    // MARK: - Private Properties

    private let eventSubject = PassthroughSubject<SplashScreenFlow.Event, Never>()
    private let stateValueSubject = CurrentValueSubject<SplashScreenFlow.ViewState, Never>(.idle)
    private var subscriptions = Set<AnyCancellable>()

    init() {
        bindInput()
        bindOutput()
    }

    deinit {
        subscriptions.forEach { $0.cancel() }
        subscriptions.removeAll()
    }

    func send(_ event: SplashScreenFlow.Event) {
        eventSubject.send(event)
    }

    private func bindInput() {
        eventSubject
            .sink { [weak self] event in
                switch event {
                case .onAppear:
                    self?.objectWillChange.send()
                case .onNextScene:
                    self?.delegate?.startMainFlow()
                }
            }
            .store(in: &subscriptions)
    }

    private func bindOutput() {
        stateValueSubject
            .assign(to: \.state, on: self)
            .store(in: &subscriptions)
    }

     func openPrivacyPolicy() {
        guard let url = URL(string: AppConstants.Links.privacyPolicy) else { return }
         UIApplication.shared.open(url)
         // MARK: in case if we would need to open safari inside app
//        delegate?.openURL(url)
    }

     func openTermsAndConditiions() {
         guard let url = URL(string: AppConstants.Links.termsAndConditions) else { return }
         UIApplication.shared.open(url)
         // MARK: in case if we would need to open safari inside app
//        delegate?.openURL(url)
    }
}

extension SplashScreenViewModel: SplashScreenContainerDelegate {

}
