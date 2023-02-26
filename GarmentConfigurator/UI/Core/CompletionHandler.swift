//
//  CompletionHandler.swift
//  GarmentConfigurator
//
//  Created by Mikhail Borisov on 24/02/23.
//

import Foundation

typealias EmptyCompletionHandler = () -> Void
typealias BoolCompletionHandler = (Bool) -> Void
typealias StringCompletionHandler = (String) -> Void
typealias EmptyResponseCompletion = (Result<Void, Error>) -> Void
