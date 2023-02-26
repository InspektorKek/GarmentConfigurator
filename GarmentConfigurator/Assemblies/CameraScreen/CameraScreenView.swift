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
                        Spacer()

                        Button {
                            viewModel.reTake()
                        } label: {
                            Image(systemName: "arrow.triangle.2.circlepath.camera")
                                .foregroundColor(.black)
                                .padding()
                                .background(Color.white)
                                .clipShape(Circle())
                        }
                    }

                }
                Spacer()

                HStack {

                    // if taken showing save and again take button

                    if viewModel.model.isTaken {
                        Button {
                            if !viewModel.model.isSaved {
                                viewModel.savePic()
                            }
                        } label: {
                            Text(viewModel.model.isSaved ? "Saved" : "Save")
                                .foregroundColor(.black)
                                .fontWeight(.semibold)
                                .padding(.vertical, 10)
                                .padding(.horizontal, 20)
                                .background(Color.white)
                                .clipShape(Capsule())
                        }
                        .padding(.leading)

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
                .frame(height: 75)
            }
        }
        .onAppear {
            viewModel.checkPermission()
        }
    }

}

struct CameraPreview: UIViewRepresentable {
    @StateObject var viewModel: CameraScreenViewModel

    let view = UIView(frame: UIScreen.main.bounds)

    func makeUIView(context: Context) -> some UIView {

        view.layer.addSublayer(setupCapturePreview())

        Task.detached {
            await viewModel.model.session.startRunning()
        }
        return view }

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
