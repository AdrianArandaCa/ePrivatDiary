//
//  PageModel.swift
//  ePrivatDiary
//
//  Created by Adrian Aranda Campanario on 7/7/24.
//

import Foundation
import SwiftData

enum Feedback: Codable {
    case sad
    case happy
    case neutral
}

@Model
class PageModel: Identifiable, Hashable {
    @Attribute(.unique) var identifier: UUID
    var title: String
    var text: String?
    var createdAt: Date
    var feedback: Feedback
    var encripted: Data? = nil
    
    var getText: String {
        text ?? ""
    }
    
    init(identifier: UUID = UUID(), title: String, text: String? = nil, encripted: Data?, createdAt: Date, feedback: Feedback) {
        self.identifier = identifier
        self.title = title
        self.text = text
        self.createdAt = createdAt
        self.feedback = feedback
        self.encripted = encripted
    }
}
