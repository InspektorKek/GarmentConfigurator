//
//  Resolver+Services.swift
//  GarmentConfigurator
//
//  Created by Mikhail Borisov on 24/02/23.
//

import Resolver
import Foundation

extension Resolver {
    public static func registerServices() {
        register { NotificationCenter.default }.implements(NotificationCenterProtocol.self)
        register { UserDefaults.standard }
        register { ImageDataMaterialsService() }
            .implements((any MaterialManagingProtocol).self)
    }
}
