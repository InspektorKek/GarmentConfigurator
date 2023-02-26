import SwiftUI
import AVFoundation

struct CameraScreenView: View {
    @StateObject var viewModel: CameraScreenViewModel

    var body: some View {
        content
            .onAppear {
                viewModel.send(.onAppear)
            }
    }

    private var content: some View {

        ZStack {
            CameraPreview(viewModel: viewModel)
                .ignoresSafeArea()

            VStack {
                if viewModel.model.isTaken {
                    HStack {
//                        Spacer()

                        Button {
                            viewModel.reTake()
                        } label: {
                            Image(systemName: "chevron.backward")
                                .foregroundColor(.black)
                                .padding()
                                .background(Color.white)
                                .clipShape(Circle())
                        }

                        Spacer()
                    }

                }

                Spacer()

                ZStack {
                    if viewModel.model.isTaken {
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundColor(.gray.opacity(0.4))
                            .ignoresSafeArea()
                    }

                    HStack {
                        // if taken showing save and again take button
                        Spacer()

                        if viewModel.model.isTaken {
                            Button {
                                if !viewModel.model.isSaved {
                                    viewModel.savePic()
                                }
                            } label: {
                                Image(systemName: viewModel.model.isSaved ? "checkmark" : "square.and.arrow.down")
                                    .foregroundColor(.black)
                                    .padding()
                                    .background(Color.white)
                                    .clipShape(Circle())
                            }
                            .padding()

                            Spacer()

                            Button {
                                //
                            } label: {
                                Image("instagram")
                                    .foregroundColor(.black)
                                    .padding()
                                    .background(Color.white)
                                    .clipShape(Circle())
                            }
                            .padding()

                            Spacer()

                            Button {
                                //
                            } label: {
                                Image(systemName: "square.and.arrow.up")
                                    .foregroundColor(.black)
                                    .padding()
                                    .background(Color.white)
                                    .clipShape(Circle())
                            }
                            .padding()

                            Spacer()

                        } else {
                            Button {
                                viewModel.takePic()
                            } label: {
                                ZStack {
                                    Circle()
                                        .fill(Color.white)
                                        .frame(width: 65, height: 65)

                                    Circle()
                                        .stroke(Color.white, lineWidth: 2)
                                        .frame(width: 70, height: 70)
                                }
                            }
                        }
                    }
                }
                .frame(height: 75)
            }
        }
        .onAppear {
            viewModel.checkPermission()
        }
    }
}

struct CameraPreview: UIViewRepresentable {
    @ObservedObject var viewModel: CameraScreenViewModel

    let view = UIView(frame: UIScreen.main.bounds)

    func makeUIView(context: Context) -> some UIView {

        view.layer.addSublayer(setupCapturePreview())

        Task.detached {
            await viewModel.model.session.startRunning()
        }
        return view
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {

    }

    private func setupCapturePreview() -> AVCaptureVideoPreviewLayer {
        let capturePreview = AVCaptureVideoPreviewLayer(session: viewModel.model.session)
        capturePreview.frame = view.frame
        capturePreview.videoGravity = .resizeAspectFill
        return capturePreview
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CameraScreenView(viewModel: CameraScreenViewModel())
    }
}
