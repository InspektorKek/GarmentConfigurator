//
//  CameraScreenModel.swift
//  GarmentConfigurator
//
//  Created by Aleksandr Shapovalov on 26/02/23.
//

import Foundation
import AVFoundation

class CameraModel: NSObject, ObservableObject, AVCapturePhotoCaptureDelegate {

    @Published var isTaken = false

    @Published var session = AVCaptureSession()

    @Published var alert = false

    @Published var output = AVCapturePhotoOutput()

    @Published var isSaved = false

    @Published var picData = Data(count: 0)
}
