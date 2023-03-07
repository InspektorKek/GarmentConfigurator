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
    @State var isShareSheetPresented: Bool = false

    var body: some View {
        VStack {
            ZStack(alignment: .topLeading) {
                switch viewModel.mediaType {
                case .image(let image):
                    Image(uiImage: image)
                        .resizable()
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
                HStack(alignment: .top) {
                    Spacer()
                    closeButton
                }
            }
            .cornerRadius(32)

            Spacer()

            ZStack {
                HStack {
                    Spacer()
                    saveButton
                    Spacer()
                    instagramButton
                    // shareButton
                    Spacer()
                    switch viewModel.mediaType {
                    case .image(let image):
                        ShareLink(item: Image(uiImage: image),
                                  preview: SharePreview("Image", image: Image(uiImage: image))) {
                            VStack(spacing: 4) {
                                Image(systemName: "ellipsis.circle")
                                    .font(.title2)
                                    .foregroundColor(.white)
                                Text(L10n.coreButtonShare)
                                    .font(.caption2)
                            }
                            .frame(maxWidth: 100, maxHeight: 100)
                        }

                    case .video(let video):
                        ShareLink(item: video) {
                            VStack(spacing: 4) {
                                Image(systemName: "square.and.arrow.up")
                                    .font(.title2)
                                    .foregroundColor(.white)
                                Text(L10n.coreButtonShare)
                                    .font(.caption2)
                            }
                            .frame(maxWidth: 100, maxHeight: 100)
                        }
                    case .none:
                        Text("none")
                    }
                    Spacer()
                }
                .padding()
            }
            .frame(height: 80)
        }
    }

    private var closeButton: some View {
        Button(action: {
            dismiss()
        }, label: {
            Image(systemName: "xmark")
            //                .font(.title2)
                .frame(width: 8, height: 8)
                .foregroundColor(.black)
                .padding()
                .background(.white)
                .clipShape(Circle())

        })
        .padding()
    }

    private var saveButton: some View {
        Button(action: {
            viewModel.saveMediaToAlbum()
            isSaved = true
        }, label: {
            VStack(spacing: 4) {
                Image(systemName: !isSaved ? "arrow.down.to.line.compact" : "checkmark")
                    .font(.title2)
                    .foregroundColor(.white)
                Text(!isSaved ? L10n.coreButtonSave : L10n.coreButtonSaved)
                    .font(.caption2)
            }
            .frame(maxWidth: 100, maxHeight: 100)
        })
    }

    private var instagramButton: some View {
        Button(action: {
            viewModel.shareToInstagram()
        }, label: {
            VStack(spacing: 4) {
                Image("instagram")
                    .font(.title2)
                    .foregroundColor(.white)
                Text("Instagram")
                    .font(.caption2)
            }
            .frame(maxWidth: 100, maxHeight: 100)
        })
    }
}
