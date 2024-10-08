//
//  PageViewModel.swift
//  ePrivatDiary
//
//  Created by Adrian Aranda Campanario on 7/7/24.
//

import Foundation
import Observation

@Observable
class PageViewModel {
    var pages: [PageModel]
    var datasourceError: DatabaseError?
    var encryptationError: ErrorEncryptation?
    var keyEncryptation: String?
    var showPasswordAlert: Bool = false
    var selectedPage: PageModel?
    
    private var createPageUseCase: CreatePageProtocol
    private var fetchAllPagesUseCase: FetchAllPageProtocol
    private var updatePageUseCase: UpdatePageProtocol
    private var removePageUseCase: RemovePageProtocol
    
    init(pages: [PageModel] = [],
         keyEncryptation: String? = "",
         createPageUseCase: CreatePageProtocol = CreatePageUseCase(),
         fetchAllPagesUseCase: FetchAllPageProtocol = FetchAllPageUseCase(),
         updatePageUseCase: UpdatePageProtocol = UpdatePageUseCase(),
         removePageUseCase: RemovePageProtocol = RemovePageUseCase()) {
        
        self.pages = pages
        self.createPageUseCase = createPageUseCase
        self.fetchAllPagesUseCase = fetchAllPagesUseCase
        self.updatePageUseCase = updatePageUseCase
        self.removePageUseCase = removePageUseCase
        self.keyEncryptation = keyEncryptation
        fetchAllPages()
    }
    
    func fetchAllPages() {
        do {
            pages = try fetchAllPagesUseCase.fetchAll()
        } catch let error as DatabaseError {
            print("Error \(error.localizedDescription)")
            datasourceError = error
        } catch {
            print("Error \(error.localizedDescription)")
        }
    }
    
    func createPage(title: String, text: String?, feedback: Feedback) {
        do {
            let data = encrytationPage(text: text)
            try createPageUseCase.createPage(title: title, text: data, feedback: feedback)
            fetchAllPages()
        } catch let error as DatabaseError {
            print("Error \(error.localizedDescription)")
            datasourceError = error
        } catch let error as ErrorEncryptation {
            print("Error \(error.localizedDescription)")
            encryptationError = error
        } catch {
            print("Error \(error.localizedDescription)")
        }
    }
    
    func updatePage(identifier: UUID, title: String, text: String?, feedback: Feedback) {
        do {
            let data = encrytationPage(text: text)
            try updatePageUseCase.update(identifier: identifier, title: title, textEncrypted: data, feedback: feedback)
            fetchAllPages()
        } catch let error as DatabaseError {
            print("Error \(error.localizedDescription)")
            datasourceError = error
        } catch {
            print("Error \(error.localizedDescription)")
        }
    }
    
    func removePage(identifier: UUID) {
        do {
            try removePageUseCase.remove(identifier: identifier)
            fetchAllPages()
        } catch let error as DatabaseError {
            print("Error \(error.localizedDescription)")
            datasourceError = error
        } catch {
            print("Error \(error.localizedDescription)")
        }
    }
    
    func encrytationPage(text: String?) -> Data? {
        do {
            guard let key = self.keyEncryptation else {
                return nil
            }
            let data = try EncryptationPageUseCase(key: key).encryptationPage(text: text)
            keyEncryptation = ""
            return data
        } catch {
            print("Error \(error.localizedDescription)")
            return nil
        }
    }
    
    func decrytationPage(page: PageModel) -> String? {
        guard let encripted = page.encripted else {
            return nil
        }
        do {
            guard let key = self.keyEncryptation else {
                return nil
            }
            let text = try EncryptationPageUseCase(key: key).decryptationPage(data: encripted)
            keyEncryptation = ""
            return text
        } catch {
            print("Error \(error.localizedDescription)")
            return nil
        }
    }
    
    func addTextDecrypted(identifier: UUID, text: String?) {
        guard let text = text else {
            return
        }
        if let index = pages.firstIndex(where: {$0.identifier == identifier}) {
            pages[index].text = text
            
        }
    }
}
