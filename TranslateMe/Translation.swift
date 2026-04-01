//
//  Translation.swift
//  TranslateMe
//
//  Created by Sean Thelwell on 4/1/26.
//

import Foundation
import FirebaseFirestore

struct Translation: Identifiable, Codable {
    @DocumentID var id: String?
    let sourceText: String
    let translatedText: String
    let sourceLanguage: String
    let targetLanguage: String
    let timestamp: Date
    
    init(sourceText: String, translatedText: String, sourceLanguage: String, targetLanguage: String) {
        self.sourceText = sourceText
        self.translatedText = translatedText
        self.sourceLanguage = sourceLanguage
        self.targetLanguage = targetLanguage
        self.timestamp = Date()
    }
}

// Models/APIResponse.swift
struct MyMemoryResponse: Codable {
    let responseData: ResponseData
    
    struct ResponseData: Codable {
        let translatedText: String
    }
}
