//
//  PageViewModelIntegrationTest.swift
//  ePrivatDiaryTests
//
//  Created by Adrian Aranda Campanario on 8/7/24.
//

import XCTest
@testable import ePrivatDiary

final class PageViewModelIntegrationTest: XCTestCase {
    
    var sut: PageViewModel!

    @MainActor
    override func setUpWithError() throws {
        let database = PageDataSource.shared
        database.container = PageDataSource.setupContainer(inMemory: true)
        
        let createPageUseCase = CreatePageUseCase(pageDatasource: database)
        let updatePageUseCase = UpdatePageUseCase(pageDatasource: database)
        let fetchAllPageUseCase = FetchAllPageUseCase(pageDatasource: database)
        let removePageUseCase = RemovePageUseCase(pageDatasource: database)
        
        sut = PageViewModel(keyEncryptation: "123",
                            createPageUseCase: createPageUseCase,
                            fetchAllPagesUseCase: fetchAllPageUseCase,
                            updatePageUseCase: updatePageUseCase,
                            removePageUseCase: removePageUseCase)
    }

    func testCreatePage() {
        //Given
        sut.createPage(title: "Test title", text: "Test text", feedback: .happy)
        //When
        let page = sut.pages.first
        //Then
        XCTAssertNotNil(page)
        XCTAssertEqual(page?.title, "Test title")
        XCTAssertEqual(page?.feedback, .happy)
        XCTAssertNotNil(page?.encripted)
        XCTAssertEqual(sut.pages.count, 1)
    }
    
    func testFetchAllPages() {
        //Given
        sut.createPage(title: "Test title", text: "Test text", feedback: .happy)
        sut.createPage(title: "Test title 2", text: "Test text 2", feedback: .sad)
        //When
        let page1 = sut.pages[0]
        let page2 = sut.pages[1]
        
        //Then
        
        XCTAssertEqual(sut.pages.count, 2)
        XCTAssertEqual(page1.title, "Test title")
        XCTAssertEqual(page1.feedback, .happy)
        XCTAssertNotNil(page1.encripted)
        XCTAssertEqual(page2.title, "Test title 2")
        XCTAssertEqual(page2.feedback, .sad)
        XCTAssertNotNil(page2.encripted)
    }
    
    func testUpdatePage() {
        //Given
        sut.createPage(title: "Test title", text: "Test text", feedback: .happy)
        let newTitle = "New title"
        let newText = "New text"
        let newFeedback:Feedback = .sad
        //When
        if let page = sut.pages.first {
            sut.updatePage(identifier: page.identifier, title: newTitle, text: newText, feedback: newFeedback)
            sut.fetchAllPages()
            //Then
            XCTAssertEqual(sut.pages.count, 1)
            XCTAssertEqual(sut.pages.first?.title, newTitle)
            XCTAssertEqual(sut.pages.first?.feedback, newFeedback)
            XCTAssertNotNil(sut.pages.first?.encripted)
        }
    }
    
    func testDeletePage() {
        //Given
        sut.createPage(title: "Test title", text: "Test text", feedback: .happy)
        //When
        if let page = sut.pages.first {
            sut.removePage(identifier: page.identifier)
            //Then
            XCTAssertTrue(sut.pages.isEmpty)
        } else {
            XCTFail()
        }
    }
    
    func testRemovePageInDatabaseShouldThrowError() {
        sut.removePage(identifier: UUID())
        
        XCTAssertEqual(sut.pages.count, 0)
        XCTAssertNotNil(sut.datasourceError)
        XCTAssertEqual(sut.datasourceError, DatabaseError.errorRemove)
    }
}
