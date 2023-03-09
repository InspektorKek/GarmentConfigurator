import Foundation

enum ARResultFlow {
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
