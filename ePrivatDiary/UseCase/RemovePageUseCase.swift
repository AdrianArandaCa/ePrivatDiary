//
//  RemovePageProtocol.swift
//  ePrivatDiary
//
//  Created by Adrian Aranda Campanario on 7/7/24.
//

import Foundation

protocol RemovePageProtocol {
    func remove(identifier: UUID) throws
}

class RemovePageUseCase: RemovePageProtocol {
    
    var pageDatasource: PageDataSourceProtocol
    
    init(pageDatasource: PageDataSourceProtocol = PageDataSource.shared) {
        self.pageDatasource = pageDatasource
    }
    
    func remove(identifier: UUID) throws {
        try pageDatasource.remove(identifier: identifier)
    }
    
}
