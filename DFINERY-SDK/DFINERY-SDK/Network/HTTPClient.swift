//
//  HTTPClient.swift
//  DFINERY-SDK
//
//  Created by 이영우 on 2022/04/21.
//

import Foundation

protocol HTTPClientLogic {
  func createEvent(appKey: String, eventName: String, eventProperties: [String: Any]?, userProperties: [String: Any]?, userAdvertisement: UserAdvertisement, location: Location?, completionHandler: @escaping (Result<EventAdditionResponse, NetworkError>) -> Void) -> URLSessionDataTask?
}

public final class HTTPClient: HTTPClientLogic {

  // MARK: Properties

  private let urlSession: URLSession
  private let requestBuilder: RequestBuilderLogic


  // MARK: Initializers

  init(urlSession: URLSession = .shared, requestBuilder: RequestBuilderLogic = RequestBuilder()) {
    self.urlSession = urlSession
    self.requestBuilder = requestBuilder
  }

  @discardableResult
  public func createEvent(appKey: String, eventName: String, eventProperties: [String: Any]?, userProperties: [String: Any]?, userAdvertisement: UserAdvertisement, location: Location?, completionHandler: @escaping (Result<EventAdditionResponse, NetworkError>) -> Void) -> URLSessionDataTask? {
    let httpBody = self.requestBuilder.httpRequestBody(
      with: appKey,
      eventName: eventName,
      eventProperties: eventProperties,
      userProperties: userProperties,
      userAdvertisement: userAdvertisement,
      location: location
    )
    guard let request = NetworkRequestRouter
      .createEvent
      .asURLRequest(with: httpBody) else {
      completionHandler(.failure(.invalidRequest))
      return nil
    }
    return self.retrieve(
      with: request,
      as: EventAdditionResponse.self,
      completionHandler: completionHandler
    )
  }

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
