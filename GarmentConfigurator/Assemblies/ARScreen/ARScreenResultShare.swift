////
////  ARResultShareScreen.swift
////  ARTestCapture
////
////  Created by Aleksandr Shapovalov on 27/02/23.
////
//
// import SwiftUI
// import AVKit
//
// enum ARResultMediaType {
//    case none
//    case image(UIImage?)
//    case video(URL?)
// }
//
// struct ARResultShareScreen: View {
//    @State private var mediaType: ARResultMediaType = .none
//
//    @State private var player: AVQueuePlayer?
//    @State private var playerLooper: AVPlayerLooper?
//    @State private var hasSaved: Bool = false
//
//    var body: some View {
//        switch mediaType {
//        case .none:
//            Text("No media available")
//        case .image(let image):
//            Image(uiImage: image!)
//                .resizable()
//                .aspectRatio(contentMode: .fit)
//        case .video(let videoURL):
//            VideoPlayer(player: player)
//                .onAppear {
//                    guard let url = videoURL else { return }
//                    let playerItem = AVPlayerItem(url: url)
//                    player = AVPlayer(playerItem: playerItem)
//                    playBackIfNeeded()
//                    NotificationCenter.default.addObserver(forName: UIApplication.willEnterForegroundNotification, object: nil, queue: .main) { [weak self] _ in
//                        self?.playBackIfNeeded()
//                    }
//                }
//                .onDisappear {
//                    player?.pause()
//                    player = nil
//                }
//        }
//    }
//
//    private func playBackIfNeeded() {
//        if player == nil { return }
//        try? AVAudioSession.sharedInstance().setCategory(.playback)
//        try? AVAudioSession.sharedInstance().setActive(true)
//        player?.play()
//    }
// }
//
// struct ARResultShareScreen_Previews: PreviewProvider {
//    static var previews: some View {
//        ARResultShareScreen()
//    }
// }

import SwiftUI
import AVKit

enum ARResultMediaType {
    case none
    case image(UIImage?)
    case video(URL?)
}

struct ARResultView: View {
    @State var mediaType: ARResultMediaType
    @Binding var image: UIImage

    @State private var player: AVQueuePlayer?
    @State private var playerLooper: AVPlayerLooper?
    @State private var hasSaved = false

    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack {
//            Color.white.ignoresSafeArea()
            Image(uiImage: image)
                .resizable()

            VStack {
                HStack {
                    backButton
                    Spacer()
                }
                Spacer()
                HStack {
                    saveButton
                    publishButton
                }
                //                .padding(.bottom, UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0)
                .padding()
            }
        }
        .onAppear {
            switch mediaType {
            case .image:
                Task {
                    imageView.image = self.image
                }
            case .video(let videoURL):
                NotificationCenter.default.addObserver(forName: UIApplication.willEnterForegroundNotification, object: nil, queue: .main) { _ in
                    playBackIfNeeded()
                }
                guard let url = videoURL else { return }
                let playerItem = AVPlayerItem(url: url)
                initPlayer(with: playerItem)
            case .none:
                break
            }
        }
        .onDisappear {
            player?.pause()
        }
    }

    private func playBackIfNeeded() {
        if player == nil { return }
        try? AVAudioSession.sharedInstance().setCategory(.playback)
        try? AVAudioSession.sharedInstance().setActive(true)
        player?.play()
    }

    private func initPlayer(with playerItem: AVPlayerItem) {
        player = AVQueuePlayer(playerItem: playerItem)
        playerLooper = AVPlayerLooper(player: player!, templateItem: playerItem)
        player?.play()
    }

    private var imageView: UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }

    private var backButton: some View {
        Button(action: {
            dismiss()
        }, label: {
            Image(systemName: "chevron.backward")
        })
        .padding()
    }

    private var saveButton: some View {
        Button(action: {
            saveMediaToAlbum()
            hasSaved = true
        }, label: {
            Image(systemName: "square.and.arrow.down")
        })
        .frame(width: 48, height: 48)
    }

    private var publishButton: some View {
        Button(action: {
            if !hasSaved {
                saveMediaToAlbum()
            }
        }, label: {
            Text("Save")
                .font(.system(size: 24))
                .foregroundColor(.white)
        })
        .frame(height: 48)
        .background(Color.red)
        .cornerRadius(24)
        .padding(.horizontal, 20)
    }

    private func saveMediaToAlbum() {
//        switch mediaType {
//            //        case .image(let image):
//            //            guard let image = image else {
//            //                return
//            //            }
//            //            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
//        case .image:
//            let image = self.image
//            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
//            self.hasSaved.toggle()
//        case .video(let videoURL):
//            guard let url = videoURL else {
//                return
//            }
//            let filePath = url.path
//            let videoCompatible = UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(filePath)
//            if videoCompatible {
//                UISaveVideoAtPathToSavedPhotosAlbum(filePath, nil, nil, nil)
//            } else {
//                print("error saving")
//            }
//        case .none:
//            break
//        }

                let image = self.image
                            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                            self.hasSaved.toggle()
            }
//    }
}
