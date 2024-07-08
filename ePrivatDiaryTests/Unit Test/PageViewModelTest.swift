//
//  PageViewModelTest.swift
//  ePrivatDiaryTests
//
//  Created by Adrian Aranda Campanario on 7/7/24.
//

import XCTest
@testable import ePrivatDiary

final class PageViewModelTest: XCTestCase {

    var viewModel: PageViewModel!
    
    override func setUpWithError() throws {
        viewModel = .init(keyEncryptation: "123", createPageUseCase: CreatePageUseCaseMock(),
                          fetchAllPagesUseCase: FetchAllPagesUseCaseMock(),
                          updatePageUseCase: UpdatePageUseCaseMock(),
                          removePageUseCase: RemovePageUseCaseMock())
    }

    override func tearDownWithError() throws {
        mockDatabase = []
    }
    
    func testCreatePage() {
        //Given
        let title = "Test Title"
        let text = "Test Text"
        let feedback: Feedback = .happy
        //When
        viewModel.createPage(title: title, text: text, feedback: feedback)
        
        //Then
        XCTAssertEqual(viewModel.pages.count, 1)
        XCTAssertEqual(viewModel.pages.first?.title, title)
        XCTAssertNil(viewModel.pages.first?.text)
        XCTAssertEqual(viewModel.pages.first?.feedback, feedback)
        XCTAssertNotNil(viewModel.pages.first?.encripted)
    }
    
    func testCreateTwoPages() {
        //Given
        let title = "Test Title"
        let text = "Test Text"
        let feedback: Feedback = .happy
        let title2 = "Test Title 2"
        let text2 = "Test Text 2"
        let feedback2: Feedback = .sad
        //When
        viewModel.createPage(title: title, text: text, feedback: feedback)
        viewModel.createPage(title: title2, text: text2, feedback: feedback2)
        
        //Then
        XCTAssertEqual(viewModel.pages.count, 2)
        XCTAssertEqual(viewModel.pages.first?.title, title)
        XCTAssertNil(viewModel.pages.first?.text)
        XCTAssertEqual(viewModel.pages.first?.feedback, feedback)
        XCTAssertNotNil(viewModel.pages.first?.encripted)
        
        XCTAssertEqual(viewModel.pages[1].title, title2)
        XCTAssertNil(viewModel.pages[1].text)
        XCTAssertEqual(viewModel.pages[1].feedback, feedback2)
        XCTAssertNotNil(viewModel.pages[1].encripted)
    }
    
    func testCreateEmptyText() {
        //Given
        let title = "Test Title"
        let text = ""
        let feedback: Feedback = .happy
        //When
        viewModel.createPage(title: title, text: text, feedback: feedback)
        
        //Then
        XCTAssertEqual(viewModel.pages.count, 1)
        XCTAssertEqual(viewModel.pages.first?.title, title)
        XCTAssertNil(viewModel.pages.first?.text)
        XCTAssertEqual(viewModel.pages.first?.feedback, feedback)
        XCTAssertNotNil(viewModel.pages.first?.encripted)
    }
    
    func testUpdatePage() {
        //Given
        let title = "Test title"
        let text = "Test text"
        let feedback: Feedback = .happy
        viewModel.createPage(title: title, text: text, feedback: feedback)
        
        let newTitle = "New Title"
        let newText = "New Text"
        let newFeedback: Feedback = .sad
        
        //When
        if let identifier = viewModel.pages.first?.identifier {
            viewModel.updatePage(identifier: identifier, title: newTitle, text: newText, feedback: newFeedback)
            //Then
            XCTAssertEqual(viewModel.pages.first?.title, newTitle)
            XCTAssertEqual(viewModel.pages.first?.feedback, newFeedback)
            XCTAssertNotNil(viewModel.pages.first?.encripted)
        } else {
            XCTFail()
        }
    }
    
    func testRemovePage() {
        //Given
        viewModel.createPage(title: "test title", text: "test text", feedback: .happy)
        //When
        if let identifier = viewModel.pages.first?.identifier {
        //Then
            viewModel.removePage(identifier: identifier)
            XCTAssertTrue(viewModel.pages.isEmpty)
        } else {
            XCTFail()
        }
    }
}
