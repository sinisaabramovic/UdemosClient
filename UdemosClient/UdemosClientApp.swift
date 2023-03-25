//
//  UdemosClientApp.swift
//  UdemosClient
//
//  Created by Sinisa Abramovic on 21.03.2023..
//

import SwiftUI

@main
struct UdemosClientApp: App {
    
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {        
        WindowGroup {
            MessangerView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
