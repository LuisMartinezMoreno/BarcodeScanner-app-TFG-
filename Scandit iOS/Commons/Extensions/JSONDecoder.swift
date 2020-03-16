//
//  JSONDecoder.swift
//  RCI Aceptacion Online
//
//  Created by Bienvenido Fernández Lora on 14/12/2018.
//  Copyright © 2018 Informática El Corte Inglés. All rights reserved.
//

//Extensión de JSONDecoder que parsea una respuesta del tipo DataResponse de Alamofire 4
// y lo transforma a un objeto Codable.
//TODO: MIGRAR a AlamoFire 5 cuando salga de fase beta. Esta extensión dejará de ser necesaria.

import Alamofire

extension JSONDecoder {
    func decodeResponse<T: Decodable>(from response: DataResponse<Data>) -> Swift.Result<T, Error> {
        
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
