import Foundation

protocol ConfigurationContainerDelegate: BackNavigator {

}

protocol ConfigurationSceneDelegate: AnyObject, AlertPresentable {
    func back()
}
