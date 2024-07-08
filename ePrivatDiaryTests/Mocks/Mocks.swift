//
//  Mocks.swift
//  ePrivatDiaryTests
//
//  Created by Adrian Aranda Campanario on 7/7/24.
//

import XCTest
@testable import ePrivatDiary

var mockDatabase: [PageModel] = []

struct CreatePageUseCaseMock: CreatePageProtocol {
    func createPage(title: String, text: Data?, feedback: ePrivatDiary.Feedback) throws {
        let page = PageModel(identifier: .init(), title: title, encripted: text, createdAt: .now, feedback: feedback)
        mockDatabase.append(page)
    }
}

struct UpdatePageUseCaseMock: UpdatePageProtocol {
    func update(identifier: UUID, title: String, textEncrypted: Data?, feedback: ePrivatDiary.Feedback) throws {
        if let index = mockDatabase.firstIndex(where: { $0.identifier == identifier }) {
            mockDatabase[index].title = title
            mockDatabase[index].encripted = textEncrypted
            mockDatabase[index].feedback = feedback
        }
    }
}

struct FetchAllPagesUseCaseMock: FetchAllPageProtocol {
    func fetchAll() throws -> [ePrivatDiary.PageModel] {
        return mockDatabase
    }
}

struct RemovePageUseCaseMock: RemovePageProtocol {
    func remove(identifier: UUID) throws {
        if let index = mockDatabase.firstIndex(where: { $0.identifier == identifier }) {
            mockDatabase.remove(at: index)
        }
    }
}
