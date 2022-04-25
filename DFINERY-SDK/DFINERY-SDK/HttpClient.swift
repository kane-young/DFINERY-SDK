//
//  HttpClient.swift
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

  private func retrieve<T>(with request: URLRequest, as type: T.Type, completionHandler: @escaping (Result<T, Error>) -> Void) -> URLSessionDataTask? where T: Decodable {
    return nil
  }
}
