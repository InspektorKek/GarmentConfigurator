//
//  ARViewModel.swift
//  ARTestCapture
//
//  Created by Aleksandr Shapovalov on 27/02/23.
//

import SwiftUI
import RealityKit

enum ARResultMediaType: Equatable {
    case none
    case image(UIImage)
    case video(URL)
}

class ARScreenViewModel: ObservableObject {
    var mediaType: ARResultMediaType?

    @Published var shouldShowResult: Bool = false
    @Published var isRecording: Bool = false

    deinit {
        print("deinit ARScreenViewModel")
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

    func startCapturingVideo() {
          do {
              try ARVariables.arView.startVideoRecording()
          } catch {
              print(error)
          }
      }

    func stopCapturingVideo() {
        ARVariables.arView.finishVideoRecording { [weak self] videoRecording in
            self?.mediaType = .video(videoRecording.url)
            self?.shouldShowResult = true
        }
    }
}
