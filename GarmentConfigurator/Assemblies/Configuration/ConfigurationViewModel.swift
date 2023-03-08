import Combine
import SceneKit
import Resolver

final class ConfigurationViewModel: ObservableObject {
    weak var delegate: ConfigurationSceneDelegate?
    weak var navigationVC: ConfigurationNavigationVC?

    @Published private(set) var model: GarmentModel
    @Published private(set) var state: ConfigurationFlow.ViewState = .idle
    @Published private(set) var materials: [ImageMaterial]
    
    let scene: PatternedScene

    // MARK: - Private Properties

    private let eventSubject = PassthroughSubject<ConfigurationFlow.Event, Never>()
    private let stateValueSubject = CurrentValueSubject<ConfigurationFlow.ViewState, Never>(.idle)
    private var subscriptions = Set<AnyCancellable>()
    
    private let imageMaterialsService: any MaterialManagingProtocol = ImageDataMaterialsService()

    init(model: GarmentModel) {
        self.scene = PatternedScene(scene: SCNScene(named: "SceneCatalog.scnassets/Configurator.scn")!)
        self.model = model
        self.materials = imageMaterialsService.retrieveSavedMaterials()
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
                case .apply(material: let material, pattern: let pattern):
                    self?.updateMaterial(material, for: pattern)
                }
            }
            .store(in: &subscriptions)
    }

    private func bindOutput() {
        stateValueSubject
            .assign(to: \.state, on: self)
            .store(in: &subscriptions)
    }
    
    private func updateMaterial(_ textureMaterial: ImageMaterial, for pattern: TShirtPatternInfo) {
        guard let texture = textureMaterial.texture else { return }
        do {
            try scene.applyMaterial(data: texture, to: pattern)
        } catch {
            fatalError(error.localizedDescription)
        }
        model.update(pattern: pattern, with: textureMaterial)
        objectWillChange.send()
    }
}

extension ConfigurationViewModel: ConfigurationContainerDelegate {
    func back() {
        delegate?.back()
    }
}
