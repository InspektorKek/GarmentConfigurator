import Combine
import UIKit

final class GarmentsViewModel: ObservableObject {
    weak var delegate: GarmentsSceneDelegate?
    weak var navigationVC: GarmentsNavigationVC?

    @Published private(set) var state: GarmentsFlow.ViewState = .idle

    // MARK: - Private Properties

    private let eventSubject = PassthroughSubject<GarmentsFlow.Event, Never>()
    private let stateValueSubject = CurrentValueSubject<GarmentsFlow.ViewState, Never>(.idle)
    private var subscriptions = Set<AnyCancellable>()

    init() {
        bindInput()
        bindOutput()
    }

    deinit {
        subscriptions.forEach { $0.cancel() }
        subscriptions.removeAll()
    }

    func send(_ event: GarmentsFlow.Event) {
        eventSubject.send(event)
    }

    private func bindInput() {
        eventSubject
            .sink { [weak self] event in
                switch event {
                case .onAppear:
                    self?.objectWillChange.send()
                case .onNextScene:
                    self?.delegate?.openConfigurator()
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

extension GarmentsViewModel: GarmentsContainerDelegate {

}
