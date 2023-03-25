//
//  ReceivedDataView.swift
//  UdemosClient
//
//  Created by Sinisa Abramovic on 24.03.2023..
//

import SwiftUI

struct ReceivedDataView: View {
    
    // MARK: - Public properties -
    
    @ObservedObject var viewModel: SecretMessageViewModel
    
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
                        subtitle: "\($0.createdAt)",
                        isSentByUser: $0.sentByUser
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
