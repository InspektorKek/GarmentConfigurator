//
//  ARViewModel.swift
//  ARTestCapture
//
//  Created by Aleksandr Shapovalov on 27/02/23.
//

import SwiftUI
import RealityKit
import Combine

enum ARResultMediaType: Equatable {
    case none
    case image(UIImage)
    case video(URL)
}

enum Capture {
    static let limitedTime: Double = 60.00
}

class ARScreenViewModel: ObservableObject {
    weak var delegate: ARScreenSceneDelegate?
    weak var navigationVC: ARScreenNavigationVC?

    @Published private(set) var state: ARScreenFlow.ViewState = .idle

    // MARK: - Private Properties

    private let eventSubject = PassthroughSubject<ARScreenFlow.Event, Never>()
    private let stateValueSubject = CurrentValueSubject<ARScreenFlow.ViewState, Never>(.idle)
    private var subscriptions = Set<AnyCancellable>()

    var mediaType: ARResultMediaType?

    @Published var shouldShowResult: Bool = false
    @Published var isRecording: Bool = false
    @Published var labelText: String = "0"
    @Published var progressValue: CGFloat = 0.0

    init() {
        bindInput()
        bindOutput()
    }

    deinit {
        subscriptions.forEach { $0.cancel() }
        subscriptions.removeAll()
    }

    func send(_ event: ARScreenFlow.Event) {
        eventSubject.send(event)
    }

    private func bindInput() {
        eventSubject
            .sink { [weak self] event in
                switch event {
                case .onAppear:
                    self?.objectWillChange.send()
                case .onNextScene:
//                        self?.delegate?.openARResult()
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

        func takePhoto() {
            ARVariables.arView.takePhotoResult { [weak self] result in
                switch result {
                case .success(let image):
                    print("image taken")
                    self?.mediaType = .image(image)
                    self?.shouldShowResult = true
                case .failure(let error):
                    print(error)
                }
            }
        }

        //    func startCapturingVideo() {
        //          do {
        //              try ARVariables.arView.startVideoRecording()
        //              isRecording = true
        //          } catch {
        //              isRecording = false
        //              print(error)
        //          }
        //      }

        func startCapturingVideo() {
            DispatchQueue.global().async {
                do {
                    let videoCapture = try ARVariables.arView.startVideoRecording()
                    DispatchQueue.main.async {
                        self.isRecording = true
                    }

                    let formatted: (TimeInterval) -> String = {
                      let seconds = Int($0)
                      return String(format: "%02d:%02d", seconds / 60, seconds % 60)
                    }

                    videoCapture.$duration.observe(on: .main) { [weak self] duration in
                        if duration < Capture.limitedTime {
                            DispatchQueue.main.async {
                                self?.labelText = formatted(duration)
                                self?.progressValue = CGFloat(duration / 60)
                            }
                        } else {
                            DispatchQueue.main.async {
                                self?.stopCapturingVideo()
                            }
                        }
                    }
                } catch {
                    DispatchQueue.main.async {
                        self.isRecording = false
                        self.stopCapturingVideo()
                    }
                    print(error)
                }
            }
        }

        func stopCapturingVideo() {
            isRecording = false
            ARVariables.arView.finishVideoRecording { [weak self] videoRecording in
                self?.mediaType = .video(videoRecording.url)
                self?.shouldShowResult = true
                self?.progressValue = 0.0
            }
        }
    }

    extension ARScreenViewModel: ARScreenContainerDelegate {
        func back() {
            delegate?.back()
        }
    }
