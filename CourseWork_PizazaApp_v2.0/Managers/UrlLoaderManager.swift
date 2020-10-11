//
//  NetworkLoader.swift
//  CourseWork_PizazaApp_v2.0
//
//  Created by Vladislav Sharaev on 9/20/20.
//  Copyright © 2020 Vladislav Sharaev. All rights reserved.
//

import Foundation

class UrlLoaderManager {
    static var shared = UrlLoaderManager()
    lazy var configuration: URLSessionConfiguration = URLSessionConfiguration.default
    lazy var session: URLSession = URLSession(configuration: self.configuration)
    
    func downloadImage(url: URL, completion: @escaping((Result<Data, NetworkError>) -> Void)) {
        let request = URLRequest(url: url)
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            if error == nil {
                if (response as? HTTPURLResponse) != nil {
                    if let data = data {
                        completion(.success(data))
                    } else {
                        completion(.failure(.requestFailed))
                    }
                }
            } else {
                print("Error donwload data \(error!.localizedDescription)")
                completion(.failure(.unknown))
            }
        }
        dataTask.resume()
    }
}
