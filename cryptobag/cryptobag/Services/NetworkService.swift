//
//  NetworkService.swift
//  cryptobag
//
//  Created by Rafael Shamsutdinov on 04.04.2023.
//

import Foundation
import Alamofire

class NetworkService {
    public static let shared = NetworkService()
    func getData(from url: String, completion: @escaping (Data) -> Void) {
        AF.request(url).responseString() { response in
            let data = response.data!
            completion(data)
        }
    }
}


