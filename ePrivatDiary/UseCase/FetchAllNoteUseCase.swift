//
//  FetchAllNoteUseCase.swift
//  ePrivatDiary
//
//  Created by Adrian Aranda Campanario on 7/7/24.
//

import Foundation

protocol FetchAllPageProtocol {
    func fetchAll() throws -> [PageModel]
}

class FetchAllPageUseCase: FetchAllPageProtocol {
    var pageDatasource: PageDataSourceProtocol
    
    init(pageDatasource: PageDataSourceProtocol = PageDataSource.shared) {
        self.pageDatasource = pageDatasource
    }
    
    func fetchAll() throws -> [PageModel] {
        try pageDatasource.fetchAll()
    }
}
