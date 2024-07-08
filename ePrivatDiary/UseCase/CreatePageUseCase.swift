//
//  CreatePageUseCase.swift
//  ePrivatDiary
//
//  Created by Adrian Aranda Campanario on 7/7/24.
//

import Foundation

protocol CreatePageProtocol {
    func createPage(title: String, text: Data?, feedback: Feedback) throws
}

struct CreatePageUseCase: CreatePageProtocol {
    var pageDatasource: PageDataSourceProtocol
    
    init(pageDatasource: PageDataSourceProtocol = PageDataSource.shared) {
        self.pageDatasource = pageDatasource
    }
    
    func createPage(title: String, text: Data?, feedback: Feedback) throws {
        let page: PageModel = .init(identifier: .init(), title: title, encripted: text, createdAt: .now, feedback: feedback)
        try pageDatasource.insert(page: page)
    }
}
