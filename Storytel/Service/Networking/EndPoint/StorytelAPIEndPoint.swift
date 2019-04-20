//
//  StorytelAPIEndPoint.swift
//  NetworkLayer
//
// source: https://medium.com/flawless-app-stories/writing-network-layer-in-swift-protocol-oriented-approach-4fa40ef1f908

import Foundation


public enum StorytelAPI {
    case searchBooks(query: String, page: String)
}

extension StorytelAPI: EndPointType {
    
    /** API base urls. */
    var environmentBaseURL : String {
        switch StorytelAPINetworkManager.environment {
        case .production:
            return "https://api.storytel.net/"
        default:
            return "https://api.storytel.net/"
        }
    }
    
    var baseURL: URL {
        guard let url = URL(string: environmentBaseURL) else { fatalError("baseURL could not be configured.")}
        return url
    }
    /** API path for specific request. */
    var path: String {
        switch self {
        case .searchBooks:
            return "search"
        }
    }
    
    var httpMethod: HTTPMethod {
        return .get
    }
    
    /** generate task based on requested StorytelAPI. */
    var task: HTTPTask {
        switch self {
        //https://api.storytel.net/search?query=harry&page=10
        case .searchBooks(let query, let page):
            return .requestParameters(bodyParameters: nil,
                                      bodyEncoding: .urlEncoding ,
                                      urlParameters: ["query": query,
                                                      "page": page])
        }
    }
    
    var headers: HTTPHeaders? {
        return nil
    }
}



