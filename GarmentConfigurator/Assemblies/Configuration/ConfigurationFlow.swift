import Foundation

enum ConfigurationFlow {
    enum ViewState {
        case idle
        case loading
        case error(message: String)
    }

    enum Event {
        case onAppear
        case apply(material: ImageMaterial, pattern: TShirtPatternInfo)
        case onChangeScale(value: Float, pattern: TShirtPatternInfo)
        case onChangeRotation(value: Float, pattern: TShirtPatternInfo)
        case addOwnMaterial(pattern: TShirtPatternInfo)
    }
}
