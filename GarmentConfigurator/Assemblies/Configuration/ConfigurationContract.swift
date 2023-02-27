import Foundation

protocol ConfigurationContainerDelegate: AnyObject, BackNavigator {

}

protocol ConfigurationSceneDelegate: AnyObject, AlertPresentable {
    func back()
}
