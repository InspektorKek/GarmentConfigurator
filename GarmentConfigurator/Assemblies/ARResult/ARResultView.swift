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
        NavigationStack {
            ZStack {
                switch viewModel.mediaType {
                case .image(let image):
                    Image(uiImage: image)
                        .resizable()
//                        .ignoresSafeArea()
                        .edgesIgnoringSafeArea(.bottom)
                case .none:
                    Text("nothing")
                case .video(let video):
                    VideoPlayer(player: viewModel.player)
//                        .ignoresSafeArea()
                        .edgesIgnoringSafeArea(.bottom)
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
//                        backButton
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
                            //                                                shareButton

                            switch viewModel.mediaType {
                            case .image(let image):
                                ShareLink(item: Image(uiImage: image),
                                          preview: SharePreview("Image", image: Image(uiImage: image))) {
                                    Text("image")
                                }

                            case .video(let video):
                                ShareLink(item: video) {
                                    Image(systemName: "square.and.arrow.up")
                                        .foregroundColor(.black)
                                        .padding()
                                        .background(Color.white)
                                        .clipShape(Circle())
                                }
                            case .none:
                                Text("none")
                            }

                        }
                        .padding()
                        .padding(.top, 30)
                    }
                    .frame(height: 80)
                }
            }
//            .navigationTitle("welcome")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    backButton
                }
            }
        }
    }

    private var backButton: some View {
        Button(action: {
            dismiss()
        }, label: {
            Image(systemName: "chevron.backward")
//                .foregroundColor(Color(Asset.Colors.labelsPrimary.color))
                .foregroundColor(.black)
                .padding()
                .background(.white)
                .clipShape(Circle())
        })
        .padding()
    }

        private var shareButton: some View {
            Button(action: {
                print("test")
    //            viewModel.shareItem()
                    switch viewModel.mediaType {
                    case .image(let image):
                        print("image share")
                        let items: [Any] = [image]
                        let shareSheet = UIActivityViewController(activityItems: items, applicationActivities: nil)
                        UIApplication.shared.windows.first?.rootViewController?.presentedViewController?.present(
                            shareSheet,
                            animated: true,
                            completion: nil)
                    case .video(let video):
                        print("video share")
                        let items: [Any] = [video.path]
                        let shareSheet = UIActivityViewController(activityItems: items, applicationActivities: nil)
                        UIApplication.shared.windows.first?.rootViewController?.presentedViewController?.present(
                            shareSheet,
                            animated: true,
                            completion: nil)
                    case .none:
                        print("non")
                    }
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
