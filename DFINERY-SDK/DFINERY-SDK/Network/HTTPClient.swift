//
//  HTTPClient.swift
//  DFINERY-SDK
//
//  Created by 이영우 on 2022/04/25.
//

import Foundation

protocol HTTPClientLogic { }

final class HTTPClient: HTTPClientLogic {

  // MARK: Properties

  private let urlSession: URLSession


  // MARK: Initializers

  init(urlSession: URLSession = .shared) {
    self.urlSession = urlSession
  }

  @discardableResult
  func retrieve<T>(with request: URLRequest, as type: T.Type, completionHandler: @escaping (Result<T, NetworkError>) -> Void) -> URLSessionDataTask? where T: Decodable {
    let task = urlSession.dataTask(with: request) { data, response, error in
      if error != nil {
        completionHandler(.failure(.connectionProblem))
        return
      }
      if let response = response as? HTTPURLResponse,
         (200..<300).contains(response.statusCode) == false {
        completionHandler(.failure(.invalidResponseStatusCode(response.statusCode)))
        return
      }
      guard let data = data else {
        completionHandler(.failure(.invalidData))
        return
      }
      guard let decodedType = try? JSONDecoder().decode(type, from: data) else {
        completionHandler(.failure(.decodingError))
        return
      }
      completionHandler(.success(decodedType))
    }
    task.resume()
    return task
  }
}
