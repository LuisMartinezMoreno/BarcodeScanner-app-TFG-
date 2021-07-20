//
//  JSONDecoder.swift
//  Scandit iOS
//
//  Created by Luis Martínez Moreno on 20/04/21.
//  Copyright © 2021 IECISA. All rights reserved.
//

//Extensión de JSONDecoder que parsea una respuesta del tipo DataResponse de Alamofire 5
// y lo transforma a un objeto Codable.

import Alamofire

extension JSONDecoder {
    func decodeResponse<T: Decodable>(from response: DataResponse<Data,Error>) -> Swift.Result<T, Error> {
        
        guard response.error == nil else {
            return .failure(response.error!)
        }

        guard let responseData = response.data else {
            return .failure(NSError(domain: "", code: response.response!.statusCode, userInfo: nil))
        }

        do {
            let item = try decode(T.self, from: responseData)
            return .success(item)
        } catch {
            print(error)
            return .failure(error)
        }
    }
}
