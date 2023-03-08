import Foundation

protocol ARResultContainerDelegate: AnyObject, BackNavigator {
}

protocol ARResultSceneDelegate: AnyObject, AlertPresentable {
    func back()
}
