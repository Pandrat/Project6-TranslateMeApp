//
//  TranslationHistoryCard.swift
//  TranslateMe
//
//  Created by Sean Thelwell on 4/6/26.
//

// just translation history card
import SwiftUI

struct TranslationHistoryCard: View {
    let translation: Translation
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("\(translation.sourceLanguage.uppercased()) → \(translation.targetLanguage.uppercased())")
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.mint.opacity(0.1))
                        .cornerRadius(6)
                    
                    Spacer()
                    
                    Text(formatDate(translation.timestamp))
                        .font(.caption2)
                        .foregroundColor(.gray)
                }
                
                Text(translation.sourceText)
                    .font(.subheadline)
                    .foregroundColor(.primary)
                    .lineLimit(2)
                
                Text(translation.translatedText)
                    .font(.body)
                    .foregroundColor(.mint)
                    .lineLimit(2)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
