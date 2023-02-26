import Combine
import AVFoundation
import UIKit
import SwiftUI

final class CameraScreenViewModel: NSObject, ObservableObject, AVCapturePhotoCaptureDelegate {
    weak var delegate: CameraScreenSceneDelegate?
    weak var navigationVC: CameraScreenNavigationVC?

    var model = CameraScreenModel()

    @Published private(set) var state: CameraScreenFlow.ViewState = .idle

    // MARK: - Private Properties

    private let eventSubject = PassthroughSubject<CameraScreenFlow.Event, Never>()
    private let stateValueSubject = CurrentValueSubject<CameraScreenFlow.ViewState, Never>(.idle)
    private var subscriptions = Set<AnyCancellable>()

    override init() {
        super.init()
        bindInput()
        bindOutput()
    }

    deinit {
        subscriptions.forEach { $0.cancel() }
        subscriptions.removeAll()
    }

    func send(_ event: CameraScreenFlow.Event) {
        eventSubject.send(event)
    }

    private func bindInput() {
        eventSubject
            .sink { [weak self] event in
                switch event {
                case .onAppear:
                    self?.objectWillChange.send()
                case .onNextScene:
                    print("Next scene")
                }
            }
            .store(in: &subscriptions)
    }

    private func bindOutput() {
        stateValueSubject
            .assign(to: \.state, on: self)
            .store(in: &subscriptions)
    }

    func checkPermission() {
        // first checking camera has got permission
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            setUpVideoView()
            return
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { (status) in
                if status {
                    self.setUpVideoView()
                }
            }
        case .denied:
            self.model.alert.toggle()
            return
        default:
            return
        }
    }

    func setUpVideoView() {
            // setting up camera
            do {
                // setting configs
                self.model.session.beginConfiguration()

                let device = AVCaptureDevice.default(for: .video)

                let input = try AVCaptureDeviceInput(device: device!)

                // checking and adding to session

                if self.model.session.canAddInput(input) {
                    self.model.session.addInput(input)
                }

                // same for output

                if self.model.session.canAddOutput(self.model.output) {
                    self.model.session.addOutput(self.model.output)
                }

                self.model.session.commitConfiguration()
            } catch {

                print(error.localizedDescription)
            }
    }

    func takePic() {

        Task.detached {
            self.model.output.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)

            Task { @MainActor in
                withAnimation {self.model.isTaken.toggle()}
            }

            DispatchQueue.main.async {
                Timer.scheduledTimer(withTimeInterval: 0.01, repeats: false) { (_) in self.model.session.stopRunning() }
            }
        }
    }

    func reTake() {
        Task.detached {
            self.model.session.startRunning()

            Task { @MainActor in
                withAnimation {
                    self.model.isTaken.toggle()
                    self.model.isSaved = false
                }
            }
        }
    }

    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if error != nil {
            return
        }
        print("pic taken")

        guard let imageData = photo.fileDataRepresentation() else {return}
        self.model.picData = imageData
    }

    func savePic() {

        let image = UIImage(data: self.model.picData)!
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        self.model.isSaved = true

        print("saved successfully")
    }

    func shareToInstagram() {
        if let storiesUrl = URL(string: "instagram-stories://share") {
            if UIApplication.shared.canOpenURL(storiesUrl) {
                guard let image = UIImage(data: self.model.picData) else {
                  return }
                guard let imageData = image.jpegData(compressionQuality: 0.8) else { return }
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

extension CameraScreenViewModel: CameraScreenContainerDelegate {
    func back() {
        delegate?.back()
    }

    func onRightBarButtonTap() {

    }
}
