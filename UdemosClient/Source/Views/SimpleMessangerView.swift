//
//  SimpleMessangerView.swift
//  UdemosClient
//
//  Created by Sinisa Abramovic on 28.03.2023..
//

import Foundation
import SwiftUI

struct SimpleMessangerView: View {
    
    // MARK: - Private properties -
    
    @StateObject private var viewModel = SimpleSecretMessageViewModel()
    @State private var isButtonDisabled = true
    
    // MARK: - View -
    
    var body: some View {
        NavigationView {
            VStack {
                if !viewModel.showError {
                    SimpleReceivedDataView(viewModel: viewModel)
                        .background(Color.clear)
                }
                
                MessageInputView(inputMessage: $viewModel.inputMessage)
                
                Spacer()
                
                Button(action: {
                    isButtonDisabled = true
                    Task {
                        await viewModel.sendEncryptedMessage()
                        viewModel.inputMessage = ""
                        isButtonDisabled = false
                    }
                }) {
                    Text(LocalizedString.localized(.sendMessage))
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(isButtonDisabled ? Color(.systemGray4) : Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(AppDefines.Visuals.CornerRadius.defaultCornerRadius)
                }
                .padding(.horizontal)
                .shadow(radius: AppDefines.Visuals.CornerRadius.defaultHalfCornerRadius)
                .disabled(viewModel.inputMessage.isEmpty)
            }
            .padding(.top, UIScreen.main.bounds.height * AppDefines.Visuals.MessangerView.topPaddingOffest)
            .padding(.horizontal)
            .background(Color.white)
            .alert(isPresented: $viewModel.showError) {
                Alert(
                    title: Text(LocalizedString.localized(.error)),
                    message: Text(viewModel.errorMessage),
                    dismissButton: .default(Text(LocalizedString.localized(.ok)))
                )
            }
            .navigationTitle(LocalizedString.localized(.secretMessenger))
            .navigationBarTitleDisplayMode(.inline)
            .edgesIgnoringSafeArea(.top)
            .onReceive(viewModel.$inputMessage) { inputMessage in
                isButtonDisabled = inputMessage.isEmpty
            }
        }
    }
}

struct SimpleMessangerView_Previews: PreviewProvider {
    static var previews: some View {
        SimpleMessangerView()
    }
}
