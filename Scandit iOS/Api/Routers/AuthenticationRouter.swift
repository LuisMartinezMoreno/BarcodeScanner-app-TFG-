//
//  AuthenticationRouter.swift
//  Scandit iOS
//
//  Created by 67881458 on 20/05/2020.
//  Copyright © 2020 Informática El Corte Inglés S.A. All rights reserved.
//

import Foundation
import Alamofire

enum AunthenticationRouter: RequestGenerator {
    internal var path: String {
        return Endpoint.catalogo
    }   
    
    private enum Keys : String {
        case userName, password, oldPassword, newPassword, application, token, refreshToken
    }
    
    //MARK:- Authentication
    case login(user: String, password: String)
    case test
    case changePassword(userName: String, oldPassword: String, newPassword : String)
    case refreshToken
    case passwordRecovery(userId: String)
    
    //MARK:-
    
    internal var baseUrl: String {Environment.baseURL}
    
    internal var method: HTTPMethod {
        switch self {
        case .login,
             .changePassword,
             .refreshToken:
            return .post
        default:
            return .get
        }
    }
    
    internal var bodyParameters: Parameters? {
        switch self {
        case .login(let user, let password):
            return [Keys.userName.rawValue: user,
                    Keys.password.rawValue: password]
        case .changePassword(let userName, let oldPassword, let newPassword):
            return [Keys.userName.rawValue: userName,
                    Keys.newPassword.rawValue: newPassword,
                    Keys.oldPassword.rawValue: oldPassword,
                    Keys.application.rawValue: 1]
        case .refreshToken:
            return [Keys.token.rawValue: SessionManager.shared().getAuthToken() ?? "",
                    Keys.refreshToken.rawValue: SessionManager.shared().getRefreshToken() ?? ""] //TODO: COMPROBAR SI SE LA LA CASUISTICA
        default:
            return nil
        }
    }
    
}
