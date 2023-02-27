import Foundation

enum ConfigurationFlow {
    enum ViewState {
        case idle
        case loading
        case error(message: String)
    }

    enum Event {
        case onAppear
        case onNextScene
    }
}
