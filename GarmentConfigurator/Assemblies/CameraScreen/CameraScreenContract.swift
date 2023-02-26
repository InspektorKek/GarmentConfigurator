import Foundation

protocol CameraScreenContainerDelegate: BackNavigator {
    func onRightBarButtonTap()
}

protocol CameraScreenSceneDelegate: AnyObject, AlertPresentable, ConfirmationSheetPresenter {
    func back()
}
