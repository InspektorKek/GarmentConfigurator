import Combine
import UIKit

final class GarmentsViewModel: ObservableObject {
    weak var delegate: GarmentsSceneDelegate?
    weak var navigationVC: GarmentsNavigationVC?

    @Published private(set) var state: GarmentsFlow.ViewState = .idle
    @Published private(set) var garments: [GarmentModel] = []

    // MARK: - Private Properties

    private let eventSubject = PassthroughSubject<GarmentsFlow.Event, Never>()
    private let stateValueSubject = CurrentValueSubject<GarmentsFlow.ViewState, Never>(.idle)
    private var subscriptions = Set<AnyCancellable>()

    init() {
        fillGarments()
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
                guard let self else { return }
                switch event {
                case .onAppear:
                    self.objectWillChange.send()
                case .onTap(model: let model):
                    self.openConfigurator(for: model)
                }
            }
            .store(in: &subscriptions)
    }

    private func bindOutput() {
        stateValueSubject
            .assign(to: \.state, on: self)
            .store(in: &subscriptions)
    }
    
    private func fillGarments() {
        garments = [
            GarmentModel(type: .tShirt,name: "T-Shirt-Female", bodyType: .female),
            GarmentModel(type: .tShirt,name: "T-Shirt-Male", bodyType: .male)
        ]
    }
    
    private func openConfigurator(for model: GarmentModel) {
        let input = ConfigurationSceneInput(model: model)
        delegate?.openConfigurator(input: input)
    }
    
    private func openNewConfigurator() {
        let model = GarmentModel(type: .tShirt,
                                 name: "T-Shirt",
                                 bodyType: .female)
        let input = ConfigurationSceneInput(model: model)
        garments.append(model)
        delegate?.openConfigurator(input: input)
    }
}

extension GarmentsViewModel: GarmentsContainerDelegate {
    func addActionTapped() {
        openNewConfigurator()
    }
}
