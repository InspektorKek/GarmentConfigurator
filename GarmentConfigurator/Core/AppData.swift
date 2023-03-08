//
//  AppData.swift
//  GarmentConfigurator
//
//  Created by Mikhail Borisov on 08/03/23.
//

import Foundation

@propertyWrapper struct UserDefaultsBacked<Value> {
    var wrappedValue: Value {
        get {
            let value = storage.value(forKey: key) as? Value
            return value ?? defaultValue
        }
        set {
            storage.setValue(newValue, forKey: key)
        }
    }

    private let key: String
    private let defaultValue: Value
    private let storage: UserDefaults

    init(wrappedValue defaultValue: Value,
         key: String,
         storage: UserDefaults = .standard) {
        self.defaultValue = defaultValue
        self.key = key
        self.storage = storage
    }
}

struct AppData {
    @UserDefaultsBacked<Bool>(key: "is_welcome_screen_shown")
    static var isWelcomeScreenShown: Bool = false
    
    @UserDefaultsBacked<[String]>(key: "image_material_ids")
    static var imageMaterialIDs: [String] = []
}
