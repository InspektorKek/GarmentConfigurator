import Foundation

protocol ARResultContainerDelegate: BackNavigator {
}

protocol ARResultSceneDelegate: AnyObject, AlertPresentable {
    func back()
}
