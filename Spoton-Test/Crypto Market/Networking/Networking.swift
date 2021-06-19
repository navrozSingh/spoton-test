//
//  CryptoListViewController.swift
//  Spoton-Test
//
//  Created by Navroz on 19/06/21.
//

import Foundation
import Combine
import Alamofire

/// NetworkingConfiguration & EndPointConfiguration
/// are creted for mocking purposes
///
protocol NetworkingConfiguration {
    func request<T: Codable>(_ url: String,
                                method: HTTPMethod) -> AnyPublisher<Result<T, AFError>, Never>
}

protocol EndPointConfiguration {
    var path: String { get }
    var httpMethod: HTTPMethod { get }
}

class Networking: NetworkingConfiguration {
    
    func request<T: Codable>(_ url: String,
                             method: HTTPMethod) -> AnyPublisher<Result<T, AFError>, Never> {
        let publisher = AF.request(url, method: method)
            .validate()
            .publishDecodable(type: T.self)
        return publisher.result()
    }
    
}

class EndPoint: EndPointConfiguration {
    var path: String {
        "https://api.coincap.io/v2/assets?limit=20&offset=0"
    }
    
    var httpMethod: HTTPMethod {
        .get
    }
}
