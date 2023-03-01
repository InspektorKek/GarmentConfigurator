//
//  ARResultViewModel.swift
//  ARTestCapture
//
//  Created by Aleksandr Shapovalov on 28/02/23.
//

import SwiftUI
import AVKit

class ARResultViewModel: ObservableObject {
    let mediaType: ARResultMediaType

    @Published var playerLooper: AVPlayerLooper?
    @Published var player: AVQueuePlayer?
    @Published var hasSaved = false

    init(mediaType: ARResultMediaType) {
        self.mediaType = mediaType
    }

    deinit {
        print("deinit ARResultViewModel")
    }

     func initPlayer(with playerItem: AVPlayerItem) {
        player = AVQueuePlayer(playerItem: playerItem)
        playerLooper = AVPlayerLooper(player: player!, templateItem: playerItem)
        player?.play()
        player?.actionAtItemEnd = .none

        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: playerItem, queue: .main) { [weak self] _ in
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
                case .video(_):
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
