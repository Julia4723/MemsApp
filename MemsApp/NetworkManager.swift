//
//  NetworkManager.swift
//  MemsApp
//
//  Created by user on 03.02.2025.
//

import UIKit
import Alamofire

class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    func fetchAF(completion: @escaping (Result<[Meme], AFError>) -> Void) {
        let URLString = "https://api.imgflip.com/get_memes"
        
        guard let url = URL(string: URLString) else {return}
        
        let decoder = JSONDecoder()
        
        AF.request(url)
            .validate()
            .responseDecodable(of: ResponseWrapper.self, decoder: decoder) { response in
                switch response .result {
                case .success(let modelResponse):
                    print("Success: \(modelResponse)")
                    completion(.success(modelResponse.data.memes))
                case .failure(let error):
                    print("Error \(error)")
                    completion(.failure(error))
                }
            }
    }
    
    
}

