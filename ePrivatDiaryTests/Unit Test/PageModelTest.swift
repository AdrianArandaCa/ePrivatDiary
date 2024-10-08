//
//  ePrivatDiaryTests.swift
//  ePrivatDiaryTests
//
//  Created by Adrian Aranda Campanario on 7/7/24.
//

import XCTest
@testable import ePrivatDiary

final class ePrivatDiaryTests: XCTestCase {
    
    func testPageInitialization() {
        //Given
        let title = "Test title"
        let text = "Test text"
        let date = Date()
        let feedback: Feedback = .neutral
        let key = "123"
        let encryptationPageUseCase = EncryptationPageUseCase(key: key)
        //When
        do {
//            let urlApp = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).last
//                    let url = urlApp!.appendingPathComponent("default.store")
//                    if FileManager.default.fileExists(atPath: url.path) {
//                        print("swiftdata db at \(url.absoluteString)")
//                    }
            guard let encripted = try encryptationPageUseCase.encryptationPage(text: text) else {
                XCTFail()
                throw ErrorEncryptation.errorEncryptation
            }
            let page = PageModel(title: title, encripted: encripted, createdAt: date, feedback: feedback)
            //Then
            XCTAssertEqual(page.title, title)
            XCTAssertEqual(page.createdAt, date)
            XCTAssertEqual(page.feedback, feedback)
            XCTAssertEqual(page.encripted, encripted)
        } catch {
            print("Error \(error.localizedDescription)")
            XCTFail()
        }
    }
    
    func testPageEmptyText() {
        //Given
        let title = "Test title"
        let date = Date()
        let feedback: Feedback = .neutral
        let encripted: Data? = nil
        //When
        let page = PageModel(title: title, text: nil, encripted: encripted, createdAt: date, feedback: feedback)
        
        //Then
        XCTAssertEqual(page.getText, "")
        XCTAssertNil(page.encripted)
    }
    
    func testGetDate() {
        // Given
        let dateComponents = DateComponents(year: 2024, month: 7, day: 8, hour: 16, minute: 30)
        let testDate = Calendar.current.date(from: dateComponents)!
        
        //When
        let page = PageModel(title: "Test Title", encripted: nil, createdAt: testDate, feedback: .happy)
        let dateString = page.getDate()
        
        // Then
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        let expectedDate = dateFormatter.string(from: testDate)
        
        XCTAssertEqual(dateString, expectedDate)
    }
}
