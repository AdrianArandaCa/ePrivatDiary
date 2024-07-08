//
//  PageDataSource.swift
//  ePrivatDiary
//
//  Created by Adrian Aranda Campanario on 7/7/24.
//

import Foundation
import SwiftData

enum DatabaseError: Error {
    case errorInsert
    case errorFetch
    case errorUpdate
    case errorRemove
}

protocol PageDataSourceProtocol {
    func fetchAll() throws -> [PageModel]
    func update(identifier: UUID, title: String, textEncrypted: Data?, feedback: Feedback) throws
    func remove(identifier: UUID) throws
    func insert(page: PageModel) throws
}

class PageDataSource: PageDataSourceProtocol {
    static let shared: PageDataSource = PageDataSource()
    
    @MainActor
    var container: ModelContainer = setupContainer(inMemory: false)
    
    private init() { }
    
    @MainActor
    static func setupContainer(inMemory: Bool) -> ModelContainer {
        do {
            let container = try ModelContainer(for: PageModel.self, configurations: ModelConfiguration(isStoredInMemoryOnly: inMemory))
            container.mainContext.autosaveEnabled = true
            return container
        } catch {
            print("Error \(error.localizedDescription)")
            fatalError()
        }
    }
    
    @MainActor
    func fetchAll() throws -> [PageModel] {
        let fetchDescriptor = FetchDescriptor<PageModel>(sortBy: [SortDescriptor<PageModel>(\.createdAt)])
        do {
            return try container.mainContext.fetch(fetchDescriptor)
        } catch {
            print("Error \(error.localizedDescription)")
            throw DatabaseError.errorFetch
        }
    }
    
    @MainActor
    func insert(page: PageModel) throws {
        container.mainContext.insert(page)
        do {
            try container.mainContext.save()
        } catch {
            print("Error \(error.localizedDescription)")
            throw DatabaseError.errorInsert
        }
    }
    
    @MainActor
    func update(identifier: UUID, title: String, textEncrypted: Data?, feedback: Feedback) throws {
        let id = identifier
        let pagePredicate = #Predicate<PageModel> {
            $0.identifier == id
        }
        
        var fetchDescriptor = FetchDescriptor<PageModel>(predicate: pagePredicate)
        fetchDescriptor.fetchLimit = 1
        
        do {
            guard let updatePage = try container.mainContext.fetch(fetchDescriptor).first else {
                throw DatabaseError.errorUpdate
            }
            
            updatePage.title = title
            updatePage.encripted = textEncrypted
            updatePage.feedback = feedback
            
            try container.mainContext.save()
        } catch {
            print("Error \(error.localizedDescription)")
            throw DatabaseError.errorUpdate
        }
    }
    
    @MainActor
    func remove(identifier: UUID) throws {
        let pagePredicate = #Predicate<PageModel> {
            $0.identifier == identifier
        }
        
        var fetchDescriptor = FetchDescriptor<PageModel>(predicate: pagePredicate)
        fetchDescriptor.fetchLimit = 1
        
        do {
            guard let deletePage = try container.mainContext.fetch(fetchDescriptor).first else {
                throw DatabaseError.errorRemove
            }
            
            container.mainContext.delete(deletePage)
            try container.mainContext.save()
        } catch {
            print("Error \(error.localizedDescription)")
            throw DatabaseError.errorRemove
        }
    }
}
