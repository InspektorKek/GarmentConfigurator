////
////  ARResultShareScreen.swift
////  ARTestCapture
////
////  Created by Aleksandr Shapovalov on 27/02/23.
////
//

import SwiftUI
import AVKit

enum ARResultMediaType {
    case none
    case image(UIImage?)
    case video(URL?)
}

struct ARResultScreen: View {
    @EnvironmentObject var viewModel: ARScreenViewModel

    var body: some View {
        ZStack {
            switch viewModel.mediaType {
            case .image:
                Image(uiImage: viewModel.capturedImage)
                    .resizable()
                    .onDisappear {
                        viewModel.capturedImage = UIImage()
                    }
            case .none:
                Text("nothing")
            case .video:
                VideoPlayer(player: viewModel.player)
                    .onAppear {
                        let playerItem = AVPlayerItem(url: viewModel.capturedVideo)
                        viewModel.initPlayer(with: playerItem)
                    }
                    .onDisappear {
                        viewModel.player?.pause()
                        viewModel.player = nil
                        viewModel.playerLooper = nil
                        viewModel.capturedVideo = URL(fileURLWithPath: "")
                    }
            }

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
                .padding()
            }
        }
    }

    private var backButton: some View {
        Button(action: {
            //
        }, label: {
            Image(systemName: "chevron.backward")
        })
        .padding()
    }

    private var saveButton: some View {
        Button(action: {
//            viewModel.saveMediaToAlbum()
        }, label: {
            Image(systemName: "square.and.arrow.down")
        })
        .frame(width: 48, height: 48)
    }

    private var publishButton: some View {
        Button(action: {
            viewModel.saveMediaToAlbum()
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
}
