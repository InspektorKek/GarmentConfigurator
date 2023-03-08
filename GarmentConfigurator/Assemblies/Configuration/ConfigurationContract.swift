import Foundation

protocol ConfigurationContainerDelegate: AnyObject, BackNavigator {
    func openAR()
}

protocol ConfigurationSceneDelegate: AnyObject, AlertPresentable, ImagePickerPresentable {
    func openAR(input: GarmentModel)
    func back()
}

struct ConfigurationSceneInput {
    let model: GarmentModel
}
