import Foundation

protocol ConfigurationContainerDelegate: AnyObject, BackNavigator {

}

protocol ConfigurationSceneDelegate: AnyObject, AlertPresentable, ImagePickerPresentable {
    func back()
}

struct ConfigurationSceneInput {
    let model: GarmentModel
}
