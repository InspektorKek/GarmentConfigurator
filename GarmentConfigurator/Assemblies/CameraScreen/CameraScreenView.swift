import SwiftUI
import AVFoundation

struct CameraScreenView: View {
    @StateObject var camera: CameraScreenViewModel

    var body: some View {
        content
            .onAppear {
                camera.send(.onAppear)
            }
    }

    private var content: some View {

        ZStack {

            CameraPreview(camera: camera)
                .ignoresSafeArea()

            VStack {
                if camera.model.isTaken {
                    HStack {
                        Spacer()

                        Button {
                            camera.reTake()
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

                    if camera.model.isTaken {
                        Button {
                            if !camera.model.isSaved {
                                camera.savePic()
                            }
                        } label: {
                            Text(camera.model.isSaved ? "Saved" : "Save")
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
                            camera.takePic()
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
            camera.checkPermission()
        }
    }

}

struct CameraPreview: UIViewRepresentable {
    @StateObject var camera: CameraScreenViewModel

    let view = UIView(frame: UIScreen.main.bounds)

    func makeUIView(context: Context) -> some UIView {

        view.layer.addSublayer(setupCapturePreview())

        Task.detached {
            await camera.model.session.startRunning()
        }
        return view }

    func updateUIView(_ uiView: UIViewType, context: Context) {

    }

    private func setupCapturePreview() -> AVCaptureVideoPreviewLayer {
        let capturePreview = AVCaptureVideoPreviewLayer(session: camera.model.session)
        capturePreview.frame = view.frame
        capturePreview.videoGravity = .resizeAspectFill
        return capturePreview
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CameraScreenView(camera: CameraScreenViewModel())
    }
}
