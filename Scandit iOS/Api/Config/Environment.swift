//
//  Environment.swift
//  Scandit iOS
//
//  Created by 67881458 on 20/05/2020.
//  Copyright © 2020 Informática El Corte Inglés S.A. All rights reserved.
//

//TAKE CONFIG ENVIRONMENTS FROM Info.plist file
import Foundation

public enum Environment {
    // MARK: - Plist values
    //    static let baseURL: String = "localhost"
    static let baseURL: String = "https://uo258273.github.io"
    // MARK: - Keys
    enum Keys : String {
        case apiKey = "GOOGLE_API_KEY"
        case rtmBaseURL = "BASE_URL_RTM"
        case redsysBaseURL = "BASE_URL_REDSYS"
        case iecisaBaseURL = "BASE_URL_IECISA"
        case dobApiKey = "DOB_SDK_KEY"
    }
    
    // MARK: - Plist file
    private static let infoDictionary: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("Info.plist file not found")
        }
        return dict
    }()
    
    
}
