import SwiftUI
import AVKit
import Combine

final class ARResultViewModel: ObservableObject {
    weak var delegate: ARResultSceneDelegate?
    weak var navigationVC: ARResultNavigationVC?

    @Published private(set) var state: ARResultFlow.ViewState = .idle

    // MARK: - Private Properties

    private let eventSubject = PassthroughSubject<ARResultFlow.Event, Never>()
    private let stateValueSubject = CurrentValueSubject<ARResultFlow.ViewState, Never>(.idle)
    private var subscriptions = Set<AnyCancellable>()

    let mediaType: ARResultMediaType

    @Published var playerLooper: AVPlayerLooper?
    @Published var player: AVQueuePlayer?
    @Published var hasSaved = false

    init(mediaType: ARResultMediaType) {
        self.mediaType = mediaType
        bindInput()
        bindOutput()
    }

    deinit {
        subscriptions.forEach { $0.cancel() }
        subscriptions.removeAll()
    }

    func send(_ event: ARResultFlow.Event) {
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

    func initPlayer(with playerItem: AVPlayerItem) {
        player = AVQueuePlayer(playerItem: playerItem)
        playerLooper = AVPlayerLooper(player: player!, templateItem: playerItem)
        player?.play()
        player?.actionAtItemEnd = .none

        NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: playerItem,
            queue: .main) { [weak self] _ in
                self?.player?.seek(to: .zero)
                self?.player?.play()
            }
    }

    func saveMediaToAlbum() {
        switch mediaType {
        case .image(let image):
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            self.hasSaved.toggle()
        case .video(let video):
            let filePath = video.path
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

    func shareToInstagram() {
        if let storiesUrl = URL(string: "instagram-stories://share") {
            if UIApplication.shared.canOpenURL(storiesUrl) {
                var shareData = Data()
                var pasteboardItems: [String: Any]
                switch mediaType {
                case .image(let image):
                    shareData = image.jpegData(compressionQuality: 1)!
                    pasteboardItems = [
                        "com.instagram.sharedSticker.stickerImage": shareData,
                        "com.instagram.sharedSticker.backgroundTopColor": "#636e72",
                        "com.instagram.sharedSticker.backgroundBottomColor": "#b2bec3"
                    ]
                case .none:
                    return
                case .video(let video):
                    do {
                        shareData = try Data(contentsOf: URL(fileURLWithPath: video.path))} catch {
                            return
                        }
                    pasteboardItems = [
                        "com.instagram.sharedSticker.backgroundVideo": shareData,
                        "com.instagram.sharedSticker.backgroundTopColor": "#636e72",
                        "com.instagram.sharedSticker.backgroundBottomColor": "#b2bec3"
                    ]
                }

                let pasteboardOptions = [
                    UIPasteboard.OptionsKey.expirationDate:
                        Date().addingTimeInterval(300)
                ]
                UIPasteboard.general.setItems([pasteboardItems], options:
                                                pasteboardOptions)
                UIApplication.shared.open(storiesUrl, options: [:],
                                          completionHandler: nil)
            } else {
                print("Sorry the application is not installed")
            }
        }
    }

    func shareItem() {
        switch mediaType {
        case .image(let image):
            print("image share")
            let items: [Any] = [image]
            let shareSheet = UIActivityViewController(activityItems: items, applicationActivities: nil)
            UIApplication.shared.keyWindow?.rootViewController?.presentedViewController?.present(shareSheet, animated: true, completion: nil)
        case .video(let video):
            print("video share")
            let items: [Any] = [video.path]
            let shareSheet = UIActivityViewController(activityItems: items, applicationActivities: nil)
            UIApplication.shared.keyWindow?.rootViewController?.presentedViewController?.present(shareSheet, animated: true, completion: nil)
        case .none:
            print("non")
        }
    }
}

extension ARResultViewModel: ARResultContainerDelegate {
    func back() {
        delegate?.back()
    }
}
