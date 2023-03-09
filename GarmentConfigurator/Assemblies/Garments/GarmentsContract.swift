import Foundation

protocol GarmentsContainerDelegate: AnyObject {
    func addActionTapped()
}

protocol GarmentsSceneDelegate: AnyObject {
    func openConfigurator(input: ConfigurationSceneInput)
}
