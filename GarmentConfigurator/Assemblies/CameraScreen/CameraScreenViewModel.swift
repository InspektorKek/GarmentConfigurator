import Combine
import UIKit

final class CameraScreenViewModel: ObservableObject {
    weak var delegate: CameraScreenSceneDelegate?
    weak var navigationVC: CameraScreenNavigationVC?

    @Published private(set) var state: CameraScreenFlow.ViewState = .idle

    // MARK: - Private Properties

    private let eventSubject = PassthroughSubject<CameraScreenFlow.Event, Never>()
    private let stateValueSubject = CurrentValueSubject<CameraScreenFlow.ViewState, Never>(.idle)
    private var subscriptions = Set<AnyCancellable>()

    init() {
        bindInput()
        bindOutput()
    }

    deinit {
        subscriptions.forEach { $0.cancel() }
        subscriptions.removeAll()
    }

    func send(_ event: CameraScreenFlow.Event) {
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

extension CameraScreenViewModel: CameraScreenContainerDelegate {
    func back() {
        delegate?.back()
    }
    
    func onRightBarButtonTap() {
        
    }
}
