//
//  AppLocalisations.swift
//  UdemosClient
//
//  Created by Sinisa Abramovic on 25.03.2023..
//

import Foundation

enum Localisations {
    
    static func changeLocale(with locKey: LocalisationKeys) {
        let defaults = UserDefaults.standard
        defaults.set([locKey.code], forKey: "AppleLanguages")
        defaults.synchronize()
    }
    
}

enum LocalisationKeys {
    
    case france
    case italy
    case english
    case croatian
    case german
    
    var code: String {
        switch self {
        case .france:
            return "fr"
        case .italy:
            return "it"
        case .english:
            return "en"
        case .croatian:
            return "hr"
        case .german:
            return "de"
        default:
            return "en"
        }
    }
}

enum LocalizedStringKey {
    
    case helloWorld
    case sendMessage
    case error
    case secretMessenger
    case ok
    case receivedData
    case enterMessage
    
    var key: String {
        switch self {
        case .helloWorld: return "helloWorld"
        case .sendMessage: return "sendMessage"
        case .error: return "error"
        case .secretMessenger: return "secretMessenger"
        case .ok: return "ok"
        case .receivedData: return "receivedData"
        case .enterMessage: return "enterMessage"
        }
    }
}

struct LocalizedString {
    static func localized(_ key: LocalizedStringKey) -> String {
        let lang = Locale.current.language.languageCode?.identifier ?? "en"
        if let filePath = Bundle.main.path(forResource: "LocalizedStrings", ofType: "json"),
           let jsonData = try? Data(contentsOf: URL(fileURLWithPath: filePath)),
           let json = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any],
           let langData = json[lang] as? [String: String],
           let value = langData[key.key] {
            return value
        } else {
            return key.key
        }
    }
}
