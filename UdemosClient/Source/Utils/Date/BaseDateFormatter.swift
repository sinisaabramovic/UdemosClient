//
//  BaseDateFormatter.swift
//  UdemosClient
//
//  Created by Sinisa Abramovic on 25.03.2023..
//

import Foundation

final class BaseDateFormatter {
    
    static var dateFormatterForSecretServer: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter
    }
}
