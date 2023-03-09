import Foundation

enum GarmentsFlow {
    enum ViewState {
        case idle
        case loading
        case error(message: String)
    }

    enum Event {
        case onAppear
        case onTap(model: GarmentModel)
    }
}
