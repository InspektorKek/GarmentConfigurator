// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  /// Continue
  internal static let coreButtonContinue = L10n.tr("Localizable", "coreButtonContinue", fallback: "Continue")
  /// Save
  internal static let coreButtonSave = L10n.tr("Localizable", "coreButtonSave", fallback: "Save")
  /// Saved
  internal static let coreButtonSaved = L10n.tr("Localizable", "coreButtonSaved", fallback: "Saved")
  /// Share
  internal static let coreButtonShare = L10n.tr("Localizable", "coreButtonShare", fallback: "Share")
  /// OK
  internal static let coreOkButton = L10n.tr("Localizable", "coreOkButton", fallback: "OK")
  /// Garments
  internal static let titleGarments = L10n.tr("Localizable", "titleGarments", fallback: "Garments")
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
