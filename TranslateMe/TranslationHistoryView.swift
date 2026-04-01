//
//  TranslationHistoryView.swift
//  TranslateMe
//
//  Created by Sean Thelwell on 4/6/26.
//
//just translation history view
import SwiftUI

struct TranslationHistoryView: View {
    @ObservedObject var viewModel: TranslationViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Translation History")
                    .font(.headline)
                    .padding(.horizontal)
                
                Spacer()
                
                Text("\(viewModel.translations.count) items")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(.horizontal)
            }
            
            if viewModel.translations.isEmpty {
                VStack(spacing: 20) {
                    Image(systemName: "clock.arrow.circlepath")
                        .font(.system(size: 50))
                        .foregroundColor(.gray)
                    Text("No translations yet")
                        .foregroundColor(.gray)
                    Text("Your translations will appear here")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 40)
            } else {
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(viewModel.translations) { translation in
                            TranslationHistoryCard(
                                translation: translation,
                                onTap: { viewModel.selectTranslation(translation) }
                            )
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
        .padding(.top)
        .background(Color(.systemGray6))
        .cornerRadius(15)
        .padding(.horizontal)
    }
}
