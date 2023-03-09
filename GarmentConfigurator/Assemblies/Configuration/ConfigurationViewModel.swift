import Combine
import SceneKit
import Resolver

final class ConfigurationViewModel: ObservableObject {
    weak var delegate: ConfigurationSceneDelegate?
    weak var navigationVC: ConfigurationNavigationVC?

    @Published private(set) var model: GarmentModel
    @Published private(set) var state: ConfigurationFlow.ViewState = .idle
    @Published private(set) var materials: [ImageMaterial] = []
    
    let scene: PatternedScene

    // MARK: - Private Properties

    private let eventSubject = PassthroughSubject<ConfigurationFlow.Event, Never>()
    private let stateValueSubject = CurrentValueSubject<ConfigurationFlow.ViewState, Never>(.idle)
    private var subscriptions = Set<AnyCancellable>()
    
    private let imageMaterialsService: any MaterialManagingProtocol = ImageDataMaterialsService()

    init(model: GarmentModel) {
        self.scene = PatternedScene(scene: SCNScene(named: model.sceneName)!)
        self.model = model
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
                case .addOwnMaterial(pattern: let pattern):
                    self?.openPhotoSelector(for: pattern)
                case .apply(material: let material, pattern: let pattern):
                    self?.updateMaterial(material, for: pattern)
                case .onChangeScale(value: let value, pattern: let pattern):
                    self?.updateScale(value, for: pattern)
                case .onChangeRotation(value: let value, pattern: let pattern):
                    self?.updateRotation(value, for: pattern)
                }
            }
            .store(in: &subscriptions)
    }

    private func bindOutput() {
        stateValueSubject
            .assign(to: \.state, on: self)
            .store(in: &subscriptions)
        
        imageMaterialsService.materials
            .receive(on: RunLoop.main)
            .assign(to: \.materials, on: self)
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
    
    private func updateScale(_ value: Float, for pattern: TShirtPatternInfo) {
        do {
            try scene.applyScale(value: value, for: pattern)
        } catch {
            fatalError(error.localizedDescription)
        }
        model.updateScale(value: value, for: pattern)
    }
    
    private func updateRotation(_ value: Float, for pattern: TShirtPatternInfo) {
        do {
            try scene.applyRotation(value: value, for: pattern)
        } catch {
            fatalError(error.localizedDescription)
        }
        model.updateRotation(value: value, for: pattern)
    }
    
    private func openPhotoSelector(for pattern: TShirtPatternInfo) {
        let updateHandler: ((UIImage) -> Void) = { [weak self] image in
            let material = ImageMaterial(texture: image.pngData(), id: .init())
            self?.imageMaterialsService.addNew(material)
            self?.updateMaterial(material, for: pattern)
        }
        
        delegate?.openImagePicker(updateHandler: updateHandler, removeHandler: nil)
    }
}

extension ConfigurationViewModel: ConfigurationContainerDelegate {
    func openAR() {
        delegate?.openAR(input: model)
    }
    
    func back() {
        delegate?.back()
    }
}
