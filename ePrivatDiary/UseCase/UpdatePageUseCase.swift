//
//  UpdatePageUseCase.swift
//  ePrivatDiary
//
//  Created by Adrian Aranda Campanario on 7/7/24.
//

import Foundation

protocol UpdatePageProtocol {
    func update(identifier: UUID, title: String, textEncrypted: Data?, feedback: Feedback) throws
}

struct UpdatePageUseCase: UpdatePageProtocol {
    var pageDatasource: PageDataSourceProtocol
    
    init(pageDatasource: PageDataSourceProtocol = PageDataSource.shared) {
        self.pageDatasource = pageDatasource
    }
    
    func update(identifier: UUID, title: String, textEncrypted: Data?, feedback: Feedback) throws {
        try pageDatasource.update(identifier: identifier, title: title, textEncrypted: textEncrypted, feedback: feedback)
    }
}
