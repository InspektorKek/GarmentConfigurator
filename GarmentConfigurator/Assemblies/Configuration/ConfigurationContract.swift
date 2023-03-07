import Foundation

protocol ConfigurationContainerDelegate: AnyObject, BackNavigator {

}

protocol ConfigurationSceneDelegate: AnyObject, AlertPresentable {
    func back()
}

struct ConfigurationSceneInput {
    let model: GarmentModel
}
