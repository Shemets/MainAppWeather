//
//  NetworkService.swift 
//  Main Weather
//
//  Created by Shemets on 30.05.22.
//

import Foundation

class NetworkService {
    public func request(stringURLSearch: String, completion: @escaping (Result<[SearchResponseElement], Error>) -> Void) {
        guard let url = URL(string: stringURLSearch) else {
            return
        }
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let data = data {
                    let searchResponceElement = try? JSONDecoder().decode([SearchResponseElement].self, from: data)
                    guard let searchResponseElement = searchResponceElement else {
                        return
                    }
                    completion(.success(searchResponseElement))
                    print(searchResponceElement)
                }
            }
        }
           task.resume()
    }
}
