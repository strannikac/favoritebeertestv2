//
//  APIService.swift
//  FavoriteBeerTest
//
//  Created by Alexander Sokhin on 23.01.2021.
//

import Foundation

//MARK: api for requests

class APIService {
    
    enum Endpoints {
        static let base = "https://api.punkapi.com/v2/beers"
        
        case list(Int, Int)
        case image(String)
        
        var stringValue: String {
            switch self {
            case .list(let page, let perPage):
                return Endpoints.base + "?page=\(page)&per_page=\(perPage)"
            case .image(let url):
                return url
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    @discardableResult func taskForGETRequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, completion: @escaping (ResponseType?, String?) -> Void) -> URLSessionTask {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                completion(nil, error?.localizedDescription)
                return
            }
            
            let decoder = JSONDecoder()
            
            do {
                let responseObject = try decoder.decode(responseType.self, from: data)
                completion(responseObject, nil)
            } catch {
                completion(nil, error.localizedDescription)
            }
        }
        
        task.resume()
        return task
    }
    
    //MARK: list of beers
    
    func getList(page: Int, perPage: Int, completion: @escaping (_ page: Int, [BeerModel], String?) -> Void) {
        self.taskForGETRequest(url: Endpoints.list(page, perPage).url, responseType: [BeerModel].self) { response, error in
            if let response = response {
                completion(page, response, nil)
            } else {
                completion(page, [], error)
            }
        }
    }
    
    //MARK: photo
    
    func downloadImage(url: String, completion: @escaping (Data?, String?) -> Void) {
        let task = URLSession.shared.dataTask(with: Endpoints.image(url).url) { data, response, error in
            completion(data, error?.localizedDescription)
        }
        
        task.resume()
    }
    
}
