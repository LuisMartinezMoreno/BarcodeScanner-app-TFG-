//
//  AuthCredentials.swift
//  Scandit iOS
//
//  Created by Luis Martínez Moreno on 17/03/21.
//  Copyright © 2021 IECISA. All rights reserved.
//

import Foundation
struct AuthCredentials : Codable {
    
    let token: String?
    
    let refreshToken: String?
    
}
