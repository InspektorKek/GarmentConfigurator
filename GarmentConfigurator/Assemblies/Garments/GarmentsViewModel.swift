import Combine
import SceneKit
import UIKit

class GarmentListCellModel: Identifiable {
    let id: UUID
    let scene: PatternedScene
    let model: GarmentModel
    
    init(scene: PatternedScene, model: GarmentModel) {
        self.id = UUID()
        self.scene = scene
        self.model = model
    }
    
    static func == (lhs: GarmentListCellModel, rhs: GarmentListCellModel) -> Bool {
        lhs.id == rhs.id
    }
}

final class GarmentsViewModel: ObservableObject {
    weak var delegate: GarmentsSceneDelegate?
    weak var navigationVC: GarmentsNavigationVC?

    @Published private(set) var state: GarmentsFlow.ViewState = .idle
    @Published private(set) var garments: [GarmentListCellModel] = []

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
                    self.applyMaterials()
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
            GarmentModel(type: .tShirt,name: "T-Shirt-Male", bodyType: .male)
        ]
            .map {
                GarmentListCellModel(scene: PatternedScene(scene: SCNScene(named: $0.sceneName)!), model: $0)
            }
    }
    
    private func applyMaterials() {
        garments
            .forEach { cellModel in
                cellModel.model.patterns.forEach { pattern in
                    if let material = pattern.textureMaterial, let imageData = material.texture {
                        do {
                            try cellModel.scene.applyMaterial(data: imageData, to: pattern)
                        } catch {
                            print(error)
                        }
                    }
                }
            }
    }
    
    private func openConfigurator(for model: GarmentModel) {
        let input = ConfigurationSceneInput(model: model)
        delegate?.openConfigurator(input: input)
    }
    
    private func openNewConfigurator() {
        let model = GarmentModel(type: .tShirt,
                                 name: "T-Shirt",
                                 bodyType: .female)
        let cellModel = GarmentListCellModel(scene: PatternedScene(scene: SCNScene(named: model.sceneName)!), model: model)
        let input = ConfigurationSceneInput(model: model)
        garments.append(cellModel)
        delegate?.openConfigurator(input: input)
    }
}

extension GarmentsViewModel: GarmentsContainerDelegate {
    func addActionTapped() {
        openNewConfigurator()
    }
}
