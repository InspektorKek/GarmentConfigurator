import Foundation

protocol ARScreenContainerDelegate: AnyObject, BackNavigator {
}

protocol ARScreenSceneDelegate: AnyObject, AlertPresentable {
    func back()
//    func openARResult()
}
