//
//  ContentView.swift
//  TranslateMe
//
//  Created by Brianna Thelwell on 4/1/26.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var viewModel = TranslationViewModel()
    @State private var showingHistory = true
    
    var body: some View {
        
        NavigationView {
            
            VStack(spacing: 20) {
                
                // Language selection
                HStack {
                    
                    LanguagePicker(selectedLanguage: $viewModel.sourceLanguage, title: "From")
                    Button(action: viewModel.swapLanguages) {
                        
                        Image(systemName: "arrow.left.arrow.right")
                            .font(.title2)
                            .foregroundColor(.mint)
                            .padding()
                        
                    }
                    
                    LanguagePicker(selectedLanguage: $viewModel.targetLanguage, title: "To")
                    
                }
                
                .padding(.horizontal)
                
                // Input field
                VStack(alignment: .leading) {
                    
                    Text("Enter text to translate")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    TextEditor(text: $viewModel.sourceText)
                        .frame(height: 120)
                        .padding(8)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                    
                }
                
                .padding(.horizontal)
                
                // Translate button
                Button(action: viewModel.translate) {
                    
                    HStack {
                        
                        if viewModel.isLoading {
                            
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle())
                            
                        } else {
                            
                            Image(systemName: "globe")
                            Text("Translate")
                            
                        }
                        
                    }
                    
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.mint)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    
                }
                
                .disabled(viewModel.sourceText.isEmpty || viewModel.isLoading)
                .padding(.horizontal)
                
                // Output field
                VStack(alignment: .leading) {
                    
                    Text("Translation")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    TextEditor(text: $viewModel.translatedText)
                        .frame(height: 120)
                        .padding(8)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .disabled(true)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                    
                }
                
                .padding(.horizontal)
                
                // Error message
                if let error = viewModel.errorMessage {
                    
                    Text(error)
                        .foregroundColor(.red)
                        .font(.caption)
                        .padding(.horizontal)
                    
                }
                
                // History section
                if showingHistory {
                    
                    TranslationHistoryView(viewModel: viewModel)
                        .frame(maxHeight: .infinity)
                    
                }
                
            }
            .navigationTitle("TranslationMe")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingHistory.toggle() }) {
                        Image(systemName: showingHistory ? "clock.fill" : "clock")
                    }
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    // Always keep a view here, but hide it when needed
                    if !viewModel.translations.isEmpty {
                        Button("Clear All") {
                            viewModel.clearHistory()
                        }
                        .foregroundColor(.red)
                    } else {
                        // Invisible placeholder to maintain layout
                        Color.clear
                            .frame(width: 0, height: 0)
                    }
                }
            }
            
        }
        
    }
    
}

// LanguagePicker stuffffff
struct LanguagePicker: View {
    
    @Binding var selectedLanguage: String
    let title: String
    
    let languages = [
        ("en", "English"),
        ("es", "Spanish"),
        ("fr", "French"),
        ("de", "German"),
        ("it", "Italian"),
        ("pt", "Portuguese"),
        ("ru", "Russian"),
        ("ja", "Japanese"),
        ("ko", "Korean"),
        ("zh", "Chinese")
    ]
    
    var body: some View {
        
        Picker(title, selection: $selectedLanguage) {
            
            ForEach(languages, id: \.0) { code, name in
                Text(name).tag(code)
                
            }
            
        }
        
        .pickerStyle(MenuPickerStyle())
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
        .background(Color(.systemGray6))
        .cornerRadius(8)
        
    }
    
}

