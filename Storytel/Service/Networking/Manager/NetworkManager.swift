//
//  NetworkManager.swift
//  NetworkLayer
//
//

import Foundation


protocol StorytelAPINetworkProtocol {
    init(environment: NetworkEnvironment)
    /**
     Search Books's data, that contain query's string,  based on StorytelAPI
     - Parameter query: search keyword for book list
     - Parameter page: requested page of book list
     - Parameter completion: block to handle the Search results
     */
    func searchBooks(query: String, page: String, completion: @escaping (_ queryBooksResponse: QueryBooksResponse?,_ error: String?)->())
    
}

class StorytelAPINetworkManager: StorytelAPINetworkProtocol {
    static var environment : NetworkEnvironment = .production
    let router = Router<StorytelAPI>()
    
    required init(environment: NetworkEnvironment) {
        StorytelAPINetworkManager.environment = environment
    }
    
    /**
     Search Books's data, that contain query's string,  based on StorytelAPI
     - Parameter query: search keyword for book list
     - Parameter page: requested page of book list
     - Parameter completion: block to handle the Search results
     */
    func searchBooks(query: String, page: String, completion: @escaping (_ queryBooksResponse: QueryBooksResponse?,_ error: String?)->()) {
        router.request(.searchBooks(query: query, page: page) ) { (data, response, error) in
            guard let data = data, error == nil else {
                completion(nil, error)
                return
            }
            do {
                /*let jsonData = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                print(jsonData)*/
                let queryBooksResponse = try JSONDecoder().decode(QueryBooksResponse.self, from: data)
                completion(queryBooksResponse, nil)
            }catch {
                print(error)
                completion(nil, NetworkResponse.unableToDecode.rawValue)
            }
        }
    }
}
