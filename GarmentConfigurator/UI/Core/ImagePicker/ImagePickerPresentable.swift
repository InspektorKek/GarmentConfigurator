//
//  ImagePickerPresentable.swift
//  GarmentConfigurator
//
//  Created by Mikhail Borisov on 08/03/23.
//

import UIKit

protocol ImagePickerPresentable {
    func openImagePicker(updateHandler: @escaping ((UIImage) -> Void), removeHandler: (() -> Void)?)
}

extension ImagePickerPresentable where Self: BaseCoordinator {
    func openImagePicker(updateHandler: @escaping ((UIImage) -> Void), removeHandler: (() -> Void)?) {
        let openCameraAction = UIAlertAction(title: L10n.coreButtonOpenCamera, style: .default ) { [weak self] _ in
            self?.openImagePicker(source: ImagePickerCoordinator.Source.camera, updateHandler: updateHandler)
        }
        
        let openGalleryAction = UIAlertAction(title: L10n.coreButtonOpenGallery, style: .default) { [weak self] _ in
            self?.openImagePicker(source: ImagePickerCoordinator.Source.photoLibrary, updateHandler: updateHandler)
        }
        let removePhotoAction = UIAlertAction(title: L10n.coreButtonRemovePhoto, style: .destructive) { _ in
            removeHandler?()
        }
        let cancelAction = UIAlertAction(title: L10n.coreButtonCancel, style: .cancel)
        
        let actions: [UIAlertAction]
        if removeHandler == nil {
            actions = [openCameraAction, openGalleryAction, cancelAction]
        } else {
            actions = [openCameraAction, openGalleryAction, removePhotoAction, cancelAction]
        }
        
        let alert = Alert(
            title: nil,
            message: nil,
            style: .actionSheet,
            actions: actions
        )
        router.topViewController?.presentAlert(alert)
    }
    
    func openImagePicker(source: ImagePickerCoordinator.Source, updateHandler: @escaping ((UIImage) -> Void)) {
        guard let root = router.root else { return }
        let picker = ImagePickerCoordinator(
            root: root,
            source: source
        )
        picker.onEvent = { [weak self] pickerEvent in
            if case let .userDidSelect(image: image) = pickerEvent {
                self?.openImageCropper(image: image, onResult: updateHandler)
            }
            self?.remove(picker)
        }
        add(picker)
        picker.start()
    }

    func openImageCropper(image: UIImage, onResult: @escaping ((UIImage) -> Void)) {
        guard let root = router.root else { return }
        let cropper = ImageCropperCoordinator(
            root: root,
            originalImage: image
        )
        cropper.onResult = { [weak self] image in
            onResult(image)
            self?.remove(cropper)
        }
        add(cropper)
        cropper.start()
    }
}

