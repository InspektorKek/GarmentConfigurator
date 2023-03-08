//
//  ImagePickerCoordinator.swift
//  GarmentConfigurator
//
//  Created by Mikhail Borisov on 08/03/23.
//

import UIKit
import PhotosUI
import Photos
import MobileCoreServices
import AVFoundation

/// User permissions provider for camera and photo library access
fileprivate final class PhotoLibraryAccessProvider {
    private var photoLibraryStatus: PHAuthorizationStatus
    private var cameraStatus: AVAuthorizationStatus

    init() {
        photoLibraryStatus = PHPhotoLibrary.authorizationStatus()
        cameraStatus = AVCaptureDevice.authorizationStatus(for: .video)
    }

    /// Check current *PHPhotoLibrary.authorizationStatus()* and call
    /// *PHPhotoLibrary.requestAuthorization* if current status is .notDetermined
    /// - Parameter completion: permission request handler. Returns *true* if access is granted and false is not
    func checkPhotoPermissionAndRequestIfNeeded(completion: @escaping (_ isGranted: Bool) -> Void) {
        switch photoLibraryStatus {
        case .denied,
             .restricted:
            completion(false)
        case .authorized:
            completion(true)
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { [weak self] status in
                DispatchQueue.main.async {
                    self?.photoLibraryStatus = status
                    completion(status == .authorized)
                }
            }
        case .limited: // shouldn't handle for iOS < iOS 14
            break
        @unknown default:
            break
        }
    }

    /// Check current *AVCaptureDevice.authorizationStatus(for: .video)* and call
    /// *AVCaptureDevice.requestAccess(for: .video)* if current status is .notDetermined
    /// - Parameter completion: permission request handler. Returns *true* if access is granted and false is not
    func checkCameraPermissionAndRequestIfNeeded(completion: @escaping (_ isGranted: Bool) -> Void) {
        switch cameraStatus {
        case .denied,
             .restricted:
            completion(false)
        case .authorized:
            completion(true)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] isGranted in
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    self.cameraStatus = AVCaptureDevice.authorizationStatus(for: .video)
                    completion(isGranted)
                }
            }
        @unknown default:
            break
        }
    }
}

/// Coordinator for present image picker or camera on ViewController.
///
/// **Note:**
/// For Source == .camera and simulator build you should see log message in Xcode console.
///
/// **What's using inside:**
/// For iOS 13 or earlier — *UIImagePickerController* for camera and photo library
/// For iOS 14 or later — *PHPickerViewController* for photo library and *UIImagePickerController* for camera access
///
/// **How handle events:**
/// For handle user actions inside picker — implement *onEvent* closure and process events.
///
///**How to use**:
/// ```
/// let picker = ImagePickerCoordinator(
///        root: rootController,
///        source: .photoLibrary
///    )
/// picker.onEvent = { [weak self] pickerEvent in
///   self.remove(picker)
///   // here process pickerEvent
/// }
/// add(picker)
/// picker.start()
/// ```
final class ImagePickerCoordinator: NSObject, Coordinator {
    weak var parent: Coordinator?
    weak var startingViewController: UIViewController?
    private(set) var children: [Coordinator] = []

    /// Picker output event
    enum Event {
        /// User did dined access.
          /// *PHPhotoLibrary.authorizationStatus()* returns *.denied/.restricted*
        /// or
        /// *AVCaptureDevice.authorizationStatus(for: .video)* returns *.denied/.restricted*
        case userDidDeniedAccess
        /// User pressed cancel button in *UIImagePickerController* or in *PHPickerViewController*
        case userDidCancel
        /// User selected image or take photo from camera
        case userDidSelect(image: UIImage)
    }

    /// Picker data source
    enum Source {
        case camera
        case photoLibrary
    }

    //MARK: - Properties
    /// Closure for handle user actions inside presented picker
    var onEvent: ((Event) -> Void)?

    private let source: Source
    private let rootController: UIViewController
    private let accessProvider: PhotoLibraryAccessProvider

    //MARK: - Initialization
    /// Initialize coordinator
    /// - Parameters:
    ///   - root: UIViewController where present picker
    ///   - source: what should be using as picker data source
    init(root: UIViewController, source: Source) {
        self.source = source
        self.rootController = root
        self.accessProvider = .init()
        super.init()
    }

    // MARK: - Lifecycle
    /// Start picker presentation process
    func start() {
        let pickerSource: UIImagePickerController.SourceType = source == .camera ? .camera : .photoLibrary
        switch source {
        case .camera:
            #if targetEnvironment(simulator)
                print("****** ImagePickerCoordinator tries to open camera on simulator ******")
            #else
                accessProvider.checkCameraPermissionAndRequestIfNeeded { [weak self] isGranted in
                    if isGranted {
                        self?.openLegacyPicker(source: pickerSource)
                    } else {
                        self?.onEvent?(.userDidDeniedAccess)
                        if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
                        }
                    }
                }
            #endif
        case .photoLibrary:
            //openModernPicker()
            #if targetEnvironment(simulator)
                print("****** ImagePickerCoordinator tries to open gallery on simulator ******")
            #else
            accessProvider.checkPhotoPermissionAndRequestIfNeeded { [weak self] isGranted in
                if isGranted {
                    self?.openLegacyPicker(source: pickerSource)
                } else {
                    self?.onEvent?(.userDidDeniedAccess)
                    if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
                    }
                }
            }
            #endif
        }
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

// MARK: - Legacy picker
private extension ImagePickerCoordinator {
    func openLegacyPicker(source: UIImagePickerController.SourceType) {
        let picker = UIImagePickerController()
        picker.isModalInPresentation = true
        picker.modalPresentationStyle = .overFullScreen
        picker.sourceType = source
        picker.delegate = self
        picker.allowsEditing = false
        rootController.present(picker, animated: true)
    }
}

// MARK: - PHImagePicker
private extension ImagePickerCoordinator {
    func openModernPicker() {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 1
        config.preferredAssetRepresentationMode = .current
        let picker = PHPickerViewController(configuration: config)
        picker.modalPresentationStyle = .overFullScreen
        picker.delegate = self

        rootController.present(picker, animated: true)
    }
}

//MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension ImagePickerCoordinator: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(
      _ picker: UIImagePickerController,
      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
    ) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[.originalImage] as? UIImage else {
            onEvent?(.userDidCancel)
            return
        }
        onEvent?(.userDidSelect(image: image))
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
        onEvent?(.userDidCancel)
    }
}

//MARK: - PHPickerViewControllerDelegate
extension ImagePickerCoordinator: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        guard let itemProvider = results.first?.itemProvider else {
            onEvent?(.userDidCancel)
            return
        }
        
        itemProvider.loadObject(ofClass: UIImage.self) { [weak self]  image, error in
            DispatchQueue.main.async {
                guard let imageObject = image as? UIImage else { return }
                self?.onEvent?(.userDidSelect(image: imageObject))
            }
        }
    }
}

