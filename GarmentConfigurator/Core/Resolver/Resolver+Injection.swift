//
//  Resolver+Injection.swift
//  GarmentConfigurator
//
//  Created by Mikhail Borisov on 24/02/23.
//

import Resolver

extension Resolver: ResolverRegistering {
    public static func registerAllServices() {
        registerServices()
    }
}
