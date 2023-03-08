//
//  FilesManager.swift
//  GarmentConfigurator
//
//  Created by Mikhail Borisov on 08/03/23.
//

import Foundation

class FilesManager {
    enum Error: Swift.Error {
        case fileAlreadyExists
        case invalidDirectory
        case writtingFailed
        case fileNotExists
        case readingFailed
    }
    
    static let shared: FilesManager = FilesManager()
    
    private let fileManager: FileManager
    
    init() {
        self.fileManager = .default
    }
    
    func save(fileNamed: String, data: Data) throws {
        guard let url = Self.makeURL(forFileNamed: fileNamed) else {
            throw Error.invalidDirectory
        }
        if fileManager.fileExists(atPath: url.path()) {
            throw Error.fileAlreadyExists
        }
        do {
            try data.write(to: url)
        } catch {
            debugPrint(error)
            throw Error.writtingFailed
        }
    }
    
    func read(fileNamed: String) throws -> Data {
        guard let url = Self.makeURL(forFileNamed: fileNamed) else {
            throw Error.invalidDirectory
        }
        guard fileManager.fileExists(atPath: url.path()) else {
            throw Error.fileNotExists
        }
        do {
            return try Data(contentsOf: url)
        } catch {
            debugPrint(error)
            throw Error.readingFailed
        }
    }
    
    static func makeURL(forFileNamed fileName: String) -> URL? {
        guard let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        return url.appendingPathComponent(fileName)
    }
    
}

