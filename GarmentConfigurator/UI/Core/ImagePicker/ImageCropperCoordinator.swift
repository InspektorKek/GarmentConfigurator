//
//  ImageCropperCoordinator.swift
//  GarmentConfigurator
//
//  Created by Mikhail Borisov on 08/03/23.
//

import UIKit
import CropViewController

final class ImageCropperCoordinator: NSObject, Coordinator {
    weak var startingViewController: UIViewController?
    weak var parent: Coordinator?
    private(set) var children: [Coordinator] = []

    /// Closure for handle user actions inside presented cropper
    var onResult: ((UIImage) -> Void)?
    private let rootController: UIViewController
    private let originalImage: UIImage
    private let isCircularCropperStyle: Bool

    init(
        root: UIViewController,
        originalImage: UIImage,
        isCircularCropperStyle: Bool = false
    ) {
        self.rootController = root
        self.originalImage = originalImage
        self.isCircularCropperStyle = isCircularCropperStyle
        super.init()
    }

    func start() {
        let cropController = CropViewController(
            croppingStyle: isCircularCropperStyle ? .circular : .default,
            image: originalImage
        )
        cropController.delegate = self
        cropController.aspectRatioPreset = .presetSquare
        cropController.aspectRatioPickerButtonHidden = true
        cropController.resetAspectRatioEnabled = false
        rootController.present(cropController, animated: true)
    }

    /// Don't call this method. Current coordinator shouldn't have child coordinators
    func add(_ child: Coordinator) {
        fatalError(file: "ImagePickerCoordinator shouldn't have child coordinators")
    }

    /// Don't call this method. Current coordinator shouldn't have child coordinators
    func remove(_ child: Coordinator) {
        fatalError(file: "ImagePickerCoordinator shouldn't have child coordinators")
    }
}

extension ImageCropperCoordinator: CropViewControllerDelegate {
    func cropViewController(
        _ cropViewController: CropViewController,
        didCropToImage image: UIImage,
        withRect cropRect: CGRect,
        angle: Int
    ) {
        updateImageViewWithImage(image, fromCropViewController: cropViewController)
    }

    func cropViewController(
        _ cropViewController: CropViewController,
        didCropToCircularImage image: UIImage,
        withRect cropRect: CGRect,
        angle: Int
    ) {
        updateImageViewWithImage(image, fromCropViewController: cropViewController)
    }

    func updateImageViewWithImage(
        _ image: UIImage,
        fromCropViewController cropViewController: CropViewController
    ) {
        cropViewController.dismiss(animated: true, completion: nil)
        onResult?(image)
    }
}

