//
//  SimpleReceivedDataView.swift
//  UdemosClient
//
//  Created by Sinisa Abramovic on 28.03.2023..
//

import Foundation
import SwiftUI

struct SimpleReceivedDataView: View {
    
    // MARK: - Public properties -
    
    @ObservedObject var viewModel: SimpleSecretMessageViewModel
    
    // MARK: - View -
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppDefines.Visuals.Spacing.smallSpacing) {
            Text(LocalizedString.localized(.receivedData))
                .font(.title2)
                .fontWeight(.bold)
            
            List {
                ForEach(viewModel.messages, id: \.self) {
                    MessageBubbleView(
                        text: $0.message,
                        subtitle: "simple message",
                        isSentByUser: true
                    )
                    .listRowBackground(Color.white)
                    .listRowSeparator(.hidden)
                }
            }
            .background(Color.white)
            .scrollContentBackground(.hidden)
        }
        .padding(EdgeInsets(top: 12, leading: 2, bottom: 4, trailing: 2))
        .frame(maxWidth: .infinity, alignment: .center)
        .background(Color.white)
        .edgesIgnoringSafeArea(.bottom)
    }
}
