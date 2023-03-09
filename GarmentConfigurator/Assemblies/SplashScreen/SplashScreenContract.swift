import Foundation

protocol SplashScreenContainerDelegate: AnyObject {

}

protocol SplashScreenSceneDelegate: AnyObject {
    func startMainFlow()
    // MARK: in case if we would need to open safari inside app
//    func openURL(_ url: URL)
}
