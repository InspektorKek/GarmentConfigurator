import Combine
import SwiftUI
import RealityKit
import AVKit

final class ARScreenViewModel: ObservableObject {
    weak var delegate: ARScreenSceneDelegate?
    weak var navigationVC: ARScreenNavigationVC?

    @Published private(set) var state: ARScreenFlow.ViewState = .idle

    @Published var capturedImage: UIImage = UIImage()
    @Published var capturedVideo: URL = URL(filePath: "")
    @Published var mediaType: ARResultMediaType = .none
    @Published var isPressed: Bool = false

    @Published var playerLooper: AVPlayerLooper?
    @Published var player: AVQueuePlayer?
    @Published var hasSaved = false

    // MARK: - Private Properties

    private let eventSubject = PassthroughSubject<ARScreenFlow.Event, Never>()
    private let stateValueSubject = CurrentValueSubject<ARScreenFlow.ViewState, Never>(.idle)
    private var subscriptions = Set<AnyCancellable>()

    init() {
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

    func takePhoto() {
        DispatchQueue.global().async {
            ARVariables.arView.takePhotoResult { result in
                switch result {
                case .success(let image):
                    print("image taken")
                    DispatchQueue.main.async {
                        self.capturedImage = image
                        self.mediaType = .image(image)
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }

    func startCapturingVideo() {
        DispatchQueue.global().async {
            do {
                try ARVariables.arView.startVideoRecording()
                self.isPressed = true
            } catch {
                print(error)
            }
        }
    }

    func stopCapturingVideo() {
        DispatchQueue.global().async {
            ARVariables.arView.finishVideoRecording { videoRecording in
                DispatchQueue.main.async {
                    self.capturedVideo = videoRecording.url
                    self.mediaType = .video(self.capturedVideo)
                    self.isPressed = false
                }
            }
        }
    }

    func initPlayer(with playerItem: AVPlayerItem) {
        player = AVQueuePlayer(playerItem: playerItem)
        playerLooper = AVPlayerLooper(player: player!, templateItem: playerItem)
        player?.play()
        player?.actionAtItemEnd = .none

        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: playerItem, queue: .main) { _ in
            self.player?.seek(to: .zero)
            self.player?.play()
        }
    }

    func saveMediaToAlbum() {
        switch mediaType {
        case .image:
            let image = self.capturedImage
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            self.hasSaved.toggle()
        case .video:
            let url = self.capturedVideo
            let filePath = url.path
            let videoCompatible = UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(filePath)
            if videoCompatible {
                UISaveVideoAtPathToSavedPhotosAlbum(filePath, nil, nil, nil)
            } else {
                print("error saving")
            }
        case .none:
            break
        }
    }
}

extension ARScreenViewModel: ARScreenContainerDelegate {
    func back() {
        delegate?.back()
    }

    func onRightBarButtonTap() {

    }
}
