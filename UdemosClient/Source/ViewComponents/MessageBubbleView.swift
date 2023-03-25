//
//  MessageBubbleView.swift
//  UdemosClient
//
//  Created by Sinisa Abramovic on 25.03.2023..
//

import Foundation
import SwiftUI

struct MessageBubbleView: View {
    
    // MARK: - Public properties -
    
    let text: String
    let subtitle: String
    let isSentByUser: Bool
    
    // MARK: - View -
    
    var body: some View {
        HStack {
            if !isSentByUser {
                Circle()
                    .fill(Color(.systemGreen))
                    .frame(width: 12, height: 12)
                    .padding(.trailing, AppDefines.Visuals.Padding.smallPadding)
            } else {
                Spacer()
            }
            VStack(alignment: .leading) {
                Text(text)
                    .padding(AppDefines.Visuals.Padding.defaultPadding)
                    .background(Color(.systemGray6))
                    .cornerRadius(AppDefines.Visuals.CornerRadius.defaultCornerRadius)
                
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            if isSentByUser {
                Circle()
                    .fill(Color.blue)
                    .frame(width: 12, height: 12)
                    .padding(.leading, AppDefines.Visuals.Padding.smallPadding)
            } else {
                Spacer()
            }
        }
    }
}
