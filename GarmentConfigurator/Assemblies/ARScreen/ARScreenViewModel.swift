//
//  ARViewModel.swift
//  ARTestCapture
//
//  Created by Aleksandr Shapovalov on 27/02/23.
//

import SwiftUI
import RealityKit
import Combine
import ARKit

enum ARResultMediaType: Equatable {
    case none
    case image(UIImage)
    case video(URL)
}

enum Capture {
    static let limitedTime: Double = 60.00
}

class ARScreenViewModel: NSObject, ObservableObject, ARSessionDelegate {
    weak var delegate: ARScreenSceneDelegate?

    @Published private(set) var state: ARScreenFlow.ViewState = .idle

    // MARK: - Private Properties

    private let eventSubject = PassthroughSubject<ARScreenFlow.Event, Never>()
    private let stateValueSubject = CurrentValueSubject<ARScreenFlow.ViewState, Never>(.idle)
    private var subscriptions = Set<AnyCancellable>()

    var mediaType: ARResultMediaType?

    @Published var shouldShowResult: Bool = false
    @Published var isRecording: Bool = false
    @Published var labelText: String = "00:00"
    @Published var progressValue: CGFloat = 0.0
    
    var arView: ARView? {
        didSet {
            arView?.prepareForRecording()
        }
    }

    // MARK: Augmented Reality model properties
    var scaleValue: Float = 0.01
    var character: BodyTrackedEntity?
    let characterOffset: SIMD3<Float> = [0, 0, 0]
    let characterAnchor = AnchorEntity()
    var cancellables = Set<AnyCancellable>()
    
    let model: GarmentModel

    init(model: GarmentModel) {
        self.model = model
        super.init()
        bindInput()
        bindOutput()
    }

    deinit {
        subscriptions.forEach { $0.cancel() }
        subscriptions.removeAll()
    }

    func send(_ event: ARScreenFlow.Event) {
        eventSubject.send(event)
    }

    private func bindInput() {
        eventSubject
            .sink { [weak self] event in
                guard let self else { return }
                switch event {
                case .onAppear:
                    self.objectWillChange.send()
                case .onNextScene:
                    self.delegate?.closeAR()
                }
            }
            .store(in: &subscriptions)
    }

    private func bindOutput() {
        stateValueSubject
            .assign(to: \.state, on: self)
            .store(in: &subscriptions)
    }

    // MARK: Photo/Video capture methods

    func takePhoto() {
        arView?.takePhotoResult { [weak self] result in
            switch result {
            case .success(let image):
                print("image taken")
                self?.mediaType = .image(image)
                self?.shouldShowResult = true
            case .failure(let error):
                print(error)
            }
        }
    }

    func startCapturingVideo() {
        DispatchQueue.global().async {
            do {
                guard let videoCapture = try self.arView?.startVideoRecording() else { return }
                DispatchQueue.main.async {
                    self.isRecording = true
                }

                let formatted: (TimeInterval) -> String = {
                    let seconds = Int($0)
                    return String(format: "%02d:%02d", seconds / 60, seconds % 60)
                }

                videoCapture.$duration.observe(on: .main) { [weak self] duration in
                    if duration < Capture.limitedTime {
                        DispatchQueue.main.async {
                            self?.labelText = formatted(duration)
                            self?.progressValue = CGFloat(duration / 60)
                        }
                    } else {
                        DispatchQueue.main.async {
                            self?.stopCapturingVideo()
                        }
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    self.isRecording = false
                    self.stopCapturingVideo()
                }
                print(error)
            }
        }
    }

    func stopCapturingVideo() {
        isRecording = false
        arView?.finishVideoRecording { [weak self] videoRecording in
            self?.mediaType = .video(videoRecording.url)
            self?.shouldShowResult = true
            self?.progressValue = 0.0
        }
    }

    // MARK: Augmented Reality model methods
    func loadCharacter(material: SimpleMaterial) {
        Entity.loadBodyTrackedAsync(named: "T-Shirt").sink(receiveCompletion: { completion in
            if case let .failure(error) = completion {
                print("Error: Unable to load model: \(error.localizedDescription)")
            }
        }, receiveValue: { [weak self] (character: Entity) in
            if let character = character as? BodyTrackedEntity {
                character.scale = [self?.scaleValue ?? 0.01, self?.scaleValue ?? 0.01, self?.scaleValue ?? 0.01]
                self?.character = character
                self?.arView!.scene.addAnchor(self!.characterAnchor) // Add characterAnchor to the scene
            } else {
                print("Error: Unable to load model as BodyTrackedEntity")
            }
        }).store(in: &cancellables)
    }

    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        for anchor in anchors {
            guard let bodyAnchor = anchor as? ARBodyAnchor else { continue }

            let bodyPosition = simd_make_float3(bodyAnchor.transform.columns.3)
            characterAnchor.position = bodyPosition + characterOffset
            characterAnchor.orientation = Transform(matrix: bodyAnchor.transform).rotation

            if let character = character, character.parent == nil {
                characterAnchor.addChild(character)
            }
        }
    }
}
