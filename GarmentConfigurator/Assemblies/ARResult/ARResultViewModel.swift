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
        print("deinit ARResultViewModel")
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
               var imageData = Data()

               switch mediaType {
               case .image(let image):
                   imageData = image.jpegData(compressionQuality: 1)!
               case .none:
                   return
               case .video:
                   return
               }
//                guard let imageData = capturedImage.jpegData(compressionQuality: 1) else { return }

             let pasteboardItems: [String: Any] = [
             "com.instagram.sharedSticker.stickerImage": imageData,
             "com.instagram.sharedSticker.backgroundTopColor": "#636e72",
             "com.instagram.sharedSticker.backgroundBottomColor": "#b2bec3"
             ]
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
}

extension ARResultViewModel: ARResultContainerDelegate {
    func back() {
        delegate?.back()
    }
}
