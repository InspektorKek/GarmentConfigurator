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
                case .onSelect(let url):
                    UIApplication.shared.open(url)
                }
            }
            .store(in: &subscriptions)
    }

    private func bindOutput() {
        stateValueSubject
            .assign(to: \.state, on: self)
            .store(in: &subscriptions)
    }
}

extension SplashScreenViewModel: SplashScreenContainerDelegate {

}
