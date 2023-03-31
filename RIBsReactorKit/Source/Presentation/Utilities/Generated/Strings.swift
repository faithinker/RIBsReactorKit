// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum Strings {
  internal enum Common {
    /// Close
    internal static let close = Strings.tr("Localizable", "common.close", fallback: "Close")
  }
  internal enum TabBarTitle {
    /// Localizable.strings
    ///   RIBsReactorKit
    /// 
    ///   Created by elon on 2021/03/01.
    ///   Copyright © 2021 Elon. All rights reserved.
    internal static let collection = Strings.tr("Localizable", "tabBarTitle.collection", fallback: "Collection")
    /// List
    internal static let list = Strings.tr("Localizable", "tabBarTitle.list", fallback: "List")
  }
  internal enum Unit {
    /// %i
    internal static func age(_ p1: Int) -> String {
      return Strings.tr("Localizable", "unit.age", p1, fallback: "%i")
    }
  }
  internal enum UserCollection {
    /// User Collection
    internal static let title = Strings.tr("Localizable", "userCollection.title", fallback: "User Collection")
  }
  internal enum UserInfoTitle {
    /// Age
    internal static let age = Strings.tr("Localizable", "userInfoTitle.age", fallback: "Age")
    /// Basic Information
    internal static let basicInfo = Strings.tr("Localizable", "userInfoTitle.basicInfo", fallback: "Basic Information")
    /// Birthday
    internal static let birthday = Strings.tr("Localizable", "userInfoTitle.birthday", fallback: "Birthday")
    /// gender
    internal static let gender = Strings.tr("Localizable", "userInfoTitle.gender", fallback: "gender")
  }
  internal enum UserList {
    /// User List
    internal static let title = Strings.tr("Localizable", "userList.title", fallback: "User List")
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension Strings {
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
