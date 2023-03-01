////
////  ARResultShareScreen.swift
////  ARTestCapture
////
////  Created by Aleksandr Shapovalov on 27/02/23.
////
//

import SwiftUI
import AVKit

struct ARResultView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel: ARResultViewModel
    @State var isSaved: Bool = false

    var body: some View {
        ZStack {
            switch viewModel.mediaType {
            case .image(let image):
                Image(uiImage: image)
                    .resizable()

                    .ignoresSafeArea()
            case .none:
                Text("nothing")
            case .video(let video):
                VideoPlayer(player: viewModel.player)
                    .ignoresSafeArea()
                    .onAppear {
                        let playerItem = AVPlayerItem(url: video)
                        viewModel.initPlayer(with: playerItem)
                    }
                    .onDisappear {
                        viewModel.player?.pause()
                        viewModel.player = nil
                        viewModel.playerLooper = nil
                    }
            }

            VStack {
                HStack {
                    backButton
                    Spacer()
                }

                Spacer()
                ZStack(alignment: .bottom) {
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundColor(.gray.opacity(0.4))
                        .ignoresSafeArea()

                    HStack {
                        saveButton
                        instagramButton
                        shareButton
                    }
                    .padding()
                    .padding(.top, 30)
                }
                .frame(height: 80)
            }
        }
    }

    private var backButton: some View {
        Button(action: {
            dismiss()
        }, label: {
            Image(systemName: "chevron.backward")
                .foregroundColor(.black)
                .padding()
                .background(Color.white)
                .clipShape(Circle())
        })
        .padding()
    }

    private var shareButton: some View {
        Button(action: {
//            viewModel.saveMediaToAlbum()
            viewModel.shareToInstagram()
        }, label: {
            Image(systemName: "square.and.arrow.up")
                .foregroundColor(.black)
                .padding()
                .background(Color.white)
                .clipShape(Circle())
        })
    }

    private var saveButton: some View {
        Button(action: {
            viewModel.saveMediaToAlbum()
            isSaved = true
        }, label: {
            Image(systemName: !isSaved ? "square.and.arrow.down" : "checkmark")
                .foregroundColor(.black)
                .padding()
                .background(Color.white)
                .clipShape(Circle())
        })
    }

    private var instagramButton: some View {
        Button(action: {
            viewModel.shareToInstagram()
        }, label: {
            Image("instagram")
                .foregroundColor(.black)
                .padding()
                .background(Color.white)
                .clipShape(Circle())
        })
    }
}

