//
//  Api.swift
//  CTA App Viajero
//
//  Created by X14615FE on 16/10/2019.
//  Copyright © 2019 Informática El Corte Inglés S.A. All rights reserved.
//

import Foundation

struct Api {
    
    //inicializar alamofire
    static func initializeApi() {
        let interceptor = RequestInterceptor(refreshUrlRequest: AunthenticationRouter.refreshToken)
        ApiCore.setInterceptor(interceptor)
    }
    
    //Cancel all request
    static func cancelRequests() {
        ApiCore.shared().cancelAllRequests()
    }
    
}
