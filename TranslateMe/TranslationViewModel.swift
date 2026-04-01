//
//  TranslationViewModel.swift
//  TranslateMe
//
//  Created by Sean Thelwell on 4/1/26.
//

import Foundation
import FirebaseFirestore
import Combine

class TranslationViewModel: ObservableObject {
    @Published var sourceText = ""
    @Published var translatedText = ""
    @Published var sourceLanguage = "en"
    @Published var targetLanguage = "es"
    @Published var translations: [Translation] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let db = Firestore.firestore()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        fetchTranslationHistory()
    }
    
    func translate() {
        guard !sourceText.trimmingCharacters(in: .whitespaces).isEmpty else {
            errorMessage = "Please enter text to translate"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        // Use URLComponents for proper encoding
        var components = URLComponents(string: "https://api.mymemory.translated.net/get")
        components?.queryItems = [
            URLQueryItem(name: "q", value: sourceText),
            URLQueryItem(name: "langpair", value: "\(sourceLanguage)|\(targetLanguage)")
        ]
        
        guard let url = components?.url else {
            errorMessage = "Invalid URL"
            isLoading = false
            return
        }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: MyMemoryResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.errorMessage = "Translation failed: \(error.localizedDescription)"
                }
            } receiveValue: { [weak self] response in
                // The API response should already be decoded properly
                self?.translatedText = response.responseData.translatedText
                self?.saveTranslation()
            }
            .store(in: &cancellables)
    }
    
    private func saveTranslation() {
        let newTranslation = Translation(
            sourceText: sourceText,
            translatedText: translatedText,
            sourceLanguage: sourceLanguage,
            targetLanguage: targetLanguage
        )
        
        do {
            _ = try db.collection("translations").addDocument(from: newTranslation)
            fetchTranslationHistory() // Refresh history
        } catch {
            errorMessage = "Failed to save translation: \(error.localizedDescription)"
        }
    }
    
    func fetchTranslationHistory() {
        db.collection("translations")
            .order(by: "timestamp", descending: true)
            .limit(to: 50)
            .addSnapshotListener { [weak self] snapshot, error in
                if let error = error {
                    self?.errorMessage = "Failed to fetch history: \(error.localizedDescription)"
                    return
                }
                
                self?.translations = snapshot?.documents.compactMap { document in
                    try? document.data(as: Translation.self)
                } ?? []
            }
    }
    
    func clearHistory() {
        let batch = db.batch()
        let translationsRef = db.collection("translations")
        
        translations.forEach { translation in
            if let id = translation.id {
                let docRef = translationsRef.document(id)
                batch.deleteDocument(docRef)
            }
        }
        
        batch.commit { [weak self] error in
            if let error = error {
                self?.errorMessage = "Failed to clear history: \(error.localizedDescription)"
            } else {
                self?.translations.removeAll()
            }
        }
    }
    
    func swapLanguages() {
        let temp = sourceLanguage
        sourceLanguage = targetLanguage
        targetLanguage = temp
        
        // Clear the translation when swapping
        translatedText = ""
        errorMessage = nil
    }
    
    func selectTranslation(_ translation: Translation) {
        sourceText = translation.sourceText
        translatedText = translation.translatedText
        sourceLanguage = translation.sourceLanguage
        targetLanguage = translation.targetLanguage
    }
}
