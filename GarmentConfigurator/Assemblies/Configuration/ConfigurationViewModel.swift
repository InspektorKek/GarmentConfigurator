import Combine
import UIKit

final class ConfigurationViewModel: ObservableObject {
    weak var delegate: ConfigurationSceneDelegate?
    weak var navigationVC: ConfigurationNavigationVC?

    @Published private(set) var state: ConfigurationFlow.ViewState = .idle

    // MARK: - Private Properties

    private let eventSubject = PassthroughSubject<ConfigurationFlow.Event, Never>()
    private let stateValueSubject = CurrentValueSubject<ConfigurationFlow.ViewState, Never>(.idle)
    private var subscriptions = Set<AnyCancellable>()

    init() {
        bindInput()
        bindOutput()
    }

    deinit {
        subscriptions.forEach { $0.cancel() }
        subscriptions.removeAll()
    }

    func send(_ event: ConfigurationFlow.Event) {
        eventSubject.send(event)
    }

    private func bindInput() {
        eventSubject
            .sink { [weak self] event in
                switch event {
                case .onAppear:
                    self?.objectWillChange.send()
                case .onNextScene:
                    print("Next scene")
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

extension ConfigurationViewModel: ConfigurationContainerDelegate {
    func back() {
        delegate?.back()
    }
}
