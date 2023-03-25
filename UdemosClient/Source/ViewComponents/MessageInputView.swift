//
//  MessageInputView.swift
//  UdemosClient
//
//  Created by Sinisa Abramovic on 24.03.2023..
//

import SwiftUI

struct MessageInputView: View {
    
    // MARK: - Public properties -
    
    @Binding var inputMessage: String
    
    // MARK: - View -
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppDefines.Visuals.Spacing.mediumSpacing) {
            Text(LocalizedString.localized(.enterMessage))
                .font(.title2)
                .fontWeight(.bold)
            
            TextEditor(text: $inputMessage)
                .frame(minHeight: 34, maxHeight: 68)
                .padding(.horizontal)
                .multilineTextAlignment(.leading)
                .disableAutocorrection(true)
                .autocapitalization(.none)
                .overlay(
                    RoundedRectangle(cornerRadius: AppDefines.Visuals.CornerRadius.defaultCornerRadius)
                        .stroke(Color.gray, lineWidth: 1)
                )
        }
        .padding(.horizontal)
    }
}

