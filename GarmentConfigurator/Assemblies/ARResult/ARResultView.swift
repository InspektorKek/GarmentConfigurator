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
        //        NavigationStack {
        VStack {
            ZStack(alignment: .topLeading) {
                switch viewModel.mediaType {
                case .image(let image):
                    Image(uiImage: image)
                        .resizable()
                    //                        .edgesIgnoringSafeArea(.bottom)
                case .none:
                    Text("nothing")
                case .video(let video):
                    VideoPlayer(player: viewModel.player)
//                        .scaledToFill()
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
//                        .padding()
                }

            }

//            .clipShape(RoundedRectangle(cornerRadius: 32))
            .cornerRadius(32)

            Spacer()

            ZStack {
                //                RoundedRectangle(cornerRadius: 20)
                //                    .foregroundColor(.gray.opacity(0.4))
                //                    .ignoresSafeArea()
                //                    .edgesIgnoringSafeArea(.bottom)

//                HStack(spacing: 64) {
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
//                                    .padding()
//                                    .background(Color.white)
//                                    .clipShape(Circle())
                                Text("Share")
                                    .font(.caption2)
                            }
                        }

                    case .video(let video):
                        ShareLink(item: video) {
                            VStack(spacing: 4) {
                                Image(systemName: "square.and.arrow.up")
                                    .font(.title2)
                                    .foregroundColor(.white)
//                                    .padding()
//                                    .background(Color.white)
//                                    .clipShape(Circle())
                                Text("Share")
                                    .font(.caption2)
                            }
                        }
                    case .none:
                        Text("none")
                    }
                    Spacer()
                }
                .padding()
//                .padding(.top, 30)
            }
            .frame(height: 80)
        }
        //            }
        //            .navigationTitle("welcome")
        //            .toolbar {
        //                ToolbarItem(placement: .navigationBarLeading) {
        //                    backButton
        //                }
        //            }
        //        }
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

//    private var shareButton: some View {
//        Button(action: {
//            print("test")
//            //            viewModel.shareItem()
//            switch viewModel.mediaType {
//            case .image(let image):
//                print("image share")
//                let items: [Any] = [image]
//                let shareSheet = UIActivityViewController(activityItems: items, applicationActivities: nil)
//                UIApplication.shared.windows.first?.rootViewController?.presentedViewController?.present(
//                    shareSheet,
//                    animated: true,
//                    completion: nil)
//            case .video(let video):
//                print("video share")
//                let items: [Any] = [video.path]
//                let shareSheet = UIActivityViewController(activityItems: items, applicationActivities: nil)
//                UIApplication.shared.windows.first?.rootViewController?.presentedViewController?.present(
//                    shareSheet,
//                    animated: true,
//                    completion: nil)
//            case .none:
//                print("non")
//            }
//        }, label: {
//            Image(systemName: "square.and.arrow.up")
//                .foregroundColor(.black)
//                .padding()
//                .background(Color.white)
//                .clipShape(Circle())
//        })
//    }

    private var saveButton: some View {
        Button(action: {
            viewModel.saveMediaToAlbum()
            isSaved = true
        }, label: {
            VStack(spacing: 4) {
                Image(systemName: !isSaved ? "arrow.down.to.line.compact" : "checkmark")
                    .font(.title2)
                    .foregroundColor(.white)
//                    .padding()
//                    .background(Color.white)
//                    .clipShape(Circle())
                Text(!isSaved ? "Save" : "Saved")
                    .font(.caption2)
            }
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
//                    .padding()
//                    .background(Color.white)
//                    .clipShape(Circle())

                Text("Instagram")
                    .font(.caption2)
            }
        })
    }
}
